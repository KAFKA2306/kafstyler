param(
    [string]$Repo = 'KAFKA2306/basic_prompts',
    [int]$Issue = 1,
    [int]$PollSeconds = 30
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$root = Join-Path $env:LOCALAPPDATA 'OpenAI\CodexChatGPTBridge'
$statePath = Join-Path $root 'state.json'
$logDir = Join-Path $root 'logs'
New-Item -ItemType Directory -Force -Path $root, $logDir | Out-Null

function Write-BridgeLog([string]$Message) {
    $line = "$(Get-Date -Format o) $Message"
    Add-Content -Path (Join-Path $logDir 'bridge.log') -Value $line -Encoding utf8
}

function Load-State {
    if (-not (Test-Path $statePath)) {
        return @{ processed = @() }
    }
    try {
        $obj = Get-Content -Raw -Path $statePath | ConvertFrom-Json
        return @{ processed = @($obj.processed) }
    }
    catch {
        Write-BridgeLog "state load failed: $($_.Exception.Message)"
        return @{ processed = @() }
    }
}

function Save-State($State) {
    $State.processed = @($State.processed | Select-Object -Last 1000)
    $State | ConvertTo-Json -Depth 5 | Set-Content -Path $statePath -Encoding utf8
}

function Post-Comment([string]$Body) {
    $tmp = Join-Path ([IO.Path]::GetTempPath()) ("codex-bridge-comment-" + [Guid]::NewGuid().ToString('N') + '.md')
    try {
        Set-Content -Path $tmp -Value $Body -Encoding utf8
        & gh issue comment $Issue --repo $Repo --body-file $tmp | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "gh issue comment failed: $LASTEXITCODE" }
    }
    finally {
        Remove-Item -Path $tmp -Force -ErrorAction SilentlyContinue
    }
}

function Get-GitEvidence([string]$Cwd) {
    $e = [ordered]@{ repo_root = $null; head = $null; status = @() }
    Push-Location $Cwd
    try {
        $rootText = (& git rev-parse --show-toplevel 2>$null)
        if ($LASTEXITCODE -eq 0) {
            $e.repo_root = ($rootText | Select-Object -First 1)
            $headText = (& git rev-parse HEAD 2>$null)
            if ($LASTEXITCODE -eq 0) { $e.head = ($headText | Select-Object -First 1) }
            $statusText = @(& git status --porcelain=v1 2>$null)
            if ($LASTEXITCODE -eq 0) { $e.status = @($statusText | Select-Object -First 200) }
        }
    }
    finally {
        Pop-Location
    }
    return $e
}

function Run-CodexTask([string]$TaskId, $Spec) {
    if (-not $Spec.cwd -or -not $Spec.prompt) {
        throw 'Task JSON must contain cwd and prompt.'
    }

    $cwd = [IO.Path]::GetFullPath([string]$Spec.cwd)
    if (-not (Test-Path -LiteralPath $cwd -PathType Container)) {
        throw "cwd does not exist: $cwd"
    }

    $taskDir = Join-Path $root ('tasks\' + $TaskId)
    New-Item -ItemType Directory -Force -Path $taskDir | Out-Null
    $lastMessage = Join-Path $taskDir 'last-message.txt'
    $events = Join-Path $taskDir 'events.jsonl'
    $promptText = [string]$Spec.prompt

    Write-BridgeLog "task=$TaskId cwd=$cwd starting"
    Push-Location $cwd
    try {
        $promptText | & codex exec --json --output-last-message $lastMessage - 2>&1 |
            Tee-Object -FilePath $events | Out-Null
        $exitCode = $LASTEXITCODE
    }
    finally {
        Pop-Location
    }

    $text = if (Test-Path $lastMessage) { Get-Content -Raw -Path $lastMessage } else { '' }
    if ($text.Length -gt 45000) { $text = $text.Substring(0, 45000) + "`n...[truncated]" }
    $git = Get-GitEvidence $cwd

    $payload = [ordered]@{
        task_id = $TaskId
        exit_code = $exitCode
        cwd = $cwd
        git = $git
        finished_at = (Get-Date).ToUniversalTime().ToString('o')
    } | ConvertTo-Json -Depth 6

    $body = @"
<!-- codex-bridge:v1 role=worker task=$TaskId -->
## Codex result `$TaskId`

```json
$payload
```

### Final message

$text
"@

    Post-Comment $body
    Write-BridgeLog "task=$TaskId exit=$exitCode posted"
}

& gh auth status | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'GitHub CLI is not authenticated.' }
& codex --version | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Codex CLI is not available.' }

Write-BridgeLog "daemon started repo=$Repo issue=$Issue poll=${PollSeconds}s"

while ($true) {
    try {
        $state = Load-State
        $processed = New-Object 'System.Collections.Generic.HashSet[string]'
        foreach ($id in @($state.processed)) {
            if ($null -ne $id) { [void]$processed.Add([string]$id) }
        }

        $pagesJson = & gh api "repos/$Repo/issues/$Issue/comments?per_page=100" --paginate --slurp
        if ($LASTEXITCODE -ne 0) { throw "gh api comments failed: $LASTEXITCODE" }
        $pages = @($pagesJson | ConvertFrom-Json)
        $comments = @()
        foreach ($page in $pages) { $comments += @($page) }

        foreach ($comment in ($comments | Sort-Object id)) {
            $body = [string]$comment.body
            $header = [regex]::Match($body, '<!--\s*codex-bridge:v1\s+role=controller\s+task=(?<task>[A-Za-z0-9._:-]+)\s*-->')
            if (-not $header.Success) { continue }
            $jsonBlock = [regex]::Match($body, '(?s)```json\s*(?<json>.*?)\s*```')
            if (-not $jsonBlock.Success) { continue }

            $taskId = $header.Groups['task'].Value
            if ($processed.Contains($taskId)) { continue }

            try {
                $spec = $jsonBlock.Groups['json'].Value | ConvertFrom-Json
                Run-CodexTask -TaskId $taskId -Spec $spec
            }
            catch {
                $err = $_.Exception.Message
                Write-BridgeLog "task=$taskId failed: $err"
                Post-Comment "<!-- codex-bridge:v1 role=worker task=$taskId -->`n## Codex bridge error ``$taskId```n`n$err"
            }
            finally {
                [void]$processed.Add($taskId)
                $state.processed = @($processed)
                Save-State $state
            }
        }
    }
    catch {
        Write-BridgeLog "poll failed: $($_.Exception.Message)"
    }

    Start-Sleep -Seconds $PollSeconds
}

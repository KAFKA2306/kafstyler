param(
    [string]$Repo = 'KAFKA2306/basic_prompts',
    [int]$Issue = 3,
    [int]$PollSeconds = 10
)

$ErrorActionPreference = 'Stop'

$root = Join-Path $env:LOCALAPPDATA 'OpenAI\CodexChatGPTBridge'
$statePath = Join-Path $root 'state-v2.json'
$logDir = Join-Path $root 'logs'
$healthPath = Join-Path $root 'health.json'
New-Item -ItemType Directory -Force -Path $root, $logDir | Out-Null

$script:AppServer = $null
$script:NextRequestId = 1
$script:CurrentItems = New-Object 'System.Collections.Generic.List[object]'
$script:CurrentWarnings = New-Object 'System.Collections.Generic.List[string]'
$script:McpStartup = @{}

function Write-BridgeLog([string]$Message) {
    $line = "$(Get-Date -Format o) $Message"
    Add-Content -Path (Join-Path $logDir 'bridge-v2.log') -Value $line -Encoding utf8
}

function Write-Utf8NoBom([string]$Path, [string]$Text) {
    $encoding = New-Object System.Text.UTF8Encoding($false)
    [IO.File]::WriteAllText($Path, $Text, $encoding)
}

function Invoke-GhJson(
    [string]$Method,
    [string]$Endpoint,
    $Body = $null,
    [switch]$Paginate
) {
    $args = @('api', '--method', $Method, $Endpoint)
    $tmp = $null
    try {
        if ($null -ne $Body) {
            $tmp = Join-Path ([IO.Path]::GetTempPath()) ("codex-bridge-" + [Guid]::NewGuid().ToString('N') + '.json')
            Write-Utf8NoBom $tmp ($Body | ConvertTo-Json -Depth 30 -Compress)
            $args += @('--input', $tmp)
        }
        if ($Paginate) {
            $args += @('--paginate', '--slurp')
        }

        $json = @(& gh @args 2>&1)
        if ($LASTEXITCODE -ne 0) {
            throw "gh api failed ($LASTEXITCODE): $($json -join "`n")"
        }
        $raw = $json -join "`n"
        if ([string]::IsNullOrWhiteSpace($raw)) { return $null }
        return $raw | ConvertFrom-Json
    }
    finally {
        if ($tmp) { Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue }
    }
}

function Get-QueueComments([datetime]$SinceUtc) {
    $since = [Uri]::EscapeDataString($SinceUtc.ToString('o'))
    $endpoint = "repos/$Repo/issues/$Issue/comments?per_page=100&since=$since"
    $pages = @(Invoke-GhJson -Method 'GET' -Endpoint $endpoint -Paginate)
    $comments = @()
    foreach ($page in $pages) {
        if ($null -ne $page) { $comments += @($page) }
    }
    return @($comments | Sort-Object id)
}

function Post-StatusComment([string]$Body) {
    $result = Invoke-GhJson -Method 'POST' -Endpoint "repos/$Repo/issues/$Issue/comments" -Body @{ body = $Body }
    return [long]$result.id
}

function Update-StatusComment([long]$CommentId, [string]$Body) {
    [void](Invoke-GhJson -Method 'PATCH' -Endpoint "repos/$Repo/issues/comments/$CommentId" -Body @{ body = $Body })
}

function New-State {
    return [ordered]@{
        processed = @()
        active_task = $null
        active_status_comment_id = $null
        last_comment_id = 0
        since = (Get-Date).ToUniversalTime().AddSeconds(-5).ToString('o')
    }
}

function Load-State {
    if (-not (Test-Path -LiteralPath $statePath -PathType Leaf)) {
        return New-State
    }
    try {
        $raw = Get-Content -Raw -LiteralPath $statePath | ConvertFrom-Json
        return [ordered]@{
            processed = @($raw.processed)
            active_task = $raw.active_task
            active_status_comment_id = $raw.active_status_comment_id
            last_comment_id = [long]$raw.last_comment_id
            since = [string]$raw.since
        }
    }
    catch {
        Write-BridgeLog "state load failed: $($_.Exception.Message)"
        return New-State
    }
}

function Save-State($State) {
    $State.processed = @($State.processed | Select-Object -Last 2000)
    Write-Utf8NoBom $statePath ($State | ConvertTo-Json -Depth 8)
}

function Initialize-StateForFreshInstall($State) {
    if (Test-Path -LiteralPath $statePath -PathType Leaf) { return $State }

    # Start after the comments that already exist. This prevents a fresh v2 install
    # from replaying historical controller messages.
    $comments = Get-QueueComments -SinceUtc ([datetime]'2000-01-01T00:00:00Z')
    if ($comments.Count -gt 0) {
        $State.last_comment_id = [long](($comments | Measure-Object id -Maximum).Maximum)
    }
    $State.since = (Get-Date).ToUniversalTime().AddSeconds(-2).ToString('o')
    Save-State $State
    return $State
}

function Render-Status(
    [string]$TaskId,
    [string]$State,
    [string]$Summary,
    $Evidence = $null
) {
    $payload = [ordered]@{
        protocol = 'codex-bridge:v2'
        task_id = $TaskId
        state = $State
        updated_at = (Get-Date).ToUniversalTime().ToString('o')
        summary = $Summary
    }
    if ($null -ne $Evidence) { $payload.evidence = $Evidence }

    $fence = '```'
    return @(
        "<!-- codex-bridge:v2 role=worker task=$TaskId -->",
        "## $State — $TaskId",
        '',
        ($fence + 'json'),
        ($payload | ConvertTo-Json -Depth 20),
        $fence
    ) -join "`n"
}

function Get-GitEvidence([string]$Cwd) {
    $e = [ordered]@{
        repo_root = $null
        branch = $null
        head = $null
        diff_stat = @()
        status = @()
    }

    Push-Location $Cwd
    try {
        $rootText = @(& git rev-parse --show-toplevel 2>$null)
        if ($LASTEXITCODE -ne 0 -or $rootText.Count -eq 0) { return $e }

        $e.repo_root = [string]($rootText | Select-Object -First 1)

        $branch = @(& git branch --show-current 2>$null)
        if ($LASTEXITCODE -eq 0 -and $branch.Count -gt 0) {
            $e.branch = [string]($branch | Select-Object -First 1)
        }

        $head = @(& git rev-parse --verify HEAD 2>$null)
        if ($LASTEXITCODE -eq 0 -and $head.Count -gt 0) {
            $e.head = [string]($head | Select-Object -First 1)
        }

        $stat = @(& git diff --stat -- . 2>$null)
        if ($LASTEXITCODE -eq 0) {
            $e.diff_stat = @($stat | Select-Object -First 100)
        }

        $status = @(& git status --porcelain=v1 2>$null)
        if ($LASTEXITCODE -eq 0) {
            $e.status = @($status | Select-Object -First 200)
        }
    }
    catch {
        Write-BridgeLog "git evidence unavailable for cwd=$Cwd: $($_.Exception.Message)"
    }
    finally {
        Pop-Location
    }
    return $e
}

function Test-BoolProperty($Spec, [string]$Name) {
    $property = $Spec.PSObject.Properties[$Name]
    if ($null -eq $property -or $null -eq $property.Value) { return $false }
    return [bool]$property.Value
}

function Get-StringArrayProperty($Spec, [string]$Name) {
    $property = $Spec.PSObject.Properties[$Name]
    if ($null -eq $property -or $null -eq $property.Value) { return @() }
    return @($property.Value | ForEach-Object { [string]$_ })
}

function Resolve-TaskPolicy($Spec, [string]$Cwd) {
    $mode = if ($Spec.PSObject.Properties['mode']) { [string]$Spec.mode } else { 'execute_only' }
    if ($mode -ne 'execute_only') {
        throw "Unsupported mode '$mode'. v2 only accepts execute_only."
    }

    $allowedRoots = @()
    foreach ($pathText in (Get-StringArrayProperty $Spec 'allowed_paths')) {
        if ([string]::IsNullOrWhiteSpace($pathText)) { continue }
        $full = [IO.Path]::GetFullPath($pathText)
        $cwdWithSlash = $Cwd.TrimEnd('\') + '\'
        if (($full -ne $Cwd) -and (-not $full.StartsWith($cwdWithSlash, [StringComparison]::OrdinalIgnoreCase))) {
            throw "allowed_paths entry escapes cwd: $full"
        }
        if (-not (Test-Path -LiteralPath $full -PathType Container)) {
            throw "allowed_paths entries must be existing directories: $full"
        }
        $allowedRoots += $full
    }

    $policy = [ordered]@{
        mode = 'execute_only'
        allowed_paths = @($allowedRoots | Select-Object -Unique)
        allow_commit = (Test-BoolProperty $Spec 'allow_commit')
        allow_push = (Test-BoolProperty $Spec 'allow_push')
        allow_network = (Test-BoolProperty $Spec 'allow_network')
        allow_unity_save = (Test-BoolProperty $Spec 'allow_unity_save')
        allow_reimport = (Test-BoolProperty $Spec 'allow_reimport')
        required_mcp_servers = @(Get-StringArrayProperty $Spec 'required_mcp_servers' | Select-Object -Unique)
    }

    if ($policy.allow_push -and -not $policy.allow_network) {
        throw 'allow_push=true requires allow_network=true.'
    }

    # Keep Codex shell/filesystem permissions separate from Unity MCP side-effect
    # authorization. Unity save/reimport must never widen the local shell sandbox.
    $policy['workspace_write'] =
        ($policy.allowed_paths.Count -gt 0) -or
        $policy.allow_commit -or
        $policy.allow_push

    if ($policy.workspace_write -and $policy.allowed_paths.Count -eq 0) {
        $policy.allowed_paths = @($Cwd)
    }

    # The stable legacy App Server policy documents networkAccess on workspaceWrite,
    # not on readOnly. Fail closed instead of silently pretending a read-only,
    # network-enabled shell policy exists.
    if ($policy.allow_network -and -not $policy.workspace_write) {
        throw 'allow_network=true is not supported for a shell-read-only v2 task. Declare an explicit narrow allowed_paths root, or keep allow_network=false.'
    }

    $policy['require_git_unchanged'] = -not (
        $policy.workspace_write -or
        $policy.allow_unity_save -or
        $policy.allow_reimport
    )

    return $policy
}

function Build-WorkerPrompt([string]$TaskId, [string]$Prompt, $Policy) {
    $policyJson = $Policy | ConvertTo-Json -Depth 8 -Compress
    return @"
You are the execution-only worker for task $TaskId.

Hard contract:
- Execute only the explicit operations requested below.
- Do not diagnose, redesign, recommend, refactor, broaden scope, or choose the next step.
- If additional judgment is required, stop and return only the facts gathered so far.
- Do not modify files outside the permitted roots.
- Do not commit, push, use shell network access, save Unity state, or trigger reimport unless the policy explicitly allows it.
- Unity MCP save/reimport authorization does not grant local shell filesystem write access.
- Do not clean, reset, discard, or overwrite pre-existing dirty working-tree changes.
- Return factual execution evidence. Do not claim the overall problem is solved; ChatGPT is the controller and decides that.

Task policy:
$policyJson

Task:
$Prompt
"@
}

function Stop-AppServer {
    if ($null -eq $script:AppServer) { return }
    try {
        if (-not $script:AppServer.HasExited) {
            $script:AppServer.StandardInput.Close()
            if (-not $script:AppServer.WaitForExit(2000)) {
                $script:AppServer.Kill()
            }
        }
    }
    catch {
        Write-BridgeLog "app-server stop warning: $($_.Exception.Message)"
    }
    finally {
        $script:AppServer = $null
    }
}

function Write-AppMessage($Message) {
    if ($null -eq $script:AppServer -or $script:AppServer.HasExited) {
        throw 'codex app-server is not running.'
    }
    $line = $Message | ConvertTo-Json -Depth 40 -Compress
    $script:AppServer.StandardInput.WriteLine($line)
    $script:AppServer.StandardInput.Flush()
}

function Handle-AppNotification($Message) {
    if (-not $Message.PSObject.Properties['method']) { return }
    $method = [string]$Message.method

    if ($method -eq 'item/completed' -and $Message.params -and $Message.params.item) {
        [void]$script:CurrentItems.Add($Message.params.item)
        return
    }
    if ($method -eq 'configWarning' -and $Message.params) {
        [void]$script:CurrentWarnings.Add([string]$Message.params.summary)
        return
    }
    if ($method -eq 'warning' -and $Message.params) {
        [void]$script:CurrentWarnings.Add([string]$Message.params.message)
        return
    }
    if ($method -eq 'mcpServer/startupStatus/updated' -and $Message.params) {
        $name = [string]$Message.params.name
        $script:McpStartup[$name] = [ordered]@{
            status = [string]$Message.params.status
            error = $Message.params.error
            failureReason = $Message.params.failureReason
        }
        return
    }
}

function Read-AppMessage {
    while ($true) {
        if ($null -eq $script:AppServer) { throw 'codex app-server is not running.' }
        $line = $script:AppServer.StandardOutput.ReadLine()
        if ($null -eq $line) {
            $exit = if ($script:AppServer.HasExited) { $script:AppServer.ExitCode } else { 'unknown' }
            throw "codex app-server stdout closed (exit=$exit)."
        }
        if ([string]::IsNullOrWhiteSpace($line)) { continue }

        try {
            $message = $line | ConvertFrom-Json
        }
        catch {
            Write-BridgeLog "ignored non-json app-server stdout: $line"
            continue
        }

        # Server-initiated requests must always receive a response. This execution-only
        # bridge has no interactive approval surface, so known permission/elicitation
        # requests are explicitly denied and unknown requests fail closed.
        if ($message.PSObject.Properties['id'] -and $message.PSObject.Properties['method']) {
            $serverMethod = [string]$message.method
            if ($serverMethod -eq 'mcpServer/elicitation/request') {
                Write-AppMessage ([ordered]@{
                    id = $message.id
                    result = [ordered]@{
                        action = 'decline'
                        content = $null
                    }
                })
                continue
            }
            if ($serverMethod -eq 'item/permissions/requestApproval') {
                Write-AppMessage ([ordered]@{
                    id = $message.id
                    result = [ordered]@{
                        scope = 'turn'
                        permissions = [ordered]@{}
                    }
                })
                continue
            }

            Write-AppMessage ([ordered]@{
                id = $message.id
                error = [ordered]@{
                    code = -32601
                    message = 'This execution-only bridge does not implement interactive server requests.'
                }
            })
            continue
        }

        if ($message.PSObject.Properties['method']) {
            Handle-AppNotification $message
        }
        return $message
    }
}

function Send-AppNotification([string]$Method, $Params = $null) {
    $m = [ordered]@{ method = $Method }
    if ($null -ne $Params) { $m['params'] = $Params }
    Write-AppMessage $m
}

function Send-AppRequest([string]$Method, $Params = $null) {
    $id = $script:NextRequestId
    $script:NextRequestId += 1

    $request = [ordered]@{ method = $Method; id = $id }
    if ($null -ne $Params) { $request['params'] = $Params }
    Write-AppMessage $request

    while ($true) {
        $message = Read-AppMessage
        if ($message.PSObject.Properties['id'] -and ([long]$message.id -eq [long]$id)) {
            if ($message.PSObject.Properties['error'] -and $null -ne $message.error) {
                $err = $message.error | ConvertTo-Json -Depth 10 -Compress
                throw "app-server request '$Method' failed: $err"
            }
            return $message.result
        }
    }
}

function Get-McpServerEntries($Result) {
    if ($null -eq $Result) { return @() }
    if ($Result -is [System.Array]) { return @($Result) }
    foreach ($field in @('data', 'servers', 'items')) {
        $p = $Result.PSObject.Properties[$field]
        if ($null -ne $p -and $null -ne $p.Value) { return @($p.Value) }
    }
    return @()
}

function Get-McpServerNames($Result) {
    return @(
        Get-McpServerEntries $Result |
            ForEach-Object {
                if ($_.PSObject.Properties['name']) { [string]$_.name }
            } |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
            Select-Object -Unique
    )
}

function Start-AppServer {
    if ($null -ne $script:AppServer -and -not $script:AppServer.HasExited) { return }

    [void](Get-Command codex -ErrorAction Stop)
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $env:ComSpec
    $psi.Arguments = '/d /s /c "codex app-server --stdio"'
    $psi.UseShellExecute = $false
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    # Keep stderr separate from the JSONL protocol and inherited by the supervisor.
    $psi.RedirectStandardError = $false
    $psi.CreateNoWindow = $true

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $psi
    if (-not $process.Start()) { throw 'Failed to start codex app-server.' }

    $script:AppServer = $process
    $script:NextRequestId = 1
    $script:CurrentItems.Clear()
    $script:CurrentWarnings.Clear()
    $script:McpStartup = @{}

    $init = Send-AppRequest 'initialize' ([ordered]@{
        clientInfo = [ordered]@{
            name = 'kafka_codex_chatgpt_bridge'
            title = 'KAFKA ChatGPT Codex Bridge'
            version = '2.0.0'
        }
        capabilities = [ordered]@{
            optOutNotificationMethods = @(
                'item/agentMessage/delta',
                'item/reasoning/summaryTextDelta',
                'item/reasoning/summaryPartAdded',
                'item/reasoning/textDelta',
                'item/commandExecution/outputDelta'
            )
        }
    })
    Send-AppNotification 'initialized'

    $version = @(& codex --version 2>$null) | Select-Object -First 1
    $health = [ordered]@{
        protocol = 'codex-bridge:v2'
        app_server_pid = $process.Id
        codex_version = [string]$version
        codex_home = if ($init.PSObject.Properties['codexHome']) { [string]$init.codexHome } else { $null }
        initialized_at = (Get-Date).ToUniversalTime().ToString('o')
    }
    Write-Utf8NoBom $healthPath ($health | ConvertTo-Json -Depth 5)
    Write-BridgeLog "app-server initialized pid=$($process.Id) codex=$version"
}

function Ensure-AppServer {
    if ($null -eq $script:AppServer -or $script:AppServer.HasExited) {
        Stop-AppServer
        Start-AppServer
    }
}

function Reset-TaskCapture {
    $script:CurrentItems.Clear()
    $script:CurrentWarnings.Clear()
    $script:McpStartup = @{}
}

function Get-OperationEvidence {
    $ops = New-Object 'System.Collections.Generic.List[object]'
    foreach ($item in @($script:CurrentItems)) {
        if (-not $item.PSObject.Properties['type']) { continue }
        $type = [string]$item.type

        if ($type -eq 'commandExecution') {
            [void]$ops.Add([ordered]@{
                type = $type
                status = $item.status
                command = $item.command
                cwd = $item.cwd
                exit_code = $item.exitCode
            })
        }
        elseif ($type -eq 'fileChange') {
            $paths = @()
            foreach ($change in @($item.changes)) {
                if ($change.PSObject.Properties['path']) { $paths += [string]$change.path }
            }
            [void]$ops.Add([ordered]@{
                type = $type
                status = $item.status
                paths = @($paths | Select-Object -Unique)
            })
        }
        elseif ($type -eq 'mcpToolCall') {
            [void]$ops.Add([ordered]@{
                type = $type
                server = $item.server
                tool = $item.tool
                status = $item.status
                read_only_hint = $item.readOnlyHint
                error = $item.error
            })
        }
    }
    return @($ops | Select-Object -First 100)
}

function Get-FinalAgentMessage($Turn) {
    if ($null -ne $Turn -and $Turn.PSObject.Properties['items']) {
        $messages = @(
            $Turn.items |
                Where-Object { $_.PSObject.Properties['type'] -and $_.type -eq 'agentMessage' -and $_.PSObject.Properties['text'] } |
                ForEach-Object { [string]$_.text }
        )
        if ($messages.Count -gt 0) { return [string]($messages | Select-Object -Last 1) }
    }

    $captured = @(
        $script:CurrentItems |
            Where-Object { $_.PSObject.Properties['type'] -and $_.type -eq 'agentMessage' -and $_.PSObject.Properties['text'] } |
            ForEach-Object { [string]$_.text }
    )
    if ($captured.Count -gt 0) { return [string]($captured | Select-Object -Last 1) }
    return ''
}

function Invoke-AppServerTask([string]$TaskId, $Spec, [string]$Cwd, $Policy) {
    Ensure-AppServer
    Reset-TaskCapture

    [void](Send-AppRequest 'config/mcpServer/reload')
    $globalMcp = Send-AppRequest 'mcpServerStatus/list' @{ limit = 200 }
    $globalNames = @(Get-McpServerNames $globalMcp)

    $missing = @()
    foreach ($required in @($Policy.required_mcp_servers)) {
        if (-not ($globalNames | Where-Object { $_ -ieq $required })) { $missing += $required }
    }
    if ($missing.Count -gt 0) {
        $ex = New-Object System.InvalidOperationException ("Required MCP server(s) not configured: " + ($missing -join ', '))
        $ex.Data['BridgeState'] = 'BLOCKED'
        throw $ex
    }

    $thread = Send-AppRequest 'thread/start' ([ordered]@{
        cwd = $Cwd
        approvalPolicy = 'never'
        sandbox = 'readOnly'
        ephemeral = $true
        serviceName = 'kafka_codex_chatgpt_bridge'
    })
    $threadId = [string]$thread.thread.id
    if ([string]::IsNullOrWhiteSpace($threadId)) { throw 'thread/start returned no thread id.' }

    $threadMcp = Send-AppRequest 'mcpServerStatus/list' @{ threadId = $threadId; limit = 200 }
    $threadMcpNames = @(Get-McpServerNames $threadMcp)
    $missingThread = @()
    foreach ($required in @($Policy.required_mcp_servers)) {
        if (-not ($threadMcpNames | Where-Object { $_ -ieq $required })) { $missingThread += $required }
    }
    if ($missingThread.Count -gt 0) {
        $ex = New-Object System.InvalidOperationException ("Required MCP server(s) not available in thread: " + ($missingThread -join ', '))
        $ex.Data['BridgeState'] = 'BLOCKED'
        throw $ex
    }

    $sandboxPolicy = if ($Policy.workspace_write) {
        [ordered]@{
            type = 'workspaceWrite'
            writableRoots = @($Policy.allowed_paths)
            networkAccess = [bool]$Policy.allow_network
        }
    }
    else {
        [ordered]@{ type = 'readOnly' }
    }

    $workerPrompt = Build-WorkerPrompt -TaskId $TaskId -Prompt ([string]$Spec.prompt) -Policy $Policy
    $turnStart = Send-AppRequest 'turn/start' ([ordered]@{
        threadId = $threadId
        clientUserMessageId = $TaskId
        input = @([ordered]@{ type = 'text'; text = $workerPrompt })
        cwd = $Cwd
        approvalPolicy = 'never'
        sandboxPolicy = $sandboxPolicy
    })
    $turnId = [string]$turnStart.turn.id
    if ([string]::IsNullOrWhiteSpace($turnId)) { throw 'turn/start returned no turn id.' }

    $completed = $null
    while ($null -eq $completed) {
        $message = Read-AppMessage
        if ($message.PSObject.Properties['method'] -and $message.method -eq 'turn/completed') {
            if ($message.params -and $message.params.turn -and [string]$message.params.turn.id -eq $turnId) {
                $completed = $message.params.turn
            }
        }
    }

    $mcpFailed = @()
    foreach ($required in @($Policy.required_mcp_servers)) {
        foreach ($key in @($script:McpStartup.Keys)) {
            if ($key -ieq $required -and [string]$script:McpStartup[$key].status -eq 'failed') {
                $mcpFailed += $key
            }
        }
    }
    if ($mcpFailed.Count -gt 0) {
        $ex = New-Object System.InvalidOperationException ("Required MCP server startup failed: " + (($mcpFailed | Select-Object -Unique) -join ', '))
        $ex.Data['BridgeState'] = 'BLOCKED'
        throw $ex
    }

    return [ordered]@{
        thread_id = $threadId
        turn_id = $turnId
        turn_status = [string]$completed.status
        final_message = (Get-FinalAgentMessage $completed)
        configured_mcp_servers = @($threadMcpNames)
        required_mcp_servers = @($Policy.required_mcp_servers)
        mcp_startup = $script:McpStartup
        operations = @(Get-OperationEvidence)
        warnings = @($script:CurrentWarnings | Select-Object -Unique | Select-Object -First 50)
        turn_error = $completed.error
    }
}

function Remove-RuntimeSmokeIfRequested($Spec, [string]$Cwd) {
    if (-not (Test-BoolProperty $Spec 'cleanup_runtime_smoke')) { return }
    $smokeRoot = Join-Path $root 'smoke-repo'
    if ([IO.Path]::GetFullPath($Cwd) -ne [IO.Path]::GetFullPath($smokeRoot)) {
        Write-BridgeLog "ignored cleanup_runtime_smoke for non-runtime path: $Cwd"
        return
    }
    Remove-Item -LiteralPath $smokeRoot -Recurse -Force -ErrorAction SilentlyContinue
}

function Run-Task([string]$TaskId, $Spec, [long]$StatusCommentId) {
    if (-not $Spec.PSObject.Properties['cwd'] -or -not $Spec.PSObject.Properties['prompt']) {
        throw 'Task JSON must contain cwd and prompt.'
    }

    $cwd = [IO.Path]::GetFullPath([string]$Spec.cwd)
    if (-not (Test-Path -LiteralPath $cwd -PathType Container)) {
        throw "cwd does not exist: $cwd"
    }

    $policy = Resolve-TaskPolicy -Spec $Spec -Cwd $cwd
    $before = Get-GitEvidence $cwd

    Update-StatusComment $StatusCommentId (Render-Status -TaskId $TaskId -State 'RUNNING' -Summary 'Task claimed; running through persistent codex app-server.' -Evidence ([ordered]@{
        cwd = $cwd
        policy = $policy
        git_before = $before
    }))

    try {
        $run = Invoke-AppServerTask -TaskId $TaskId -Spec $Spec -Cwd $cwd -Policy $policy
        $after = Get-GitEvidence $cwd

        if ($policy.require_git_unchanged) {
            $beforeStatus = @($before.status) -join "`n"
            $afterStatus = @($after.status) -join "`n"
            if ($before.head -ne $after.head -or $beforeStatus -ne $afterStatus) {
                throw 'Read-only task changed Git evidence; refusing to mark it succeeded.'
            }
        }

        $terminal = if ($run.turn_status -eq 'completed') { 'SUCCEEDED' } else { 'FAILED' }
        $summary = if ($terminal -eq 'SUCCEEDED') {
            'Codex turn completed. ChatGPT must still review the returned evidence and decide whether the task objective is satisfied.'
        }
        else {
            "Codex turn ended with status '$($run.turn_status)'."
        }

        $final = [string]$run.final_message
        if ($final.Length -gt 20000) { $final = $final.Substring(0, 20000) + "`n...[truncated]" }

        $evidence = [ordered]@{
            cwd = $cwd
            app_server_pid = $script:AppServer.Id
            thread_id = $run.thread_id
            turn_id = $run.turn_id
            turn_status = $run.turn_status
            required_mcp_servers = $run.required_mcp_servers
            configured_mcp_servers = $run.configured_mcp_servers
            mcp_startup = $run.mcp_startup
            operations = $run.operations
            warnings = $run.warnings
            turn_error = $run.turn_error
            git_before = $before
            git_after = $after
            final_message = $final
        }

        Update-StatusComment $StatusCommentId (Render-Status -TaskId $TaskId -State $terminal -Summary $summary -Evidence $evidence)
        Write-BridgeLog "task=$TaskId terminal=$terminal turn=$($run.turn_status)"
    }
    finally {
        Remove-RuntimeSmokeIfRequested -Spec $Spec -Cwd $cwd
    }
}

function Recover-InterruptedTask($State) {
    if (-not $State.active_task -or -not $State.active_status_comment_id) { return }
    try {
        Update-StatusComment ([long]$State.active_status_comment_id) (
            Render-Status -TaskId ([string]$State.active_task) -State 'BLOCKED' `
                -Summary 'Bridge process restarted while this task was active. The task was not automatically replayed; submit a new task id after review.'
        )
    }
    catch {
        Write-BridgeLog "failed to mark interrupted task blocked: $($_.Exception.Message)"
    }
    $State.active_task = $null
    $State.active_status_comment_id = $null
    Save-State $State
}

& gh auth status | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'GitHub CLI is not authenticated.' }
& codex --version | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Codex CLI is not available.' }
& codex app-server --help | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'This Codex CLI does not provide codex app-server.' }

$state = Load-State
$state = Initialize-StateForFreshInstall $state
Recover-InterruptedTask $state
Start-AppServer

Write-BridgeLog "daemon v2 started repo=$Repo issue=$Issue poll=${PollSeconds}s"

try {
    while ($true) {
        $pollStarted = (Get-Date).ToUniversalTime()
        try {
            $processed = New-Object 'System.Collections.Generic.HashSet[string]'
            foreach ($id in @($state.processed)) {
                if ($null -ne $id) { [void]$processed.Add([string]$id) }
            }

            $sinceUtc = [datetime]::Parse([string]$state.since).ToUniversalTime()
            $comments = @(Get-QueueComments -SinceUtc $sinceUtc)

            foreach ($comment in $comments) {
                $commentId = [long]$comment.id
                if ($commentId -le [long]$state.last_comment_id) { continue }

                $state.last_comment_id = $commentId
                $body = [string]$comment.body
                $header = [regex]::Match($body, '<!--\s*codex-bridge:v2\s+role=controller\s+task=(?<task>[A-Za-z0-9._:-]+)\s*-->')
                if (-not $header.Success) { continue }

                $jsonBlock = [regex]::Match($body, '(?s)```json\s*(?<json>.*?)\s*```')
                if (-not $jsonBlock.Success) { continue }

                $taskId = $header.Groups['task'].Value
                if ($processed.Contains($taskId)) { continue }

                $statusId = $null
                try {
                    $spec = $jsonBlock.Groups['json'].Value | ConvertFrom-Json
                    $statusId = Post-StatusComment (
                        Render-Status -TaskId $taskId -State 'CLAIMED' -Summary 'Task claimed by bridge v2.'
                    )

                    [void]$processed.Add($taskId)
                    $state.processed = @($processed)
                    $state.active_task = $taskId
                    $state.active_status_comment_id = $statusId
                    Save-State $state

                    Run-Task -TaskId $taskId -Spec $spec -StatusCommentId $statusId
                }
                catch {
                    $terminalState = 'FAILED'
                    if ($_.Exception.Data.Contains('BridgeState')) {
                        $terminalState = [string]$_.Exception.Data['BridgeState']
                    }
                    $message = $_.Exception.Message
                    Write-BridgeLog "task=$taskId terminal=$terminalState error=$message"

                    if ($null -ne $statusId) {
                        try {
                            Update-StatusComment ([long]$statusId) (
                                Render-Status -TaskId $taskId -State $terminalState -Summary $message
                            )
                        }
                        catch {
                            Write-BridgeLog "status update failed for task=$taskId: $($_.Exception.Message)"
                        }
                    }
                }
                finally {
                    if (-not $processed.Contains($taskId)) {
                        [void]$processed.Add($taskId)
                    }
                    $state.processed = @($processed)
                    $state.active_task = $null
                    $state.active_status_comment_id = $null
                    Save-State $state
                }
            }

            # Small overlap avoids missing comments created at the exact poll boundary;
            # last_comment_id prevents duplicate processing.
            $state.since = $pollStarted.AddSeconds(-2).ToString('o')
            Save-State $state
        }
        catch {
            Write-BridgeLog "poll failed: $($_.Exception.Message)"
            try {
                if ($null -eq $script:AppServer -or $script:AppServer.HasExited) {
                    Stop-AppServer
                    Start-AppServer
                }
            }
            catch {
                Write-BridgeLog "app-server restart failed: $($_.Exception.Message)"
            }
        }

        Start-Sleep -Seconds $PollSeconds
    }
}
finally {
    Stop-AppServer
}

param(
    [string]$Repo = 'KAFKA2306/basic_prompts',
    [int]$Issue = 3,
    [int]$PollSeconds = 10,
    [string]$TaskName = 'OpenAI Codex ChatGPT Bridge'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Write-Utf8NoBom([string]$Path, [string]$Text) {
    $encoding = New-Object System.Text.UTF8Encoding($false)
    [IO.File]::WriteAllText($Path, $Text, $encoding)
}

function Post-QueueComment([string]$Body) {
    $tmp = Join-Path ([IO.Path]::GetTempPath()) ("codex-bridge-install-" + [Guid]::NewGuid().ToString('N') + '.md')
    try {
        Write-Utf8NoBom $tmp $Body
        & gh issue comment $Issue --repo $Repo --body-file $tmp | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "gh issue comment failed: $LASTEXITCODE" }
    }
    finally {
        Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
    }
}

Write-Host '[1/8] Verify official CLIs and App Server'
$gh = Get-Command gh -ErrorAction Stop
$codex = Get-Command codex -ErrorAction Stop
& $gh.Source --version | Select-Object -First 1 | Write-Host
& $codex.Source --version | Write-Host
& $codex.Source app-server --help | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Installed Codex CLI does not provide codex app-server.' }
& $gh.Source auth status | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'GitHub CLI authentication is required. Run: gh auth login' }

Write-Host '[2/8] Verify private v2 queue access'
& $gh.Source issue view $Issue --repo $Repo --json number,title,state | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Cannot access $Repo issue #$Issue" }

$sourceDaemon = Join-Path $PSScriptRoot 'bridge-daemon.ps1'
$sourceSupervisor = Join-Path $PSScriptRoot 'bridge-supervisor.ps1'
if (-not (Test-Path -LiteralPath $sourceDaemon -PathType Leaf)) { throw "Missing $sourceDaemon" }
if (-not (Test-Path -LiteralPath $sourceSupervisor -PathType Leaf)) { throw "Missing $sourceSupervisor" }

Write-Host '[3/8] Stop v1/v2 scheduled task and remove old runtime remnants'
& schtasks.exe /End /TN $TaskName 2>$null | Out-Null
Start-Sleep -Milliseconds 500

$root = Join-Path $env:LOCALAPPDATA 'OpenAI\CodexChatGPTBridge'
if (Test-Path -LiteralPath $root) {
    Remove-Item -LiteralPath $root -Recurse -Force -ErrorAction SilentlyContinue
}
New-Item -ItemType Directory -Force -Path $root | Out-Null

Write-Host '[4/8] Install only v2 runtime files'
$daemon = Join-Path $root 'bridge-daemon.ps1'
$supervisor = Join-Path $root 'bridge-supervisor.ps1'
Copy-Item -LiteralPath $sourceDaemon -Destination $daemon -Force
Copy-Item -LiteralPath $sourceSupervisor -Destination $supervisor -Force

Write-Host '[5/8] Register logon task'
$taskCommand = "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$supervisor`" -Repo `"$Repo`" -Issue $Issue -PollSeconds $PollSeconds"
& schtasks.exe /Create /F /SC ONLOGON /TN $TaskName /TR $taskCommand /RL LIMITED | Out-Host
if ($LASTEXITCODE -ne 0) { throw "schtasks /Create failed: $LASTEXITCODE" }

Write-Host '[6/8] Start bridge v2 and verify App Server handshake'
& schtasks.exe /Run /TN $TaskName | Out-Host
if ($LASTEXITCODE -ne 0) { throw "schtasks /Run failed: $LASTEXITCODE" }

$healthPath = Join-Path $root 'health.json'
$deadline = (Get-Date).AddSeconds(20)
while ((Get-Date) -lt $deadline -and -not (Test-Path -LiteralPath $healthPath -PathType Leaf)) {
    Start-Sleep -Milliseconds 500
}
if (-not (Test-Path -LiteralPath $healthPath -PathType Leaf)) {
    throw "Bridge v2 did not create App Server health evidence: $healthPath"
}
Get-Content -Raw -LiteralPath $healthPath | Write-Host

Write-Host '[7/8] Create disposable local smoke repository'
$smokeRepo = Join-Path $root 'smoke-repo'
New-Item -ItemType Directory -Force -Path $smokeRepo | Out-Null
& git -C $smokeRepo init | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'git init for v2 smoke test failed.' }
& git -C $smokeRepo config user.name 'Codex ChatGPT Bridge' | Out-Null
& git -C $smokeRepo config user.email 'codex-chatgpt-bridge@localhost' | Out-Null
& git -C $smokeRepo commit --allow-empty -m 'Initialize v2 bridge smoke repo' | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Failed to create initial v2 smoke repo commit.' }

Write-Host '[8/8] Queue read-only v2 transport smoke test'
$taskId = 'v2-smoke-' + (Get-Date -Format 'yyyyMMdd-HHmmss')
$spec = [ordered]@{
    cwd = $smokeRepo
    prompt = 'Transport smoke test only. Do not use shell commands or modify anything. Reply with exactly: BRIDGE_V2_OK'
    mode = 'execute_only'
    required_mcp_servers = @()
    allowed_paths = @()
    allow_commit = $false
    allow_push = $false
    allow_network = $false
    allow_unity_save = $false
    allow_reimport = $false
    cleanup_runtime_smoke = $true
} | ConvertTo-Json -Compress

$fence = '```'
$body = @(
    "<!-- codex-bridge:v2 role=controller task=$taskId -->",
    "## v2 transport smoke test $taskId",
    '',
    ($fence + 'json'),
    $spec,
    $fence
) -join "`n"
Post-QueueComment $body

Write-Host ''
Write-Host 'Bridge v2 installed.'
Write-Host "Queue: https://github.com/$Repo/issues/$Issue"
Write-Host "Runtime: $root"
Write-Host "Task: $TaskName"
Write-Host "Smoke task: $taskId"
Write-Host 'Expected terminal worker state: SUCCEEDED with final_message BRIDGE_V2_OK.'
Write-Host 'The disposable smoke repository is deleted automatically by the v2 daemon after terminal status.'

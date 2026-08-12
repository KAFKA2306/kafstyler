param(
    [string]$Repo = 'KAFKA2306/basic_prompts',
    [int]$Issue = 1,
    [int]$PollSeconds = 30,
    [string]$TaskName = 'OpenAI Codex ChatGPT Bridge'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Post-QueueComment([string]$Body) {
    $tmp = Join-Path ([IO.Path]::GetTempPath()) ("codex-bridge-install-" + [Guid]::NewGuid().ToString('N') + '.md')
    try {
        Set-Content -Path $tmp -Value $Body -Encoding utf8
        & gh issue comment $Issue --repo $Repo --body-file $tmp | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "gh issue comment failed: $LASTEXITCODE" }
    }
    finally {
        Remove-Item $tmp -Force -ErrorAction SilentlyContinue
    }
}

Write-Host '[1/7] Verify official CLIs'
$gh = Get-Command gh -ErrorAction Stop
$codex = Get-Command codex -ErrorAction Stop
& $gh.Source --version | Select-Object -First 1 | Write-Host
& $codex.Source --version | Write-Host
& $gh.Source auth status | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'GitHub CLI authentication is required. Run: gh auth login' }

Write-Host '[2/7] Verify private queue access'
& $gh.Source issue view $Issue --repo $Repo --json number,title,state | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Cannot access $Repo issue #$Issue" }

$sourceDaemon = Join-Path $PSScriptRoot 'bridge-daemon.ps1'
$sourceSupervisor = Join-Path $PSScriptRoot 'bridge-supervisor.ps1'
if (-not (Test-Path $sourceDaemon)) { throw "Missing $sourceDaemon" }
if (-not (Test-Path $sourceSupervisor)) { throw "Missing $sourceSupervisor" }

Write-Host '[3/7] Install bridge files'
$root = Join-Path $env:LOCALAPPDATA 'OpenAI\CodexChatGPTBridge'
New-Item -ItemType Directory -Force -Path $root | Out-Null
$daemon = Join-Path $root 'bridge-daemon.ps1'
$supervisor = Join-Path $root 'bridge-supervisor.ps1'
Copy-Item $sourceDaemon $daemon -Force
Copy-Item $sourceSupervisor $supervisor -Force

Write-Host '[4/7] Register logon task'
$taskCommand = "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$supervisor`" -Repo `"$Repo`" -Issue $Issue -PollSeconds $PollSeconds"
& schtasks.exe /Create /F /SC ONLOGON /TN $TaskName /TR $taskCommand /RL LIMITED | Out-Host
if ($LASTEXITCODE -ne 0) { throw "schtasks /Create failed: $LASTEXITCODE" }

Write-Host '[5/7] Restart bridge task'
& schtasks.exe /End /TN $TaskName 2>$null | Out-Null
Start-Sleep -Seconds 1
& schtasks.exe /Run /TN $TaskName | Out-Host
if ($LASTEXITCODE -ne 0) { throw "schtasks /Run failed: $LASTEXITCODE" }

Write-Host '[6/7] Verify scheduled task state'
Start-Sleep -Seconds 2
& schtasks.exe /Query /TN $TaskName /V /FO LIST | Out-Host
if ($LASTEXITCODE -ne 0) { throw "schtasks /Query failed: $LASTEXITCODE" }

Write-Host '[7/7] Queue an end-to-end smoke test'
$smokeRepo = Join-Path $root 'smoke-repo'
New-Item -ItemType Directory -Force -Path $smokeRepo | Out-Null
if (-not (Test-Path (Join-Path $smokeRepo '.git'))) {
    & git -C $smokeRepo init | Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'git init for smoke test failed.' }
}

$taskId = 'smoke-' + (Get-Date -Format 'yyyyMMdd-HHmmss')
$spec = [ordered]@{
    cwd = $smokeRepo
    prompt = 'This is an end-to-end transport smoke test. Do not create, modify, or delete any files. Reply with exactly: BRIDGE_OK'
} | ConvertTo-Json -Compress

$fence = '```'
$bodyLines = @(
    "<!-- codex-bridge:v1 role=controller task=$taskId -->",
    "## Bridge smoke test $taskId",
    '',
    ($fence + 'json'),
    $spec,
    $fence
)
Post-QueueComment ($bodyLines -join "`n")

Write-Host ''
Write-Host 'Installed and smoke test queued.'
Write-Host "Queue: https://github.com/$Repo/issues/$Issue"
Write-Host "Runtime: $root"
Write-Host "Task: $TaskName"
Write-Host "Smoke task: $taskId"
Write-Host 'Expected worker result: BRIDGE_OK with exit_code 0.'

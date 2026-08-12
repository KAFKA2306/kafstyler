param(
    [string]$Repo = 'KAFKA2306/basic_prompts',
    [int]$Issue = 1,
    [int]$PollSeconds = 30,
    [string]$TaskName = 'OpenAI Codex ChatGPT Bridge'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

Write-Host '[1/6] Verify official CLIs'
$gh = Get-Command gh -ErrorAction Stop
$codex = Get-Command codex -ErrorAction Stop
& $gh.Source --version | Select-Object -First 1 | Write-Host
& $codex.Source --version | Write-Host
& $gh.Source auth status | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'GitHub CLI authentication is required. Run: gh auth login' }

Write-Host '[2/6] Verify private queue access'
& $gh.Source issue view $Issue --repo $Repo --json number,title,state | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Cannot access $Repo issue #$Issue" }

$sourceDaemon = Join-Path $PSScriptRoot 'bridge-daemon.ps1'
$sourceSupervisor = Join-Path $PSScriptRoot 'bridge-supervisor.ps1'
if (-not (Test-Path $sourceDaemon)) { throw "Missing $sourceDaemon" }
if (-not (Test-Path $sourceSupervisor)) { throw "Missing $sourceSupervisor" }

Write-Host '[3/6] Install bridge files'
$root = Join-Path $env:LOCALAPPDATA 'OpenAI\CodexChatGPTBridge'
New-Item -ItemType Directory -Force -Path $root | Out-Null
$daemon = Join-Path $root 'bridge-daemon.ps1'
$supervisor = Join-Path $root 'bridge-supervisor.ps1'
Copy-Item $sourceDaemon $daemon -Force
Copy-Item $sourceSupervisor $supervisor -Force

Write-Host '[4/6] Register logon task'
$escapedSupervisor = $supervisor.Replace('"','\"')
$taskCommand = "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$escapedSupervisor`" -Repo `"$Repo`" -Issue $Issue -PollSeconds $PollSeconds"
& schtasks.exe /Create /F /SC ONLOGON /TN $TaskName /TR $taskCommand /RL LIMITED | Out-Host
if ($LASTEXITCODE -ne 0) { throw "schtasks /Create failed: $LASTEXITCODE" }

Write-Host '[5/6] Stop any previous bridge process launched by this task'
& schtasks.exe /End /TN $TaskName 2>$null | Out-Null
Start-Sleep -Seconds 1

Write-Host '[6/6] Start bridge now'
& schtasks.exe /Run /TN $TaskName | Out-Host
if ($LASTEXITCODE -ne 0) { throw "schtasks /Run failed: $LASTEXITCODE" }

Start-Sleep -Seconds 2
& schtasks.exe /Query /TN $TaskName /V /FO LIST | Out-Host

Write-Host ''
Write-Host 'Installed.'
Write-Host "Queue: https://github.com/$Repo/issues/$Issue"
Write-Host "Runtime: $root"
Write-Host "Task: $TaskName"
Write-Host 'The daemon now polls the private queue and runs new controller tasks with codex exec.'

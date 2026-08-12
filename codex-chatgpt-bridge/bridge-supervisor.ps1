param(
    [string]$Repo = 'KAFKA2306/basic_prompts',
    [int]$Issue = 1,
    [int]$PollSeconds = 30
)

$ErrorActionPreference = 'Continue'
$root = Join-Path $env:LOCALAPPDATA 'OpenAI\CodexChatGPTBridge'
$daemon = Join-Path $root 'bridge-daemon.ps1'
$logDir = Join-Path $root 'logs'
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$supervisorLog = Join-Path $logDir 'supervisor.log'

while ($true) {
    if (-not (Test-Path $daemon)) {
        Add-Content -Path $supervisorLog -Value "$(Get-Date -Format o) daemon missing: $daemon" -Encoding utf8
        Start-Sleep -Seconds 30
        continue
    }

    Add-Content -Path $supervisorLog -Value "$(Get-Date -Format o) starting daemon" -Encoding utf8
    try {
        & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $daemon -Repo $Repo -Issue $Issue -PollSeconds $PollSeconds
        $code = $LASTEXITCODE
        Add-Content -Path $supervisorLog -Value "$(Get-Date -Format o) daemon exited code=$code" -Encoding utf8
    }
    catch {
        Add-Content -Path $supervisorLog -Value "$(Get-Date -Format o) daemon exception=$($_.Exception.Message)" -Encoding utf8
    }

    Start-Sleep -Seconds 5
}

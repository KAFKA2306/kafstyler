param(
    [string]$Repo = 'KAFKA2306/kafstyler',
    [int]$Issue = 3,
    [int]$PollSeconds = 10
)

$ErrorActionPreference = 'Continue'
$root = Join-Path $env:LOCALAPPDATA 'OpenAI\CodexChatGPTBridge'
$daemon = Join-Path $root 'bridge-daemon.ps1'
$logDir = Join-Path $root 'logs'
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$supervisorLog = Join-Path $logDir 'supervisor-v2.log'

while ($true) {
    if (-not (Test-Path -LiteralPath $daemon -PathType Leaf)) {
        Add-Content -Path $supervisorLog -Value "$(Get-Date -Format o) daemon missing: $daemon" -Encoding utf8
        Start-Sleep -Seconds 30
        continue
    }

    Add-Content -Path $supervisorLog -Value "$(Get-Date -Format o) starting bridge v2 daemon" -Encoding utf8
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

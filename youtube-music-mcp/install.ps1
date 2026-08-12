param(
    [string]$ClientSecret = ""
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Require-Command([string]$Name) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Required command not found: $Name"
    }
}

Require-Command "uv"
Require-Command "codex"

$SourceDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $SourceDir
$InstallDir = Join-Path $env:LOCALAPPDATA "OpenAI\YouTubeMusicMCP"
$VenvDir = Join-Path $InstallDir ".venv"
$PythonExe = Join-Path $VenvDir "Scripts\python.exe"
$ServerPath = Join-Path $InstallDir "server.py"
$AuthPath = Join-Path $InstallDir "auth.py"

New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
Copy-Item (Join-Path $SourceDir "server.py") $ServerPath -Force
Copy-Item (Join-Path $SourceDir "auth.py") $AuthPath -Force
Copy-Item (Join-Path $SourceDir "pyproject.toml") (Join-Path $InstallDir "pyproject.toml") -Force

Write-Host "[1/5] Creating/updating isolated uv environment..."
& uv sync --project $InstallDir
if ($LASTEXITCODE -ne 0) {
    throw "uv sync failed with exit code $LASTEXITCODE"
}

if (-not (Test-Path $PythonExe)) {
    throw "Expected Python executable not found: $PythonExe"
}

Write-Host "[2/5] Registering MCP server with normal interactive Codex..."
$McpList = (& codex mcp list 2>&1 | Out-String)
if ($McpList -match "(?m)^\s*youtube_music\b") {
    Write-Host "youtube_music is already registered; the deterministic install path is unchanged."
}
else {
    & codex mcp add youtube_music -- $PythonExe $ServerPath
    if ($LASTEXITCODE -ne 0) {
        throw "codex mcp add failed with exit code $LASTEXITCODE"
    }
}

Write-Host "[3/5] OAuth setup..."
if ([string]::IsNullOrWhiteSpace($ClientSecret)) {
    Write-Host "OAuth not run: no -ClientSecret path supplied."
    Write-Host "After downloading a Google OAuth Desktop client JSON, run:"
    Write-Host "  & '$PythonExe' '$AuthPath' 'C:\path\to\client_secret.json'"
}
else {
    $ResolvedClientSecret = (Resolve-Path $ClientSecret).Path
    & $PythonExe $AuthPath $ResolvedClientSecret
    if ($LASTEXITCODE -ne 0) {
        throw "OAuth bootstrap failed with exit code $LASTEXITCODE"
    }
}

Write-Host "[4/5] Refreshing ChatGPT-Codex bridge allowlist support when the bridge is installed..."
$BridgeSource = Join-Path $RepoRoot "codex-chatgpt-bridge\bridge-daemon.ps1"
$BridgeRuntimeDir = Join-Path $env:LOCALAPPDATA "OpenAI\CodexChatGPTBridge"
$BridgeRuntime = Join-Path $BridgeRuntimeDir "bridge-daemon.ps1"
$BridgeTaskName = "OpenAI Codex ChatGPT Bridge"

if ((Test-Path $BridgeSource -PathType Leaf) -and (Test-Path $BridgeRuntimeDir -PathType Container)) {
    $TaskExists = $false
    if (Get-Command schtasks.exe -ErrorAction SilentlyContinue) {
        & schtasks.exe /Query /TN $BridgeTaskName *> $null
        $TaskExists = ($LASTEXITCODE -eq 0)
    }

    if ($TaskExists) {
        & schtasks.exe /End /TN $BridgeTaskName *> $null
        Start-Sleep -Seconds 1
    }

    Copy-Item $BridgeSource $BridgeRuntime -Force
    Write-Host "Updated bridge daemon: $BridgeRuntime"

    if ($TaskExists) {
        & schtasks.exe /Run /TN $BridgeTaskName | Out-Host
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to restart scheduled task: $BridgeTaskName"
        }
        Write-Host "Restarted scheduled task: $BridgeTaskName"
    }
}
else {
    Write-Host "Bridge runtime not installed; skipped bridge refresh."
}

Write-Host "[5/5] Verification..."
& codex mcp list
if ($LASTEXITCODE -ne 0) {
    throw "codex mcp list failed with exit code $LASTEXITCODE"
}

Write-Host ""
Write-Host "YouTube Music MCP files: $InstallDir"
Write-Host "MCP server name: youtube_music"
Write-Host "Expected tools: search_music, create_playlist, add_video_to_playlist, list_my_playlists, list_playlist_items"
if (Test-Path (Join-Path $InstallDir "token.json")) {
    Write-Host "OAuth token: configured"
}
else {
    Write-Host "OAuth token: NOT configured yet"
}

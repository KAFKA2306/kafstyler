param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^tunnel_')]
    [string]$TunnelId,

    [string]$RuntimeApiKey,

    [string]$ProfileName = 'codex-chatgpt',

    [string]$TaskName = 'OpenAI Codex ChatGPT MCP Tunnel'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Get-PlainTextFromSecureString([Security.SecureString]$Secure) {
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Secure)
    try {
        return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    }
    finally {
        if ($bstr -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
        }
    }
}

Write-Host '[1/7] Verify Codex CLI'
$codex = Get-Command codex -ErrorAction Stop
& $codex.Source --version
& $codex.Source mcp-server --help | Out-Null

$root = Join-Path $env:LOCALAPPDATA 'OpenAI\CodexChatGPTMcp'
New-Item -ItemType Directory -Force -Path $root | Out-Null
$tunnelClient = Join-Path $root 'tunnel-client.exe'
$keyFile = Join-Path $root 'runtime-key.dpapi'
$sourceStartScript = Join-Path $PSScriptRoot 'start.ps1'
$installedStartScript = Join-Path $root 'start.ps1'

if (-not (Test-Path $sourceStartScript)) {
    throw "start.ps1 must be next to install.ps1: $sourceStartScript"
}
Copy-Item -Path $sourceStartScript -Destination $installedStartScript -Force

Write-Host '[2/7] Acquire OpenAI OSS tunnel-client latest release'
$headers = @{ 'User-Agent' = 'KAFKA2306-codex-chatgpt-mcp-bootstrap' }
$release = Invoke-RestMethod -Headers $headers -Uri 'https://api.github.com/repos/openai/tunnel-client/releases/latest'

$assetName = if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') {
    'windows-arm64.zip'
} else {
    'windows-amd64.zip'
}

$asset = $release.assets | Where-Object { $_.name -eq $assetName } | Select-Object -First 1
if (-not $asset) {
    throw "Asset $assetName was not found in latest openai/tunnel-client release $($release.tag_name)."
}

$temp = Join-Path ([IO.Path]::GetTempPath()) ("codex-chatgpt-mcp-" + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $temp | Out-Null
try {
    $zip = Join-Path $temp $assetName
    Invoke-WebRequest -Headers $headers -Uri $asset.browser_download_url -OutFile $zip
    $expanded = Join-Path $temp 'expanded'
    Expand-Archive -Path $zip -DestinationPath $expanded -Force
    $exe = Get-ChildItem -Path $expanded -Filter 'tunnel-client.exe' -File -Recurse | Select-Object -First 1
    if (-not $exe) {
        throw 'Downloaded archive did not contain tunnel-client.exe.'
    }
    Copy-Item -Path $exe.FullName -Destination $tunnelClient -Force
}
finally {
    Remove-Item -Path $temp -Recurse -Force -ErrorAction SilentlyContinue
}

& $tunnelClient --version

Write-Host '[3/7] Protect runtime API key with Windows DPAPI'
$secureKey = if ($RuntimeApiKey) {
    ConvertTo-SecureString $RuntimeApiKey -AsPlainText -Force
} elseif ($env:CONTROL_PLANE_API_KEY) {
    ConvertTo-SecureString $env:CONTROL_PLANE_API_KEY -AsPlainText -Force
} else {
    Read-Host 'OpenAI tunnel runtime API key' -AsSecureString
}

$secureKey | ConvertFrom-SecureString | Set-Content -Path $keyFile -Encoding ascii

Write-Host '[4/7] Initialize tunnel profile for codex mcp-server'
$env:CONTROL_PLANE_API_KEY = Get-PlainTextFromSecureString $secureKey
try {
    & $tunnelClient init `
        --sample sample_mcp_stdio_local `
        --profile $ProfileName `
        --tunnel-id $TunnelId `
        --mcp-command 'codex mcp-server'

    if ($LASTEXITCODE -ne 0) {
        throw "tunnel-client init failed with exit code $LASTEXITCODE"
    }

    Write-Host '[5/7] Run tunnel diagnostics'
    & $tunnelClient doctor --profile $ProfileName --explain
    if ($LASTEXITCODE -ne 0) {
        throw "tunnel-client doctor failed with exit code $LASTEXITCODE"
    }
}
finally {
    Remove-Item Env:CONTROL_PLANE_API_KEY -ErrorAction SilentlyContinue
}

Write-Host '[6/7] Register tunnel daemon at Windows logon'
$taskCommand = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$installedStartScript`" -ProfileName `"$ProfileName`""
& schtasks.exe /Create /F /SC ONLOGON /TN $TaskName /TR $taskCommand /RL LIMITED | Out-Host
if ($LASTEXITCODE -ne 0) {
    throw "schtasks /Create failed with exit code $LASTEXITCODE"
}

Write-Host '[7/7] Start tunnel now'
& schtasks.exe /Run /TN $TaskName | Out-Host
if ($LASTEXITCODE -ne 0) {
    throw "schtasks /Run failed with exit code $LASTEXITCODE"
}

Write-Host ''
Write-Host 'Bootstrap complete.'
Write-Host "Tunnel ID: $TunnelId"
Write-Host "Profile:   $ProfileName"
Write-Host "Task:      $TaskName"
Write-Host "Local dir: $root"
Write-Host ''
Write-Host 'Final one-time UI step: in ChatGPT Developer mode, create an app using Connection = Tunnel and select this tunnel ID.'

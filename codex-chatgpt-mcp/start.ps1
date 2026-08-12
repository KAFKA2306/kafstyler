param(
    [string]$ProfileName = 'codex-chatgpt'
)

$ErrorActionPreference = 'Stop'
$root = Join-Path $env:LOCALAPPDATA 'OpenAI\CodexChatGPTMcp'
$tunnelClient = Join-Path $root 'tunnel-client.exe'
$keyFile = Join-Path $root 'runtime-key.dpapi'
$logDir = Join-Path $root 'logs'

if (-not (Test-Path $tunnelClient)) {
    throw "tunnel-client.exe not found: $tunnelClient"
}
if (-not (Test-Path $keyFile)) {
    throw "Encrypted runtime API key not found: $keyFile"
}

New-Item -ItemType Directory -Force -Path $logDir | Out-Null

$encrypted = Get-Content -Raw -Path $keyFile
$secure = ConvertTo-SecureString $encrypted
$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
try {
    $plain = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    $env:CONTROL_PLANE_API_KEY = $plain
}
finally {
    if ($bstr -ne [IntPtr]::Zero) {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    }
}

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$log = Join-Path $logDir "tunnel-$stamp.log"

try {
    & $tunnelClient run --profile $ProfileName *>&1 | Tee-Object -FilePath $log
    exit $LASTEXITCODE
}
finally {
    Remove-Item Env:CONTROL_PLANE_API_KEY -ErrorAction SilentlyContinue
}

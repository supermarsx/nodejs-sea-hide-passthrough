<#
PowerShell helper to build AutoIt script.
Compiles nodejs-sea-hide-passthrough.au3 to .exe using Aut2Exe.
#>
Write-Host "→ build: starting (Aut2Exe)..."

$scriptName = "nodejs-sea-hide-passthrough.au3"
$exeName = "nodejs-sea-hide-passthrough.exe"
$iconName = "icon.ico"

if (-not (Test-Path $scriptName)) {
    Write-Host "ERROR: Source file '$scriptName' not found."
    exit 1
}

# Common AutoIt paths
$aut2Exe = "Aut2Exe.exe"
$commonPaths = @(
    "C:\Program Files (x86)\AutoIt3\Aut2Exe\Aut2Exe.exe",
    "C:\Program Files\AutoIt3\Aut2Exe\Aut2Exe.exe"
)

# Use full path if Aut2Exe is not in PATH
if (-not (Get-Command $aut2Exe -ErrorAction SilentlyContinue)) {
    foreach ($path in $commonPaths) {
        if (Test-Path $path) {
            $aut2Exe = $path
            break
        }
    }
}

if (-not (Get-Command $aut2Exe -ErrorAction SilentlyContinue) -and -not (Test-Path $aut2Exe)) {
    Write-Host "ERROR: Aut2Exe.exe not found. Please install AutoIt3."
    exit 1
}

$buildArgs = @("/in", "$scriptName", "/out", "$exeName")

if (Test-Path $iconName) {
    $buildArgs += "/icon"
    $buildArgs += "$iconName"
}

Write-Host "Compiling $scriptName -> $exeName..."
& $aut2Exe $buildArgs

if ($LASTEXITCODE -eq 0) {
    Write-Host "Build successful: $exeName"
    exit 0
} else {
    Write-Host "Build failed."
    exit $LASTEXITCODE
}

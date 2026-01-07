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
} else {
    Write-Host "Build failed."
    exit $LASTEXITCODE
}

# --- Packaging & UPX ---

$configFile = "config.ini"
$zipNormal = "nodejs-sea-hide-passthrough.zip"
$exeUpx = "nodejs-sea-hide-passthrough-upx.exe"
$zipUpx = "nodejs-sea-hide-passthrough-upx.zip"

# Ensure files exist before packaging
if (-not (Test-Path $exeName) -or -not (Test-Path $configFile)) {
    Write-Error "Missing build artifacts for packaging. Ensure $exeName and $configFile exist."
    exit 1
}

# 1. Zip with binary and config
Write-Host "Creating $zipNormal from $exeName and $configFile..."
try {
    if (Test-Path $zipNormal) { Remove-Item $zipNormal -Force }
    Compress-Archive -Path $exeName, $configFile -DestinationPath $zipNormal -Force -ErrorAction Stop
} catch {
    Write-Error "Failed to create $zipNormal : $_"
    exit 1
}

# 2. Check for UPX
# Check PATH, then check Chocolatey standard path
$upxPath = Get-Command "upx.exe" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
if (-not $upxPath) {
    $chocoUpx = "C:\ProgramData\chocolatey\bin\upx.exe"
    if (Test-Path $chocoUpx) {
        $upxPath = $chocoUpx
    }
}

if ($upxPath) {
    Write-Host "UPX found at '$upxPath'. Creating compressed binary..."
    
    # Copy original to new name for UPX
    Copy-Item $exeName -Destination $exeUpx -Force
    
    # Run UPX
    & $upxPath --best $exeUpx
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "UPX compression successful: $exeUpx"
        
        # 3. Zip with upxed binary and config
        Write-Host "Creating $zipUpx..."
        try {
            if (Test-Path $zipUpx) { Remove-Item $zipUpx -Force }
            Compress-Archive -Path $exeUpx, $configFile -DestinationPath $zipUpx -Force -ErrorAction Stop
        } catch {
             Write-Error "Failed to create $zipUpx : $_"
             exit 1
        }
    } else {
        Write-Warning "UPX compression failed. Skipping UPX artifacts."
    }
} else {
    Write-Warning "UPX not found. Skipping UPX artifacts." 
    # Not failing the build, just skipping optional artifacts
}

exit 0

<#
PowerShell helper to build AutoIt script.
Compiles nodejs-sea-hide-passthrough.au3 to .exe using Aut2Exe.
#>
Write-Host "→ build: starting (Aut2Exe) at $(Get-Date)"

$scriptName = "nodejs-sea-hide-passthrough.au3"
$exeName = "nodejs-sea-hide-passthrough.exe"
$iconName = "icon.ico"

Write-Host "Configuration:"
Write-Host "  Script: $scriptName"
Write-Host "  Output: $exeName"
Write-Host "  Icon:   $iconName"

if (-not (Test-Path $scriptName)) {
    Write-Host "ERROR: Source file '$scriptName' not found."
    exit 1
}
else {
    Write-Host "  [OK] Source file found."
}

# Common AutoIt paths
$aut2Exe = "Aut2Exe.exe"
$commonPaths = @(
    "C:\Program Files (x86)\AutoIt3\Aut2Exe\Aut2Exe.exe",
    "C:\Program Files\AutoIt3\Aut2Exe\Aut2Exe.exe"
)

Write-Host "Searching for Aut2Exe..."
# Use full path if Aut2Exe is not in PATH
if (-not (Get-Command $aut2Exe -ErrorAction SilentlyContinue)) {
    foreach ($path in $commonPaths) {
        Write-Host "  Checking: $path"
        if (Test-Path $path) {
            $aut2Exe = $path
            Write-Host "  [Found] $path"
            break
        }
    }
}
else {
    Write-Host "  [Found] Aut2Exe in PATH"
}

if (-not (Get-Command $aut2Exe -ErrorAction SilentlyContinue) -and -not (Test-Path $aut2Exe)) {
    Write-Host "ERROR: Aut2Exe.exe not found. Please install AutoIt3."
    exit 1
}

# Convert to absolute paths to avoid issues with Aut2Exe
$scriptAbs = (Resolve-Path $scriptName).Path
$exeAbs = "$PWD\$exeName"
$iconAbs = if (Test-Path $iconName) { (Resolve-Path $iconName).Path } else { $null }

$buildArgs = @("/in", "$scriptAbs", "/out", "$exeAbs")

if ($iconAbs) {
    Write-Host "  [Info] Icon file found, adding to build arguments."
    $buildArgs += "/icon"
    $buildArgs += "$iconAbs"
}
else {
    Write-Host "  [Info] Icon file not found, skipping icon."
}

# Add x64 flag if running on 64-bit OS? Unsure if needed, but sometimes helps.
# Removing implicit assumptions.

Write-Host "Compiling $scriptName -> $exeName..."
Write-Host "  Command: & `"$aut2Exe`" $buildArgs"

# Execute
$process = Start-Process -FilePath $aut2Exe -ArgumentList $buildArgs -Wait -NoNewWindow -PassThru
$exitCode = $process.ExitCode

if (Test-Path $exeName) {
    Write-Host "Build successful: $exeName (Exit Code: $exitCode)"
    Write-Host "  File size: $((Get-Item $exeName).Length) bytes"
}
else {
    Write-Error "Build failed. Output file '$exeName' not created. Exit Code: $exitCode"
    exit 1
}

# --- Packaging & UPX ---
Write-Host "`n--- Packaging & UPX Start ---"

$configFile = "config.ini"
$zipNormal = "nodejs-sea-hide-passthrough.zip"
$exeUpx = "nodejs-sea-hide-passthrough-upx.exe"
$zipUpx = "nodejs-sea-hide-passthrough-upx.zip"

Write-Host "Packaging Config:"
Write-Host "  Config File: $configFile"
Write-Host "  Zip Normal:  $zipNormal"
Write-Host "  Exe UPX:     $exeUpx"
Write-Host "  Zip UPX:     $zipUpx"

# Ensure files exist before packaging
Write-Host "Verifying artifacts..."
if (-not (Test-Path $exeName)) {
    Write-Error "  [Missing] $exeName"
    exit 1
}
if (-not (Test-Path $configFile)) {
    Write-Error "  [Missing] $configFile"
    exit 1
}
Write-Host "  [OK] Artifacts present."

# 1. Zip with binary and config
Write-Host "1. Creating $zipNormal from $exeName and $configFile..."
try {
    if (Test-Path $zipNormal) { 
        Write-Host "  Removing existing $zipNormal..."
        Remove-Item $zipNormal -Force 
    }
    Compress-Archive -Path $exeName, $configFile -DestinationPath $zipNormal -Force -ErrorAction Stop
    Write-Host "  [Success] Created $zipNormal"
}
catch {
    Write-Error "Failed to create $zipNormal : $_"
    exit 1
}

# 2. Check for UPX
Write-Host "2. Checking for UPX..."
# Check PATH, then check Chocolatey standard path
$upxPath = Get-Command "upx.exe" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
if (-not $upxPath) {
    $chocoUpx = "C:\ProgramData\chocolatey\bin\upx.exe"
    Write-Host "  Searching Choco path: $chocoUpx"
    if (Test-Path $chocoUpx) {
        $upxPath = $chocoUpx
    }
}

if ($upxPath) {
    Write-Host "  [Found] UPX found at '$upxPath'."
    Write-Host "  Creating compressed binary..."
    
    # Copy original to new name for UPX
    Write-Host "  Copying $exeName to $exeUpx..."
    Copy-Item $exeName -Destination $exeUpx -Force
    if (Test-Path $exeUpx) {
        Write-Host "  [OK] Copy created."
    }
    else {
        Write-Error "  [Error] Failed to create copy."
        exit 1
    }
    
    # Run UPX
    Write-Host "  Running UPX: & `"$upxPath`" --best `"$exeUpx`""
    & $upxPath --best $exeUpx
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [Success] UPX compression successful: $exeUpx"
        Write-Host "    New size: $((Get-Item $exeUpx).Length) bytes"
        
        # 3. Zip with upxed binary and config
        Write-Host "3. Creating $zipUpx..."
        try {
            if (Test-Path $zipUpx) { 
                Write-Host "  Removing existing $zipUpx..."
                Remove-Item $zipUpx -Force 
            }
            Compress-Archive -Path $exeUpx, $configFile -DestinationPath $zipUpx -Force -ErrorAction Stop
            Write-Host "  [Success] Created $zipUpx"
        }
        catch {
            Write-Error "Failed to create $zipUpx : $_"
            exit 1
        }
    }
    else {
        Write-Warning "  [Failed] UPX compression failed (Exit Code: $LASTEXITCODE). Skipping UPX artifacts."
    }
}
else {
    Write-Warning "  [Not Found] UPX not found. Skipping UPX artifacts." 
    # Not failing the build, just skipping optional artifacts
}

Write-Host "→ build: finished at $(Get-Date)"
exit 0

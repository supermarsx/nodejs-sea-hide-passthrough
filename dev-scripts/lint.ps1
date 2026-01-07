<#
PowerShell helper to run linting for AutoIt.
Checks all .au3 files using Au3Check.
#>
Write-Host "→ lint: starting (Au3Check)..."

# Common AutoIt paths
$au3Check = "Au3Check.exe"
$commonPaths = @(
    "C:\Program Files (x86)\AutoIt3\Au3Check.exe",
    "C:\Program Files\AutoIt3\Au3Check.exe"
)

# Use full path if Au3Check is not in PATH
if (-not (Get-Command $au3Check -ErrorAction SilentlyContinue)) {
    foreach ($path in $commonPaths) {
        if (Test-Path $path) {
            $au3Check = $path
            break
        }
    }
}

if (-not (Get-Command $au3Check -ErrorAction SilentlyContinue) -and -not (Test-Path $au3Check)) {
    Write-Host "ERROR: Au3Check.exe not found in PATH or standard locations."
    exit 1
}

# Find all .au3 files
$files = Get-ChildItem -Path . -Recurse -Filter "*.au3"
if ($files.Count -eq 0) {
    Write-Host "No .au3 files found to lint."
    exit 0
}

$anyError = $false

foreach ($file in $files) {
    Write-Host "Checking: $($file.Name)"
    & $au3Check "$($file.FullName)"
    if ($LASTEXITCODE -ne 0) {
        $anyError = $true
    }
}

if ($anyError) {
    Write-Host "Linting encountered errors."
    exit 1
} else {
    Write-Host "Linting passed."
    exit 0
}

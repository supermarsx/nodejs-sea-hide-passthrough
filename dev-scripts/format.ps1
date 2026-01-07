<#
PowerShell helper to format AutoIt scripts.
Uses Tidy (SciTE4AutoIt3).
#>
Write-Host "→ format: starting (Tidy)..."

$files = Get-ChildItem -Path . -Recurse -Filter "*.au3"

# Find Tidy executable
$tidy = "Tidy.exe"
$commonPaths = @(
    "C:\Program Files (x86)\AutoIt3\SciTE\Tidy\Tidy.exe",
    "C:\Program Files\AutoIt3\SciTE\Tidy\Tidy.exe"
)

if (-not (Get-Command $tidy -ErrorAction SilentlyContinue)) {
    foreach ($path in $commonPaths) {
        if (Test-Path $path) {
            $tidy = $path
            break
        }
    }
}

if (-not (Get-Command $tidy -ErrorAction SilentlyContinue) -and -not (Test-Path $tidy)) {
    Write-Host "WARNING: Tidy.exe not found. Install SciTE4AutoIt3 for formatting support."
    exit 0 
}

foreach ($file in $files) {
    # Skip backup/TidyBackup folders if present
    if ($file.FullName -match "\\TidyBackup\\|\\Backup\\") { continue }
    
    Write-Host "Formatting: $($file.Name)"
    & $tidy "$($file.FullName)"
}

Write-Host "Formatting complete."

<#
PowerShell helper to run AutoIt tests.
Searches for *_test.au3 or test_*.au3 files and runs them.
#>
Write-Host "→ test: starting..."

$testFiles = Get-ChildItem -Path . -Recurse -Include "*_test.au3", "test_*.au3"

if ($testFiles.Count -eq 0) {
    Write-Host "No test files found (*_test.au3 or test_*.au3)."
    Write-Host "Running basic syntax check (lint) as a fallback test..."
    & "$PSScriptRoot\lint.ps1"
    exit $LASTEXITCODE
}

# Find AutoIt3 executable
$autoIt3 = "AutoIt3.exe"
$commonPaths = @(
    "C:\Program Files (x86)\AutoIt3\AutoIt3.exe",
    "C:\Program Files\AutoIt3\AutoIt3.exe"
)

if (-not (Get-Command $autoIt3 -ErrorAction SilentlyContinue)) {
    foreach ($path in $commonPaths) {
        if (Test-Path $path) {
            $autoIt3 = $path
            break
        }
    }
}

if (-not (Get-Command $autoIt3 -ErrorAction SilentlyContinue) -and -not (Test-Path $autoIt3)) {
    Write-Host "ERROR: AutoIt3.exe not found."
    exit 1
}

$anyFailed = $false

foreach ($test in $testFiles) {
    Write-Host "Running test: $($test.Name)"
    # /ErrorStdOut allows capturing errors if script crashes
    & $autoIt3 /ErrorStdOut "$($test.FullName)"
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "FAILED: $($test.Name)" -ForegroundColor Red
        $anyFailed = $true
    } else {
        Write-Host "PASSED: $($test.Name)" -ForegroundColor Green
    }
}

if ($anyFailed) {
    Write-Host "Some tests failed."
    exit 1
} else {
    Write-Host "All tests passed."
    exit 0
}

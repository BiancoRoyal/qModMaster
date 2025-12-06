# qModMaster Start Script for Windows PowerShell
# This script sets up the environment and starts qModMaster on Windows

Write-Host "Starting qModMaster on Windows..." -ForegroundColor Green

# Get the directory where this script is located
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

# Check for Qt installation in common locations
$QtFound = $false
$QtPaths = @(
    "C:\Qt",
    "$env:USERPROFILE\Qt",
    "$env:ProgramFiles\Qt",
    "${env:ProgramFiles(x86)}\Qt"
)

foreach ($QtBase in $QtPaths) {
    if (Test-Path $QtBase) {
        # Try to find the latest Qt version
        $QtVersions = Get-ChildItem -Path $QtBase -Directory | Where-Object { $_.Name -match '^\d+\.\d+' } | Sort-Object Name -Descending
        
        foreach ($QtVersion in $QtVersions) {
            $QtPathsToCheck = @(
                "$QtBase\$($QtVersion.Name)\msvc2019_64",
                "$QtBase\$($QtVersion.Name)\msvc2022_64",
                "$QtBase\$($QtVersion.Name)\mingw_64",
                "$QtBase\$($QtVersion.Name)\msvc2019_32",
                "$QtBase\$($QtVersion.Name)\mingw_32"
            )
            
            foreach ($QtPath in $QtPathsToCheck) {
                if (Test-Path "$QtPath\bin\qmake.exe") {
                    $env:PATH = "$QtPath\bin;$env:PATH"
                    $env:QT_PLUGIN_PATH = "$QtPath\plugins"
                    $QtFound = $true
                    Write-Host "Found Qt at: $QtPath" -ForegroundColor Yellow
                    break
                }
            }
            
            if ($QtFound) { break }
        }
        
        if ($QtFound) { break }
    }
}

# Start the application
$ExePaths = @(
    "qModMaster.exe",
    "qModMaster\qModMaster.exe",
    "release\qModMaster.exe",
    "debug\qModMaster.exe"
)

$ExeFound = $false
foreach ($ExePath in $ExePaths) {
    if (Test-Path $ExePath) {
        Write-Host "Starting $ExePath..." -ForegroundColor Green
        Start-Process -FilePath $ExePath -WorkingDirectory $ScriptDir
        $ExeFound = $true
        break
    }
}

if (-not $ExeFound) {
    Write-Host "Error: qModMaster executable not found!" -ForegroundColor Red
    Write-Host "Please build the project first using: qmake && nmake" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "qModMaster started successfully!" -ForegroundColor Green
Start-Sleep -Seconds 2


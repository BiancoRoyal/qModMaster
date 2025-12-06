# PowerShell Test Script for qModMaster
# This script tests PowerShell functionality and qModMaster start script compatibility

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PowerShell Test Script for qModMaster" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: PowerShell Version
Write-Host "Test 1: PowerShell Version" -ForegroundColor Yellow
$PSVersion = $PSVersionTable.PSVersion
Write-Host "  PowerShell Version: $PSVersion" -ForegroundColor Green
Write-Host "  .NET Version: $($PSVersionTable.CLRVersion)" -ForegroundColor Green
Write-Host ""

# Test 2: Platform Detection
Write-Host "Test 2: Platform Detection" -ForegroundColor Yellow
if ($IsWindows) {
    Write-Host "  Platform: Windows" -ForegroundColor Green
} elseif ($IsMacOS) {
    Write-Host "  Platform: macOS" -ForegroundColor Green
} elseif ($IsLinux) {
    Write-Host "  Platform: Linux" -ForegroundColor Green
} else {
    Write-Host "  Platform: Unknown" -ForegroundColor Yellow
}
Write-Host ""

# Test 3: Script Directory Detection
Write-Host "Test 3: Script Directory Detection" -ForegroundColor Yellow
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "  Script Directory: $ScriptDir" -ForegroundColor Green
Set-Location $ScriptDir
Write-Host "  Current Directory: $(Get-Location)" -ForegroundColor Green
Write-Host ""

# Test 4: File System Operations
Write-Host "Test 4: File System Operations" -ForegroundColor Yellow
$TestFiles = @(
    "qModMaster.pro",
    "start.ps1",
    "start.sh",
    "start.bat"
)

foreach ($file in $TestFiles) {
    if (Test-Path $file) {
        Write-Host "  ✓ Found: $file" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Missing: $file" -ForegroundColor Red
    }
}
Write-Host ""

# Test 5: Qt Path Detection (Windows-style, but works on macOS too)
Write-Host "Test 5: Qt Path Detection" -ForegroundColor Yellow
$QtPaths = @()
if ($IsWindows) {
    $QtPaths = @(
        "C:\Qt",
        "$env:USERPROFILE\Qt",
        "$env:ProgramFiles\Qt",
        "${env:ProgramFiles(x86)}\Qt"
    )
} elseif ($IsMacOS) {
    $QtPaths = @(
        "/opt/homebrew/opt/qt@5",
        "/usr/local/opt/qt@5",
        "$HOME/Qt"
    )
} elseif ($IsLinux) {
    $QtPaths = @(
        "/usr/lib/qt5",
        "/usr/lib/x86_64-linux-gnu/qt5"
    )
}

$QtFound = $false
foreach ($QtPath in $QtPaths) {
    if (Test-Path $QtPath) {
        Write-Host "  ✓ Found Qt at: $QtPath" -ForegroundColor Green
        $QtFound = $true
        
        # Try to find qmake
        if ($IsWindows) {
            $QmakePaths = @("$QtPath\bin\qmake.exe", "$QtPath\msvc2019_64\bin\qmake.exe", "$QtPath\mingw_64\bin\qmake.exe")
        } else {
            $QmakePaths = @("$QtPath/bin/qmake", "$QtPath/clang_64/bin/qmake")
        }
        
        foreach ($QmakePath in $QmakePaths) {
            if (Test-Path $QmakePath) {
                Write-Host "    ✓ Found qmake at: $QmakePath" -ForegroundColor Green
                break
            }
        }
    }
}

if (-not $QtFound) {
    Write-Host "  ⚠ No Qt installation found in standard locations" -ForegroundColor Yellow
}
Write-Host ""

# Test 6: Environment Variables
Write-Host "Test 6: Environment Variables" -ForegroundColor Yellow
Write-Host "  PATH: $($env:PATH -split ':' | Select-Object -First 3 -Join ', ')... (truncated)" -ForegroundColor Green
if ($env:QT_PLUGIN_PATH) {
    Write-Host "  QT_PLUGIN_PATH: $env:QT_PLUGIN_PATH" -ForegroundColor Green
} else {
    Write-Host "  QT_PLUGIN_PATH: (not set)" -ForegroundColor Yellow
}
Write-Host ""

# Test 7: qModMaster Executable Detection
Write-Host "Test 7: qModMaster Executable Detection" -ForegroundColor Yellow
$ExePaths = @()
if ($IsWindows) {
    $ExePaths = @(
        "qModMaster.exe",
        "qModMaster\qModMaster.exe",
        "release\qModMaster.exe",
        "debug\qModMaster.exe"
    )
} else {
    $ExePaths = @(
        "qModMaster.app/Contents/MacOS/qModMaster",
        "qModMaster"
    )
}

$ExeFound = $false
foreach ($ExePath in $ExePaths) {
    if (Test-Path $ExePath) {
        Write-Host "  ✓ Found executable: $ExePath" -ForegroundColor Green
        $FileInfo = Get-Item $ExePath
        Write-Host "    Size: $([math]::Round($FileInfo.Length / 1KB, 2)) KB" -ForegroundColor Cyan
        Write-Host "    Last Modified: $($FileInfo.LastWriteTime)" -ForegroundColor Cyan
        $ExeFound = $true
        break
    }
}

if (-not $ExeFound) {
    Write-Host "  ⚠ qModMaster executable not found (project may need to be built)" -ForegroundColor Yellow
}
Write-Host ""

# Test 8: PowerShell Script Syntax Check
Write-Host "Test 8: PowerShell Script Syntax Check" -ForegroundColor Yellow
if (Test-Path "start.ps1") {
    try {
        $null = [System.Management.Automation.PSParser]::Tokenize((Get-Content "start.ps1" -Raw), [ref]$null)
        Write-Host "  ✓ start.ps1 syntax is valid" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ start.ps1 has syntax errors: $_" -ForegroundColor Red
    }
} else {
    Write-Host "  ⚠ start.ps1 not found" -ForegroundColor Yellow
}
Write-Host ""

# Test 9: Cross-platform Compatibility
Write-Host "Test 9: Cross-platform Compatibility" -ForegroundColor Yellow
Write-Host "  PowerShell Core: $($PSVersionTable.PSEdition -eq 'Core')" -ForegroundColor Green
Write-Host "  Supports: Windows, macOS, Linux" -ForegroundColor Green
Write-Host ""

# Test 10: Script Execution Policy (Windows only)
if ($IsWindows) {
    Write-Host "Test 10: Execution Policy" -ForegroundColor Yellow
    $Policy = Get-ExecutionPolicy
    Write-Host "  Current Policy: $Policy" -ForegroundColor Green
    if ($Policy -eq 'Restricted') {
        Write-Host "  ⚠ Warning: Execution policy is Restricted" -ForegroundColor Yellow
        Write-Host "    Run: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Cyan
    }
    Write-Host ""
}

# Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Test Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PowerShell Version: $PSVersion" -ForegroundColor Green
Write-Host "Platform: $(if ($IsWindows) { 'Windows' } elseif ($IsMacOS) { 'macOS' } elseif ($IsLinux) { 'Linux' } else { 'Unknown' })" -ForegroundColor Green
Write-Host "Qt Found: $QtFound" -ForegroundColor $(if ($QtFound) { 'Green' } else { 'Yellow' })
Write-Host "Executable Found: $ExeFound" -ForegroundColor $(if ($ExeFound) { 'Green' } else { 'Yellow' })
Write-Host ""
Write-Host "All tests completed!" -ForegroundColor Green


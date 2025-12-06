@echo off
REM qModMaster Start Script for Windows
REM This script sets up the environment and starts qModMaster on Windows

echo Starting qModMaster on Windows...

REM Get the directory where this script is located
set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%"

REM Check for Qt installation in common locations
set QT_FOUND=0

REM Check for Qt in Program Files
if exist "C:\Qt" (
    REM Try to find the latest Qt version
    for /f "delims=" %%i in ('dir /b /ad /o-n "C:\Qt" 2^>nul') do (
        if exist "C:\Qt\%%i\msvc2019_64\bin\qmake.exe" (
            set "PATH=C:\Qt\%%i\msvc2019_64\bin;%PATH%"
            set "QT_PLUGIN_PATH=C:\Qt\%%i\msvc2019_64\plugins"
            set QT_FOUND=1
            goto :qt_found
        )
        if exist "C:\Qt\%%i\mingw_64\bin\qmake.exe" (
            set "PATH=C:\Qt\%%i\mingw_64\bin;%PATH%"
            set "QT_PLUGIN_PATH=C:\Qt\%%i\mingw_64\plugins"
            set QT_FOUND=1
            goto :qt_found
        )
    )
)

REM Check for Qt in user directory
if exist "%USERPROFILE%\Qt" (
    for /f "delims=" %%i in ('dir /b /ad /o-n "%USERPROFILE%\Qt" 2^>nul') do (
        if exist "%USERPROFILE%\Qt\%%i\msvc2019_64\bin\qmake.exe" (
            set "PATH=%USERPROFILE%\Qt\%%i\msvc2019_64\bin;%PATH%"
            set "QT_PLUGIN_PATH=%USERPROFILE%\Qt\%%i\msvc2019_64\plugins"
            set QT_FOUND=1
            goto :qt_found
        )
        if exist "%USERPROFILE%\Qt\%%i\mingw_64\bin\qmake.exe" (
            set "PATH=%USERPROFILE%\Qt\%%i\mingw_64\bin;%PATH%"
            set "QT_PLUGIN_PATH=%USERPROFILE%\Qt\%%i\mingw_64\plugins"
            set QT_FOUND=1
            goto :qt_found
        )
    )
)

:qt_found

REM Start the application
if exist "qModMaster.exe" (
    echo Starting qModMaster.exe...
    start "" "qModMaster.exe"
) else if exist "qModMaster\qModMaster.exe" (
    echo Starting qModMaster\qModMaster.exe...
    start "" "qModMaster\qModMaster.exe"
) else (
    echo Error: qModMaster.exe not found!
    echo Please build the project first using: qmake ^&^& nmake
    pause
    exit /b 1
)

echo qModMaster started successfully!
timeout /t 2 >nul


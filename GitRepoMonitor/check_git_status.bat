@echo off
setlocal enabledelayedexpansion

:: Validate arguments
if "%~1"=="" (
    echo Please provide a directory path.
    exit /b 1
)
if "%~2"=="" (
    echo Please specify one of "local", "unpulled", or "unpushed".
    exit /b 1
)

:: Set the working directory to the repository path
cd /d %1 2>nul
if errorlevel 1 (
    echo Invalid directory path.
    exit /b 1
)

:: Initialize status variables
set LOCAL_CHANGES=0
set UNPUSHED_COMMITS=0
set UNPULLED_COMMITS=0

:: Check for local changes (modified files)
git diff --quiet
if errorlevel 1 (
    for /f %%A in ('git status --short ^| find /c /v ""') do set LOCAL_CHANGES=%%A
)

:: Check for unpushed commits
for /f %%A in ('git log origin/master..HEAD --oneline ^| find /c /v ""') do set UNPUSHED_COMMITS=%%A

:: Check for unpulled commits
git fetch >nul 2>&1
for /f %%A in ('git log HEAD..origin/master --oneline ^| find /c /v ""') do set UNPULLED_COMMITS=%%A

:: Output the requested status
if "%~2"=="local" (
    echo !LOCAL_CHANGES!
    exit /b 0
)
if "%~2"=="unpushed" (
    echo !UNPUSHED_COMMITS!
    exit /b 0
)
if "%~2"=="unpulled" (
    echo !UNPULLED_COMMITS!
    exit /b 0
)

:: Invalid return type
echo Invalid return type. Use "local", "unpushed", or "unpulled".
exit /b 1

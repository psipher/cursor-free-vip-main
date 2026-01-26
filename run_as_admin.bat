@echo off
REM Cursor Free VIP - Admin Launcher
REM This batch file helps run the application with administrator privileges

echo.
echo ================================================================
echo                    CURSOR FREE VIP - ADMIN LAUNCHER
echo ================================================================
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Administrator privileges required
    echo.
    echo Please run this batch file as Administrator:
    echo   1. Right-click on 'run_as_admin.bat'
    echo   2. Select 'Run as administrator'
    echo   3. Click 'Yes' when prompted by UAC
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

echo [OK] Running with Administrator privileges
echo.

REM Change to script directory
cd /d "%~dp0"

REM Check if Python environment exists
if not exist ".\myenv\Scripts\python.exe" (
    echo [!] Python virtual environment not found!
    echo.
    echo Expected path: .\myenv\Scripts\python.exe
    echo.
    echo Please create the virtual environment first or check your installation.
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

echo Starting Cursor Free VIP...
echo.

REM Run the application
.\myenv\Scripts\python.exe main.py

if %errorLevel% neq 0 (
    echo.
    echo [!] Application exited with error code %errorLevel%
) else (
    echo.
    echo Application exited successfully.
)

echo.
echo Press any key to exit...
pause >nul
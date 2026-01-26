@echo off
REM Cursor Free VIP - Admin Launcher
REM This batch file helps run the application with administrator privileges

echo.
echo ================================================================
echo                    CURSOR FREE VIP - ADMIN LAUNCHER
echo ================================================================
echo.
echo This application requires Administrator privileges to function properly.
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Running with Administrator privileges
    echo.
    echo Starting Cursor Free VIP...
    echo.
    
    REM Change to script directory
    cd /d "%~dp0"
    
    REM Run the application
    .\myenv\Scripts\python.exe main.py
    
    echo.
    echo Application has exited.
    pause
) else (
    echo [!] Administrator privileges required
    echo.
    echo Please run this batch file as Administrator:
    echo   1. Right-click on 'run_as_admin.bat'
    echo   2. Select 'Run as administrator'
    echo   3. Click 'Yes' when prompted by UAC
    echo.
    echo Alternatively, use PowerShell as Administrator:
    echo   1. Right-click Start button
    echo   2. Select 'Terminal (Admin)' or 'PowerShell (Admin)'
    echo   3. Navigate to: cd "%~dp0"
    echo   4. Run: .\myenv\Scripts\python.exe main.py
    echo.
    pause
)
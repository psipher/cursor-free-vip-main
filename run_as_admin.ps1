# Cursor Free VIP - Admin Launcher (PowerShell)
# This script helps run the application with administrator privileges

param(
    [switch]$Force
)

# Function to check if running as administrator
function Test-Administrator {
    if ($PSVersionTable.Platform -eq "Unix") {
        return $true  # Skip admin check on Unix systems
    }
    
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to restart as administrator
function Start-AsAdmin {
    $scriptPath = $MyInvocation.MyCommand.Path
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`" -Force"
    
    try {
        Start-Process powershell -Verb RunAs -ArgumentList $arguments
        exit
    }
    catch {
        Write-Host "Failed to restart as administrator: $_" -ForegroundColor Red
        return $false
    }
}

# Main script
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "                CURSOR FREE VIP - ADMIN LAUNCHER" -ForegroundColor Cyan  
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# Check if on Windows and if administrator privileges are required
if ($PSVersionTable.Platform -ne "Unix") {
    if (-not (Test-Administrator)) {
        if (-not $Force) {
            Write-Host "[!] Administrator privileges required" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "This application requires Administrator privileges to function properly." -ForegroundColor White
            Write-Host ""
            Write-Host "Options:" -ForegroundColor Cyan
            Write-Host "  1. Allow this script to restart as Administrator (Recommended)" -ForegroundColor White
            Write-Host "  2. Manually run PowerShell as Administrator" -ForegroundColor White
            Write-Host ""
            
            $choice = Read-Host "Would you like to restart as Administrator? (Y/n)"
            if ($choice -eq "" -or $choice -eq "Y" -or $choice -eq "y") {
                Write-Host "Restarting as Administrator..." -ForegroundColor Green
                Start-AsAdmin
                return
            }
            else {
                Write-Host ""
                Write-Host "Please manually run PowerShell as Administrator:" -ForegroundColor Yellow
                Write-Host "  1. Right-click Start button" -ForegroundColor White
                Write-Host "  2. Select 'Terminal (Admin)' or 'PowerShell (Admin)'" -ForegroundColor White
                Write-Host "  3. Navigate to: cd `"$PWD`"" -ForegroundColor White
                Write-Host "  4. Run: .\myenv\Scripts\python.exe main.py" -ForegroundColor White
                Write-Host ""
                Read-Host "Press Enter to exit"
                exit 1
            }
        }
        else {
            Write-Host "[!] Still not running as Administrator after restart attempt" -ForegroundColor Red
            Write-Host "Please manually run PowerShell as Administrator and try again." -ForegroundColor Yellow
            Read-Host "Press Enter to exit"
            exit 1
        }
    }
}

Write-Host "[OK] Running with appropriate privileges" -ForegroundColor Green
Write-Host ""
Write-Host "Starting Cursor Free VIP..." -ForegroundColor Cyan
Write-Host ""

# Change to script directory
Set-Location $PSScriptRoot

# Check if virtual environment exists
if (-not (Test-Path ".\myenv\Scripts\python.exe")) {
    Write-Host "[!] Virtual environment not found at .\myenv\Scripts\python.exe" -ForegroundColor Red
    Write-Host "Please ensure the virtual environment is set up correctly." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Run the application
try {
    & ".\myenv\Scripts\python.exe" "main.py"
    $exitCode = $LASTEXITCODE
    
    Write-Host ""
    if ($exitCode -eq 0) {
        Write-Host "Application completed successfully." -ForegroundColor Green
    }
    else {
        Write-Host "Application exited with code: $exitCode" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "Error running application: $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit"
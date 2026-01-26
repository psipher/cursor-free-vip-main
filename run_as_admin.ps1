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

# Main script execution
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "                CURSOR FREE VIP - ADMIN LAUNCHER" -ForegroundColor Cyan  
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# Check environment first
$scriptDir = $PSScriptRoot
if (-not $scriptDir) { $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path }
Set-Location $scriptDir

# Check Python environment
if (-not (Test-Path ".\myenv\Scripts\python.exe")) {
    Write-Host "[!] Virtual environment not found!" -ForegroundColor Red
    Write-Host "Expected path: $scriptDir\myenv\Scripts\python.exe" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please create the virtual environment first." -ForegroundColor White
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

if ($PSVersionTable.Platform -ne "Unix") {
    if (-not (Test-Administrator)) {
        Write-Host "[*] Current process is NOT elevated." -ForegroundColor Yellow
        
        # If Force was passed, it means we already tried to elevate and failed/were rejected
        if ($Force) {
            Write-Host "[!] Failed to acquire Administrator privileges." -ForegroundColor Red
            Write-Host "    This could be due to UAC settings or user rejection." -ForegroundColor Yellow
            Write-Host ""
            Write-Host "Please manually run PowerShell as Administrator:" -ForegroundColor White
            Write-Host "  1. Right-click Start button -> Terminal (Admin)" -ForegroundColor White
            Write-Host "  2. cd `"$scriptDir`"" -ForegroundColor White
            Write-Host "  3. .\myenv\Scripts\python.exe main.py" -ForegroundColor White
            Write-Host ""
            Read-Host "Press Enter to exit"
            exit 1
        }

        Write-Host "This application requires Administrator privileges." -ForegroundColor White
        Write-Host "Attempting to restart with Administrator privileges..." -ForegroundColor Cyan
        Write-Host ""
        
        $choice = Read-Host "Proceed? (Y/n)"
        if ($choice -eq "" -or $choice -eq "Y" -or $choice -eq "y") {
            try {
                # Use Start-Process with verb RunAs to elevate
                $newArgs = "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`" -Force"
                Start-Process powershell.exe -Verb RunAs -ArgumentList $newArgs -WorkingDirectory $scriptDir
                exit # Exit this non-elevated instance
            }
            catch {
                Write-Host "[!] Error attempting to elevate: $_" -ForegroundColor Red
                Read-Host "Press Enter to exit"
                exit 1
            }
        } else {
            Write-Host "Cancelled by user." -ForegroundColor Yellow
            exit
        }
    }
}

Write-Host "[OK] Running with Administrator privileges" -ForegroundColor Green
Write-Host ""
Write-Host "Starting Cursor Free VIP..." -ForegroundColor Cyan
Write-Host ""

try {
    & ".\myenv\Scripts\python.exe" "main.py"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[!] Application exited with code: $LASTEXITCODE" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "[!] Error executing application: $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit"
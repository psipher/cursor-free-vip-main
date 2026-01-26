# Create Desktop Shortcut for Cursor Free VIP
# Run this script to create a desktop shortcut that automatically runs as Administrator

$currentPath = Get-Location
$shortcutPath = [Environment]::GetFolderPath("Desktop") + "\Cursor Free VIP (Admin).lnk"
$targetPath = "$currentPath\run_as_admin.ps1"

# Create WScript.Shell object
$shell = New-Object -ComObject WScript.Shell

# Create shortcut
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$targetPath`""
$shortcut.WorkingDirectory = $currentPath
$shortcut.Description = "Cursor Free VIP - Run as Administrator"
$shortcut.IconLocation = "powershell.exe,0"

# Save shortcut
$shortcut.Save()

Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "            DESKTOP SHORTCUT CREATED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "A desktop shortcut has been created: " -NoNewline -ForegroundColor White
Write-Host "Cursor Free VIP (Admin)" -ForegroundColor Yellow
Write-Host ""
Write-Host "You can now double-click the shortcut to run the application with" -ForegroundColor White
Write-Host "administrator privileges automatically." -ForegroundColor White
Write-Host ""
Write-Host "Shortcut location: " -NoNewline -ForegroundColor Cyan
Write-Host "$shortcutPath" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter to continue"
# Maakt een snelkoppeling "Whisper Transcriber" op het bureaublad die start.bat opstart.
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktop "Whisper Transcriber.lnk"

$WshShell = New-Object -ComObject WScript.Shell
$shortcut = $WshShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = Join-Path $here "start.bat"
$shortcut.WorkingDirectory = $here
$shortcut.WindowStyle = 1
$shortcut.IconLocation = "shell32.dll,138"
$shortcut.Description = "Start Whisper Transcriber"
$shortcut.Save()

Write-Host "Snelkoppeling aangemaakt op het bureaublad: $shortcutPath"

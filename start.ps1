# This script behave like a tray utility without a tray utility (exit)
# Run novnc proxy in background mode
Add-Type -AssemblyName System.Windows.Forms

# Get the path of the current script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Define the path to the executable and its arguments
$executable = "C:\Program Files\Git\bin\bash.exe"
$arguments = "-c 'cd `"$scriptDir`" && ./novnc/utils/novnc_proxy'"

# Create a hidden process
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $executable
$psi.Arguments = $arguments
$psi.WindowStyle = "Hidden"

# Start the process
$process = [System.Diagnostics.Process]::Start($psi)

# Create a NotifyIcon object
$notifyIcon = New-Object System.Windows.Forms.NotifyIcon

# Set the icon for the tray icon
$iconPath = Join-Path $scriptDir "icon.ico"
$notifyIcon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($iconPath)

# Set the tooltip text for the tray icon
$notifyIcon.Text = "Process Running"

# Show the tray icon
$notifyIcon.Visible = $true

# Add a context menu to the tray icon
$contextMenu = New-Object System.Windows.Forms.ContextMenuStrip
$menuItem = New-Object System.Windows.Forms.ToolStripMenuItem
$menuItem.Text = "Exit"
$menuItem.Add_Click({
    # Terminate the process when the menu item is clicked
    Write-Host "Trying to exit..."
    if (-not $process.HasExited) {
        Write-Host "Process is still running. Attempting to kill..."
        $process.Kill()
        Write-Host "Process killed."
    } else {
        Write-Host "Process has already exited."
    }
    $notifyIcon.Dispose()
    Exit
})
$contextMenu.Items.Add($menuItem)
$notifyIcon.ContextMenuStrip = $contextMenu

# Add an event handler to ensure the process is killed if the script is terminated
$eventHandler = {
    if (-not $process.HasExited) {
        $process.Kill()
    }
    $notifyIcon.Dispose()
    Exit
}
Register-ObjectEvent -InputObject $notifyIcon -EventName "MouseClick" -Action $eventHandler
Exit
# Keep the script running
try {
    while ($true) {
        Start-Sleep -Seconds 10
    }
} finally {
    # Clean up when the script exits
    $notifyIcon.Dispose()
}

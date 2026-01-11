# Read configuration from environment variables (with defaults)
$frequency = if ($env:BEEP_FREQUENCY) { [int]$env:BEEP_FREQUENCY } else { 440 }
$duration = if ($env:BEEP_DURATION) { [int]$env:BEEP_DURATION } else { 150 }
$allowedTypes = $env:BEEP_NOTIFICATION_TYPES  # Empty means all types

# Read notification data from stdin
$inputJson = [Console]::In.ReadToEnd()
$notification = $null
if ($inputJson) {
    try {
        $notification = $inputJson | ConvertFrom-Json
    } catch {
        # If JSON parsing fails, continue anyway
    }
}

# Check if this notification type should trigger a beep
$shouldBeep = $true
if ($allowedTypes -and $notification.notification_type) {
    $typeList = $allowedTypes -split '\|'
    if ($notification.notification_type -notin $typeList) {
        $shouldBeep = $false
    }
}

if (-not $shouldBeep) {
    exit 0
}

# Check if terminal is focused
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint processId);
}
"@

$fgWnd = [Win32]::GetForegroundWindow()
$procId = 0
[Win32]::GetWindowThreadProcessId($fgWnd, [ref]$procId) | Out-Null
$fgProc = Get-Process -Id $procId -ErrorAction SilentlyContinue

if ($fgProc.ProcessName -ne 'WindowsTerminal') {
    [Console]::Beep($frequency, $duration)
}

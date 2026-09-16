Add-Type -AssemblyName UIAutomationClient, UIAutomationTypes
$src = @'
using System;
using System.Runtime.InteropServices;
public class WinMove {
  [DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
  [DllImport("user32.dll")] public static extern bool SetCursorPos(int X, int Y);
  [DllImport("user32.dll")] public static extern void mouse_event(uint dwFlags, uint dx, uint dy, uint dwData, IntPtr dwExtraInfo);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
}
'@
Add-Type -TypeDefinition $src

$deadline = (Get-Date).AddSeconds(240)
while ((Get-Date) -lt $deadline) {
    $proc = Get-Process 1cv8t -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -eq $proc) { Start-Sleep -Seconds 2; continue }
    $root = [System.Windows.Automation.AutomationElement]::FromHandle($proc.MainWindowHandle)
    $all = $root.FindAll([System.Windows.Automation.TreeScope]::Descendants,
        [System.Windows.Automation.PropertyCondition]::TrueCondition)
    $dlg = $null; $btn = $null
    foreach ($el in $all) {
        if ($el.Current.ControlType.ProgrammaticName -eq 'ControlType.Window' -and $el.Current.Name -match 'Предприятие') { $dlg = $el }
        if ($el.Current.ControlType.ProgrammaticName -eq 'ControlType.Button' -and $el.Current.Name -match 'Да') { $btn = $el }
    }
    if ($null -ne $dlg -and $null -ne $btn) {
        $hwnd = [IntPtr]$dlg.Current.NativeWindowHandle
        Write-Host "moving window hwnd=$hwnd"
        [WinMove]::SetWindowPos($hwnd, [IntPtr]::Zero, 0, 0, 1280, 700, 0x0040) | Out-Null
        [WinMove]::ShowWindow($hwnd, 5) | Out-Null
        [WinMove]::SetForegroundWindow($hwnd) | Out-Null
        Start-Sleep -Seconds 2
        $r = $btn.Current.BoundingRectangle
        Write-Host "button rect now: $([int]$r.X),$([int]$r.Y) $([int]$r.Width)x$([int]$r.Height)"
        $cx = [int]($r.X + $r.Width / 2)
        $cy = [int]($r.Y + $r.Height / 2)
        if ($cx -ge 0 -and $cx -lt 1280 -and $cy -ge 0 -and $cy -lt 720) {
            [WinMove]::SetCursorPos($cx, $cy) | Out-Null
            Start-Sleep -Milliseconds 400
            [WinMove]::mouse_event(0x0002, 0, 0, 0, [IntPtr]::Zero)
            Start-Sleep -Milliseconds 120
            [WinMove]::mouse_event(0x0004, 0, 0, 0, [IntPtr]::Zero)
            Write-Host "clicked at $cx,$cy"
            Start-Sleep -Seconds 3
        } else {
            Write-Host "button still off-screen ($cx,$cy)"
        }
    } else {
        Start-Sleep -Seconds 2
        continue
    }
    Start-Sleep -Seconds 2
    $check = Get-Process 1cv8t -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $check) {
        $root2 = [System.Windows.Automation.AutomationElement]::FromHandle($check.MainWindowHandle)
        $all2 = $root2.FindAll([System.Windows.Automation.TreeScope]::Descendants,
            [System.Windows.Automation.PropertyCondition]::TrueCondition)
        $still = $false
        foreach ($el in $all2) {
            if ($el.Current.ControlType.ProgrammaticName -eq 'ControlType.Button' -and $el.Current.Name -match 'Да') { $still = $true }
        }
        if (-not $still) { Write-Host "dialog gone"; exit 0 }
    }
}
Write-Host "timeout"
exit 1

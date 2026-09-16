Add-Type -AssemblyName UIAutomationClient, UIAutomationTypes
$src = @'
using System;
using System.Runtime.InteropServices;
public class MouseOps {
  [DllImport("user32.dll")] public static extern bool SetCursorPos(int X, int Y);
  [DllImport("user32.dll")] public static extern void mouse_event(uint dwFlags, uint dx, uint dy, uint dwData, IntPtr dwExtraInfo);
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
  public const uint LEFTDOWN = 0x0002;
  public const uint LEFTUP = 0x0004;
}
'@
Add-Type -TypeDefinition $src
$deadline = (Get-Date).AddSeconds(60)
$done = $false
while ((Get-Date) -lt $deadline -and -not $done) {
    $procs = Get-Process 1cv8t -ErrorAction SilentlyContinue
    foreach ($proc in $procs) {
        $root = [System.Windows.Automation.AutomationElement]::FromHandle($proc.MainWindowHandle)
        if ($null -eq $root) { continue }
        $all = $root.FindAll([System.Windows.Automation.TreeScope]::Descendants,
            [System.Windows.Automation.PropertyCondition]::TrueCondition)
        foreach ($el in $all) {
            if ($el.Current.ControlType.ProgrammaticName -eq 'ControlType.Button' -and $el.Current.Name -match 'Открыть|Да') {
                $r = $el.Current.BoundingRectangle
                Write-Host "button '$($el.Current.Name)' at $([int]$r.X),$([int]$r.Y) $($r.Width)x$($r.Height)"
                $cx = [int]($r.X + $r.Width / 2)
                $cy = [int]($r.Y + $r.Height / 2)
                [MouseOps]::SetCursorPos($cx, $cy) | Out-Null
                Start-Sleep -Milliseconds 300
                [MouseOps]::mouse_event([MouseOps]::LEFTDOWN, 0, 0, 0, [IntPtr]::Zero)
                Start-Sleep -Milliseconds 100
                [MouseOps]::mouse_event([MouseOps]::LEFTUP, 0, 0, 0, [IntPtr]::Zero)
                Write-Host "clicked at $cx,$cy"
                $done = $true
                break
            }
        }
        if ($done) { break }
    }
    if (-not $done) { Start-Sleep -Seconds 2 }
}
if (-not $done) { Write-Host "button not found" }

Add-Type -AssemblyName UIAutomationClient, UIAutomationTypes
$src = @'
using System;
using System.Runtime.InteropServices;
public class MouseOps4 {
  [DllImport("user32.dll")] public static extern bool SetCursorPos(int X, int Y);
  [DllImport("user32.dll")] public static extern void mouse_event(uint dwFlags, uint dx, uint dy, uint dwData, IntPtr dwExtraInfo);
}
'@
Add-Type -TypeDefinition $src

function Find-OpenButton {
    $procs = Get-Process 1cv8t -ErrorAction SilentlyContinue
    foreach ($proc in $procs) {
        $root = [System.Windows.Automation.AutomationElement]::FromHandle($proc.MainWindowHandle)
        if ($null -eq $root) { continue }
        $all = $root.FindAll([System.Windows.Automation.TreeScope]::Descendants,
            [System.Windows.Automation.PropertyCondition]::TrueCondition)
        foreach ($el in $all) {
            if ($el.Current.ControlType.ProgrammaticName -eq 'ControlType.Button' -and $el.Current.Name -match 'Да') {
                return $el
            }
        }
    }
    return $null
}

$deadline = (Get-Date).AddSeconds(280)
while ((Get-Date) -lt $deadline) {
    $btn = Find-OpenButton
    if ($null -eq $btn) {
        Start-Sleep -Seconds 2
        continue
    }
    Write-Host "dialog found, trying Invoke"
    try {
        $ip = $btn.GetCurrentPattern([System.Windows.Automation.InvokePattern]::Pattern)
        if ($null -ne $ip) { $ip.Invoke() }
    } catch { Write-Host "invoke failed: $_" }
    Start-Sleep -Seconds 3
    $btn2 = Find-OpenButton
    if ($null -eq $btn2) {
        Write-Host "dialog gone after Invoke"
        exit 0
    }
    $r = $btn2.Current.BoundingRectangle
    $cx = [int]($r.X + $r.Width / 2)
    $cy = [int]($r.Y + $r.Height / 2)
    Write-Host "physical click at $cx,$cy"
    [MouseOps4]::SetCursorPos($cx, $cy) | Out-Null
    Start-Sleep -Milliseconds 300
    [MouseOps4]::mouse_event(0x0002, 0, 0, 0, [IntPtr]::Zero)
    Start-Sleep -Milliseconds 120
    [MouseOps4]::mouse_event(0x0004, 0, 0, 0, [IntPtr]::Zero)
    Start-Sleep -Seconds 3
    if ($null -eq (Find-OpenButton)) {
        Write-Host "dialog gone after physical click"
        exit 0
    }
}
Write-Host "timeout"
exit 1

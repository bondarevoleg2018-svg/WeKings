Add-Type -AssemblyName UIAutomationClient, UIAutomationTypes
$src = @'
using System;
using System.Text;
using System.Runtime.InteropServices;
public class WinMsg {
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumWindowsProc cb, IntPtr l);
  public delegate bool EnumWindowsProc(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint p);
  [DllImport("user32.dll")] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
  [DllImport("user32.dll")] public static extern IntPtr PostMessage(IntPtr h, uint msg, IntPtr w, IntPtr l);
  public struct RECT { public int Left, Top, Right, Bottom; }
  public const uint WM_LBUTTONDOWN = 0x0201;
  public const uint WM_LBUTTONUP = 0x0202;
  public static IntPtr FindConfirmation(uint pid) {
    IntPtr found = IntPtr.Zero;
    EnumWindows(delegate(IntPtr h, IntPtr l) {
      uint p; GetWindowThreadProcessId(h, out p);
      if (p == pid) {
        StringBuilder c = new StringBuilder(256); GetClassName(h, c, 256);
        if (c.ToString() == "V8ConfirmationWindowTaxi") found = h;
      }
      return true;
    }, IntPtr.Zero);
    return found;
  }
  public static IntPtr MakeL(int x, int y) { return (IntPtr)((y << 16) | (x & 0xFFFF)); }
}
'@
Add-Type -TypeDefinition $src
$proc = Get-Process 1cv8t -ErrorAction SilentlyContinue | Select-Object -First 1
if ($null -eq $proc) { Write-Host "no 1cv8t"; exit 1 }
$hwnd = [WinMsg]::FindConfirmation($proc.Id)
Write-Host "confirmation hwnd: $hwnd"
if ($hwnd -eq [IntPtr]::Zero) { exit 1 }
$rect = New-Object WinMsg+RECT
[WinMsg]::GetWindowRect($hwnd, [ref]$rect) | Out-Null
Write-Host "dialog rect: $($rect.Left),$($rect.Top) - $($rect.Right),$($rect.Bottom)"
$root = [System.Windows.Automation.AutomationElement]::FromHandle($proc.MainWindowHandle)
$all = $root.FindAll([System.Windows.Automation.TreeScope]::Descendants, [System.Windows.Automation.PropertyCondition]::TrueCondition)
foreach ($el in $all) {
    if ($el.Current.ControlType.ProgrammaticName -eq 'ControlType.Button' -and $el.Current.Name -match 'Открыть|Да') {
        $r = $el.Current.BoundingRectangle
        $sx = [int]($r.X + $r.Width / 2)
        $sy = [int]($r.Y + $r.Height / 2)
        $lx = $sx - $rect.Left
        $ly = $sy - $rect.Top
        Write-Host "posting click at rel $lx,$ly (abs $sx,$sy)"
        [WinMsg]::PostMessage($hwnd, [WinMsg]::WM_LBUTTONDOWN, (New-Object IntPtr 1), [WinMsg]::MakeL($lx, $ly)) | Out-Null
        Start-Sleep -Milliseconds 150
        [WinMsg]::PostMessage($hwnd, [WinMsg]::WM_LBUTTONUP, [IntPtr]::Zero, [WinMsg]::MakeL($lx, $ly)) | Out-Null
        Write-Host "posted"
    }
}

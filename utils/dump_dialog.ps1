Add-Type -AssemblyName UIAutomationClient, UIAutomationTypes
$out = New-Object System.IO.StreamWriter("C:\Bases\dialog_text.txt", $false, (New-Object System.Text.UTF8Encoding $true))
$proc = Get-Process 1cv8t -ErrorAction SilentlyContinue | Select-Object -First 1
if ($null -eq $proc) { $out.WriteLine("no process"); $out.Close(); exit }
$root = [System.Windows.Automation.AutomationElement]::FromHandle($proc.MainWindowHandle)
$all = $root.FindAll([System.Windows.Automation.TreeScope]::Descendants, [System.Windows.Automation.PropertyCondition]::TrueCondition)
foreach ($el in $all) {
    $ct = $el.Current.ControlType.ProgrammaticName
    if ($ct -in @('ControlType.Window','ControlType.Text','ControlType.Button')) {
        $out.WriteLine($ct + " | " + $el.Current.Name)
    }
}
$out.Close()

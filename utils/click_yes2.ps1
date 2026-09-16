Add-Type -AssemblyName UIAutomationClient, UIAutomationTypes
$yesPattern = [string]([char]0x0414) + [string]([char]0x0430)
$procs = Get-Process 1cv8t -ErrorAction SilentlyContinue
foreach ($proc in $procs) {
    if ($proc.MainWindowHandle -eq 0) { continue }
    try {
        $root = [System.Windows.Automation.AutomationElement]::FromHandle($proc.MainWindowHandle)
    } catch { continue }
    if ($null -eq $root) { continue }
    $all = $root.FindAll([System.Windows.Automation.TreeScope]::Descendants,
        [System.Windows.Automation.PropertyCondition]::TrueCondition)
    foreach ($el in $all) {
        if ($el.Current.ControlType.ProgrammaticName -eq 'ControlType.Button' `
            -and $el.Current.Name -match $yesPattern) {
            try {
                $ip = $el.GetCurrentPattern([System.Windows.Automation.InvokePattern]::Pattern)
                $ip.Invoke()
                Write-Host "INVOKED yes"
            } catch { Write-Host "invoke failed: $($_.Exception.Message)" }
        }
    }
}

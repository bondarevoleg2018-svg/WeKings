Add-Type -AssemblyName UIAutomationClient, UIAutomationTypes
$yesPattern = [string]([char]0x0414) + [string]([char]0x0430)
$deadline = (Get-Date).AddMinutes(10)
$clicked = 0
while ((Get-Date) -lt $deadline) {
    $procs = Get-Process 1cv8t -ErrorAction SilentlyContinue
    if ($null -eq $procs -and $clicked -gt 0) { Write-Host "process gone, clicks=$clicked"; break }
    foreach ($proc in $procs) {
        if ($proc.MainWindowHandle -eq 0) { continue }
        try {
            $root = [System.Windows.Automation.AutomationElement]::FromHandle($proc.MainWindowHandle)
        } catch { continue }
        if ($null -eq $root) { continue }
        try {
            $all = $root.FindAll([System.Windows.Automation.TreeScope]::Descendants,
                [System.Windows.Automation.PropertyCondition]::TrueCondition)
        } catch { continue }
        foreach ($el in $all) {
            if ($el.Current.ControlType.ProgrammaticName -eq 'ControlType.Button' `
                -and $el.Current.Name -match $yesPattern) {
                try {
                    $ip = $el.GetCurrentPattern([System.Windows.Automation.InvokePattern]::Pattern)
                    $ip.Invoke()
                    $clicked++
                    Write-Host "INVOKED yes ($clicked)"
                } catch { Write-Host "invoke failed: $($_.Exception.Message)" }
            }
        }
    }
    Start-Sleep -Seconds 2
}
Write-Host "watcher done, clicks=$clicked"

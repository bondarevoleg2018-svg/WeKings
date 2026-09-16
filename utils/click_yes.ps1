Add-Type -AssemblyName UIAutomationClient, UIAutomationTypes
$deadline = (Get-Date).AddSeconds(120)
$done = $false
while ((Get-Date) -lt $deadline -and -not $done) {
    $procs = Get-Process 1cv8t -ErrorAction SilentlyContinue
    foreach ($proc in $procs) {
        try {
            $root = [System.Windows.Automation.AutomationElement]::FromHandle($proc.MainWindowHandle)
        } catch { continue }
        if ($null -eq $root) { continue }
        $all = $root.FindAll([System.Windows.Automation.TreeScope]::Descendants,
            [System.Windows.Automation.PropertyCondition]::TrueCondition)
        foreach ($el in $all) {
            if ($el.Current.ControlType.ProgrammaticName -eq 'ControlType.Button' `
                -and $el.Current.Name -match 'Да') {
                try {
                    $ip = $el.GetCurrentPattern([System.Windows.Automation.InvokePattern]::Pattern)
                    $ip.Invoke()
                    Write-Host "invoked '$($el.Current.Name)'"
                    $done = $true
                } catch {
                    Write-Host "invoke failed: $($_.Exception.Message)"
                }
                break
            }
        }
        if ($done) { break }
    }
    if (-not $done) { Start-Sleep -Seconds 2 }
}
if (-not $done) { Write-Host "button not found" }

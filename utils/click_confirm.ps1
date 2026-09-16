Add-Type -AssemblyName UIAutomationClient, UIAutomationTypes
$deadline = (Get-Date).AddSeconds(300)
$clicked = $false
while ((Get-Date) -lt $deadline -and -not $clicked) {
    $procs = Get-Process 1cv8t -ErrorAction SilentlyContinue
    foreach ($proc in $procs) {
        $root = [System.Windows.Automation.AutomationElement]::FromHandle($proc.MainWindowHandle)
        if ($null -eq $root) { continue }
        $all = $root.FindAll([System.Windows.Automation.TreeScope]::Descendants,
            [System.Windows.Automation.PropertyCondition]::TrueCondition)
        foreach ($el in $all) {
            if ($el.Current.ControlType.ProgrammaticName -eq 'ControlType.Text' -and $el.Current.Name -match 'безопасности') {
                $walker = [System.Windows.Automation.TreeWalker]::ControlViewWalker
                $parent = $walker.GetParent($el)
                while ($null -ne $parent -and $parent.Current.ControlType.ProgrammaticName -ne 'ControlType.Window') {
                    $parent = $walker.GetParent($parent)
                }
                if ($null -eq $parent) { continue }
                $buttons = $parent.FindAll([System.Windows.Automation.TreeScope]::Descendants,
                    (New-Object System.Windows.Automation.PropertyCondition([System.Windows.Automation.AutomationElement]::ControlTypeProperty, [System.Windows.Automation.ControlType]::Button)))
                foreach ($btn in $buttons) {
                    if ($btn.Current.Name -match 'Открыть|Да') {
                        $ip = $btn.GetCurrentPattern([System.Windows.Automation.InvokePattern]::Pattern)
                        if ($null -ne $ip) {
                            $ip.Invoke()
                            Write-Host "CLICKED: $($btn.Current.Name)"
                            $clicked = $true
                            break
                        }
                    }
                }
                if (-not $clicked -and $buttons.Count -ge 1) {
                    $ip = $buttons[0].GetCurrentPattern([System.Windows.Automation.InvokePattern]::Pattern)
                    if ($null -ne $ip) {
                        $ip.Invoke()
                        Write-Host "CLICKED first button: $($buttons[0].Current.Name)"
                        $clicked = $true
                    }
                }
            }
            if ($clicked) { break }
        }
        if ($clicked) { break }
    }
    if (-not $clicked) { Start-Sleep -Seconds 2 }
}
if (-not $clicked) { Write-Host "NOT FOUND - timeout" }

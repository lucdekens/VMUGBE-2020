#region Code example
$code = {
  Get-VMHost | Get-VMHostService | Where-Object {-not $_.Running} | Out-Null
}
#endregion

#region Measure-Command
Measure-Command -Expression $code
#endregion

#region Stopwatch
$chrono = [System.Diagnostics.Stopwatch]::StartNew()
Invoke-Command -ScriptBlock $code
$chrono.Stop()
$chrono.Elapsed
#endregion

#region [DateTime]
$start = Get-Date
Invoke-Command -ScriptBlock $code
$finish = Get-Date
New-TimeSpan -Start $start -End $finish
#endregion

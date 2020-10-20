#region Code example
$code = {
  Get-VMHost | Get-VMHostService | Where-Object { -not $_.Running } | Out-Null
}
#endregion

#region Get one value
Measure-Command -Expression $code |
Select-Object -ExpandProperty TotalMilliseconds

$chrono = [System.Diagnostics.Stopwatch]::StartNew()
Invoke-Command -ScriptBlock $code
$chrono.Stop()
$chrono.Elapsed.TotalMilliseconds

$start = Get-Date
Invoke-Command -ScriptBlock $code
$finish = Get-Date
New-TimeSpan -Start $start -End $finish |
Select-Object -ExpandProperty TotalMilliseconds
#endregion
$stat = 'cpu.usage.average', 'mem.usage.average'
$start = (Get-Date).AddHours(-1)
$fileName = $fileName = "$(Split-Path -parent $PSCommandPath)\stats-report.xlsx"

$sStat = @{
  Entity = Get-VM -Name DC*, WS*
  Stat = $stat
  Realtime = $true
  MaxSamples = 10
  ErrorAction = 'SilentlyContinue'
}
$sExcel = @{
  Path = $fileName
  WorksheetName = 'Report2'
  AutoSize = $true
  AutoFilter = $true
  FreezeTopRow = $true
  BoldTopRow = $true
  Show = $true
}
Get-Stat @sStat |
Group-Object -Property {$_.Entity.Name} |
ForEach-Object -Process {
  $_.Group |
  Select-Object -Property Timestamp, Entity, MetricId, Value
} |
Sort-Object -Property Timestamp, Entity |
Export-Excel @sExcel

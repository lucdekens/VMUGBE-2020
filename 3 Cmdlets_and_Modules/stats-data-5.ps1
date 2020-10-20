$stat = 'cpu.usage.average'
$start = (Get-Date).AddHours(-1)
$fileName = $fileName = "$(Split-Path -parent $PSCommandPath)\stats-report.xlsx"

$sStat = @{
  Entity = Get-VM -Name DC*, WS*
  Stat = $stat
  Realtime = $true
  MaxSamples = 10
  ErrorAction = 'SilentlyContinue'
}
$c1 = @{
  Range = 'D2:D1048576'
  ConditionalType = 'GreaterThan'
  Text = 15
  ConditionalTextColor = 'yellow'
  BackgroundColor = 'black'
}
$c2 = @{
  Range = 'D2:D1048576'
  ConditionalType = 'GreaterThan'
  Text = 30
  ConditionalTextColor = 'red'
  BackgroundColor = 'black'
}

$sExcel = @{
  Path = $fileName
  WorksheetName = 'Report3'
  AutoSize = $true
  AutoFilter = $true
  FreezeTopRow = $true
  BoldTopRow = $true
  ConditionalText = @(
    New-ConditionalText @c2
    New-ConditionalText @c1
  )
  ClearSheet = $true
  Show = $true
}
Get-Stat @sStat |
Group-Object -Property { $_.Entity.Name } |
ForEach-Object -Process {
  $_.Group |
  Select-Object -Property Timestamp, Entity, MetricId, Value
} |
Sort-Object -Property Timestamp, Entity |
Export-Excel @sExcel

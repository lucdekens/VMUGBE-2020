$stat = 'cpu.usage.average','mem.usage.average'
$fileName = "$(Split-Path -parent $PSCommandPath)\stats-report.xlsx"

Get-VM -Name DC*, WS* |
Get-Stat -Stat $stat -Realtime -MaxSamples 10 -ErrorAction SilentlyContinue |
Select-Object -Property Timestamp, Entity, MetricId, Value |
Sort-Object -Property Timestamp, Entity |
Export-Excel -Path $fileName -WorksheetName 'Report1' -AutoSize -AutoFilter -TitleBold -FreezeTopRow -Show

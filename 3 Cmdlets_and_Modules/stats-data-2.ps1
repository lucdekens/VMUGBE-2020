$stat = 'cpu.usage.average','mem.usage.average'
$fileName = '.\stats-report.csv'

Get-VM -Name DC*,WS* |
Get-Stat -Stat $stat -RealTime -MaxSamples 10  -ErrorAction SilentlyContinue |
Select-Object -Property Timestamp,Entity,MetricId,Value |
Sort-Object -Property Timestamp,Entity |
Export-Csv -Path $fileName -NoTypeInformation -UseCulture

Invoke-Item -Path $fileName

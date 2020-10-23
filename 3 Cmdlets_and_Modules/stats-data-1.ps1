$stat = 'cpu.usage.average','mem.usage.average'
$start = (Get-Date).AddDays(-1)
$fileName = '.\stats-report.csv'

Get-VM |
Get-Stat -Stat $stat -Start $start -ErrorAction SilentlyContinue |
Export-Csv -Path $fileName -NoTypeInformation -UseCulture

Invoke-Item -Path $fileName

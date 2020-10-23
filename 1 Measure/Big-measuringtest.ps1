#region Test Settings
$fileName = '.\measure-big-report.xlsx'
$runs = 10,50,100
$runsPerMethod = 10

if($PSVersionTable.PSVersion.Major -eq 5){
  $wsName = "MethodCompare-PS$($PSVersionTable.PSVersion.ToString(2))"
}
else{
  $wsName = "MethodCompare-PS$($PSVersionTable.PSVersion.ToString())"
}
#Remove-Item $fileName -ErrorAction SilentlyContinue
#endregion

#region Sample Code
$code = {
  Get-VMHost | Get-VMHostService | Where-Object { -not $_.Running } | Out-Null
}
#endregion

#region The Test
  #region Test Setup
$runs | ForEach-Object -Process {
  $nrRuns = $_
  $tableName = "Run$($PSVersionTable.PSVersion.Major)$($nrRuns)Table"

  Write-Host "$(Get-Date -Format HH:mm:ss.fff) Number of Runs $($nrRuns) X $($runsPerMethod)" -ForegroundColor Green
  #endregion

  #region Excel
  $sChart = @{
    Title = "$nrRuns Samples"
    XAxisTitleText = "Run"
    ChartType = 'Line'
    SeriesHeader = 'MeasureCommand', 'DateTime', 'StopWatch'
    YRange = "$tableName[MeasureCommand]", "$tableName[DateTime]", "$tableName[StopWatch]"
  }
  $chart = New-ExcelChartDefinition @sChart

  $sStyle1 = @{
    NumberFormat = 'Number'
    BorderAround = 'Medium'
  }
  $style1 = New-ExcelStyle @sStyle1
  $sExcel = @{
    Path = $fileName
    ClearSheet = $true
    WorksheetName = "$wsName-$nrRuns"
    TableName = $tableName
    ExcelChartDefinition = $chart
    BoldTopRow = $true
    AutoSize = $true
    FreezeTopRow = $true
    Style = $style1
  }
  #endregion

  #region Test Runs
  1..$nrRuns | ForEach-Object -Process {
    New-Object -TypeName PSObject -Property (
      [ordered]@{
        MeasureCommand = 1..$runsPerMethod | ForEach-Object -Process {
          Measure-Command -Expression $code |
          Select-Object -ExpandProperty TotalMilliseconds
        } | Measure-Object -Average | Select-Object -ExpandProperty Average
        DateTime = 1..$runsPerMethod | ForEach-Object -Process {
          $start = Get-Date
          Invoke-Command -ScriptBlock $code
          $finish = Get-Date
          New-TimeSpan -Start $start -End $finish |
          Select-Object -ExpandProperty TotalMilliseconds
        } | Measure-Object -Average | Select-Object -ExpandProperty Average
        StopWatch = 1..$runsPerMethod | ForEach-Object -Process {
          $chrono = [System.Diagnostics.Stopwatch]::StartNew()
          Invoke-Command -ScriptBlock $code
          $chrono.Stop()
          $chrono.Elapsed.TotalMilliseconds
        } | Measure-Object -Average | Select-Object -ExpandProperty Average
      }
    )
  } | Export-Excel @sExcel
  #endregion
#endregion

#region The (pretty) report
  $sStyle2 = @{
    NumberFormat = 'Number'
    BorderAround = 'Medium'
    BackgroundColor = 'PeachPuff'
    Range = 'G21:J25'
  }
  $style2 = New-ExcelStyle @sStyle2

  $sExcelStats = @{
    Path = $fileName
    WorksheetName = "$wsName-$nrRuns"
    TableName = "$($tableName)Stats"
    StartRow = 20
    StartColumn = 7
    BoldTopRow = $true
    AutoSize = $true
    Style = $style2
  }

  $(
    New-PSItem 'Average' "=AVERAGE(A2:A$($nrRuns + 1))" "=AVERAGE(B2:B$($nrRuns + 1))" "=AVERAGE(C2:C$($nrRuns + 1))" @('Statistic', 'MeasureCommand', 'DateTime', 'StopWatch')
    New-PSItem 'StdDev' "=STDEV(A2:A$($nrRuns + 1))" "=STDEV(B2:B$($nrRuns + 1))" "=STDEV(C2:C$($nrRuns + 1))"
    New-PSItem 'TrimMean' "=TRIMMEAN(A2:A$($nrRuns + 1),0.2)" "=TRIMMEAN(B2:B$($nrRuns + 1),0.2)" "=TRIMMEAN(C2:C$($nrRuns + 1),0.2)"
    New-PSItem '80Percentile' "=PERCENTILE(A2:A$($nrRuns + 1),0.8)" "=PERCENTILE(B2:B$($nrRuns + 1),0.8)" "=PERCENTILE(C2:C$($nrRuns + 1),0.8)"
    New-PSItem '90Percentile' "=PERCENTILE(A2:A$($nrRuns + 1),0.9)" "=PERCENTILE(B2:B$($nrRuns + 1),0.9)" "=PERCENTILE(C2:C$($nrRuns + 1),0.9)"
  ) | Export-Excel @sExcelStats
}
#endregion

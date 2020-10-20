Get-Cluster |
Get-VMHost -PipelineVariable esx |
ForEach-Object -Process {
  $esxcli = Get-EsxCli -VMHost $esx -V2
  $esxcli.storage.core.path.list.Invoke() |
  Where-Object{$_.Transport -eq 'iscsi'} |
  ForEach-Object -Process {
    #Write-Host "On $($esx.Name) - HBA $($_.Adapter) - LUN $($_.Device) - Path $($_.RuntimeName) is $($_.State)"
  }
}
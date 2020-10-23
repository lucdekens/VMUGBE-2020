$cluster = Get-Cluster
foreach($esx in Get-VMHost -Location $cluster){
  $service = Get-VMHostService -VMHost $esx | Where-Object { -not $_.Running }
  Write-Host "$($service.Count) services not running on $($esx.Name)"
}

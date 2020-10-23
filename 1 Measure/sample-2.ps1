$cluster = Get-Cluster
foreach ($esx in Get-VMHost -Location $cluster)
{
  $hbas = Get-VMHostHba -VMHost $esx -Type IScsi
  foreach($hba in $hbas){
  $luns = Get-ScsiLun -Hba $hba -LunType disk
  foreach($lun in $luns){
    $paths = Get-ScsiLunPath -ScsiLun $lun
    foreach($path in $paths){
      #Write-Host "$($esx.Name) -HBA $($hba.Name) - LUN $($lun.CanonicalName) - Path $($path.Name) is $($path.State)"
    }
  }
}
}

Get-Datacenter -PipelineVariable dc |
Get-Cluster -PipelineVariable cluster |
Get-VMHost -PipelineVariable esx |
Get-VM |
Select-Object @{N='Datacenter';E={$dc.Name}},
  @{N='Cluster';E={$cluster.Name}},
  @{N='VMHost';E={$esx.Name}},
  @{N='VM';E={$_.Name}}
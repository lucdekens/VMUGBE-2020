Get-View -ViewType Datacenter -PipelineVariable dc |
ForEach-Object -Process {
  Get-View -ViewType ClusterComputeResource -SearchRoot $dc.MoRef -PipelineVariable cluster |
  ForEach-Object -Process {
    Get-View -ViewType HostSystem -SearchRoot $cluster.MoRef -PipelineVariable esx |
    ForEach-Object -Process {
      Get-View -ViewType VirtualMachine -SearchRoot $_.MoRef |
      Select-Object @{N='Datacenter';E={$dc.Name}},
        @{N='Cluster';E={$cluster.Name}},
        @{N='VMHost';E={$esx.Name}},
        @{N='VM';E={$_.Name}}
    }
  }
}

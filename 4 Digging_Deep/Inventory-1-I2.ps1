Get-View -ViewType Datacenter -Property Name -PipelineVariable dc |
ForEach-Object -Process {
  Get-View -ViewType ClusterComputeResource -Property Name -SearchRoot $dc.MoRef -PipelineVariable cluster |
  ForEach-Object -Process {
    Get-View -ViewType HostSystem -Property Name -SearchRoot $cluster.MoRef -PipelineVariable esx |
    ForEach-Object -Process {
      Get-View -ViewType VirtualMachine -Property Name -SearchRoot $_.MoRef |
      Select-Object @{N = 'Datacenter'; E = { $dc.Name } },
      @{N = 'Cluster'; E = { $cluster.Name } },
      @{N = 'VMHost'; E = { $esx.Name } },
      @{N = 'VM'; E = { $_.Name } }
    }
  }
}

Get-Tag -PipelineVariable tag |
ForEach-Object -Process {
  if(-not (
    Get-TagAssignment |
    Where-Object{$_.Tag.Name -eq $tag.Name})){
    "$($tag.Category.Name)/$($tag.Name)"
  }
} | Sort-Object
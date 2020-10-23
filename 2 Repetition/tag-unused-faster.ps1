$tab = @{}

# Collect all tags
Get-Tag |
ForEach-Object -Process {
    if(-not $tab.ContainsKey($_.Name)){
        $tab.Add($_.Name,$_.Category)
    }
}

# Remove tags that are used
Get-TagAssignment | Group-Object -Property {$_.Tag.Name} |
ForEach-Object -Process {
    $tab.Remove($_.Name)
}

# List unused tags
$tab.GetEnumerator() | ForEach-Object -Process {
    "$($_.Value)/$($_.Name)"
} | Sort-Object

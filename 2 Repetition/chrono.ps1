$path = Split-Path -parent $PSCommandPath
$file = 'tag-unused-faster.ps1'
$Chronometer = @{
  Path = "$($path)\$($file)"
  Script = { . "$($path)\$($file)" }
}
Get-Chronometer @Chronometer | Format-Chronometer

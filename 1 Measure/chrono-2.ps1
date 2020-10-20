$path = Split-Path -parent $PSCommandPath
$file = 'sample-2-faster.ps1'
$Chronometer = @{
  Path = "$($path)\$($file)"
  Script = { . "$($path)\$($file)" }
}
Get-Chronometer @Chronometer | Format-Chronometer

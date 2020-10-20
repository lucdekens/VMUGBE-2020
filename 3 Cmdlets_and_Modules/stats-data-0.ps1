Get-VM -Name DC*,WS* |
Get-Stat -Stat 'cpu.usage.average', 'mem.usage.average' -Realtime -MaxSamples 10
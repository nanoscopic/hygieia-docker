#$start_time = Get-Date

Import-Module BitsTransfer
Start-BitsTransfer -Source $args[0] -Destination ( $PSScriptRoot + '\' + $args[1] )

#Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
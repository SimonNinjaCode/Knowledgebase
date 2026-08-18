<# 
.DESCRIPTION
PIN as Bitlocker-protector in TPM
#>

$BitlockerStatus = (Get-BitLockerVolume -MountPoint $env:SystemDrive).KeyProtector | Where-Object { $_.KeyProtectorType -eq 'TpmPin' }
$hash = @{KeyProtectorType = $BitlockerStatus.KeyProtectorType}
return $hash | ConvertTo-Json -Compress
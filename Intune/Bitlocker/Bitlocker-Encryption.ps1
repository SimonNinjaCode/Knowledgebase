$BitlockerVolume = Get-BitLockerVolume | select encryptionmethod,mountpoint,VolumeType,ProtectionStatus |? { $_.VolumeType -eq "OperatingSystem" -and $_.ProtectionStatus -eq "On" }

switch ($BitlockerVolume.encryptionmethod) {
Aes128 { $true }
Aes256 { $true }
Aes128Diffuser { $true }
Aes256Diffuser { $true }
XtsAes128 { $true }
XtsAes256 { $true }
Default { $false }
}
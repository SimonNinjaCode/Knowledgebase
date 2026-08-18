$pin = (Get-BitLockerVolume -MountPoint $env:SystemDrive).KeyProtector  | Where-Object { $_.KeyProtectorType -eq 'TpmPin' }

if (((Get-BitLockerVolume -MountPoint $env:SystemDrive).VolumeStatus) -ne "FullyDecrypted")
    {
    Write-Output "Encryption enabled!"
    if ($null -ne $pin)
        {
            Write-Output "TPM PIN is set!"
            Exit 0
        }
    else
        {
            Write-Output "TPM PIN is not set!"
            Exit 1
        }

    }
else
    {
        Write-Output "Encryption has not yet started.."
        Exit 0
    }
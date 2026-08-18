<# 
.DESCRIPTION
Detects compliance settings for secured core
https://docs.microsoft.com/en-us/windows-hardware/design/device-experiences/oem-highly-secure
#>

$OS = Get-CimInstance Win32_OperatingSystem
$ComputerSystem = Get-CimInstance Win32_ComputerSystem
$BIOS = Get-CimInstance Win32_BIOS 
$TPMStatus = Get-Tpm
$TPMVersion = Get-CimInstance Win32_Tpm -namespace root\CIMV2\Security\MicrosoftTpm
$UEFIStatus = Confirm-SecureBootUEFI
$DGConfigured = Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard | Select-Object SecurityServicesConfigured
$DGRunning = Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard | Select-Object SecurityServicesRunning

$hash = @{`
    ModelName = $ComputerSystem.Model;` 
    BiosVersion = $BIOS.SMBIOSBIOSVersion;` 
    TPMChipPresent = $TPM.TPMPresent;`
    TPMVersion = $TPMVersion.SpecVersion;` 
    UEFISecureBOOT = $UEFIStatus;`
    DeviceGuardConfigured = $DGConfigured;`
    DeviceGuardRunning = $DGRunning;
}
return $hash | ConvertTo-Json -Compress
$wmi = Get-WMIObject -Namespace root/cimv2/mdm/dmmap -Class MDM_DevDetail_Ext01
$wmi.DeviceHardwareData
#$wmi.DeviceHardwareData | Out-File “$($env:COMPUTERNAME).txt”
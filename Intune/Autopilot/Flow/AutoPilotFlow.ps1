Param (
  [Parameter(Mandatory = $False, Position = 1, HelpMessage = "Please enter your email address")]
  [ValidateNotNullorEmpty()]
  [string]$Mail,
  [Parameter(Mandatory = $False, Position = 3, HelpMessage = "Please enter assigned users UPN")]
  [string]$UPN
)
$Mail = "Simon@Evergr33n.onmicrosoft.com"
$groupTag = "SE"
$Serial = (Get-WmiObject  -Class Win32_BIOS).SerialNumber
$DeviceHardwareData = (Get-WMIObject -Namespace root/cimv2/mdm/dmmap -Class MDM_DevDetail_Ext01 -Filter "InstanceID='Ext' AND ParentID='./DevDetail'").DeviceHardwareData
$body = @"
{
 "groupTag": "$groupTag",
 "serialNumber": "$($Serial)",
 "hardwareIdentifier": "$($DeviceHardwareData)",
 "EmailAddress": "$Mail",
 "assignedUserPrincipalName": "$($UPN)"
}
"@

#Change this to your Flow HTTP request url
$Url = "https://prod-112.westeurope.logic.azure.com:443/workflows/2e3c17e7bce04b8d978ce401efe8537f/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=3Y9WxT4rc_lU-dPteG0bNTiVlTckal5dnx2Up2Z4Neo"
try
{
  #Make REST API call to flow
  Invoke-RestMethod -uri $Url -Method Post -body $Body -ContentType 'application/json'
  Write-Output "Mail: $Mail" 
  Write-Output "Group Tag: $groupTag"
  Write-Output "Serial: $Serial"
  Write-Output "Please wait for email confirmation for approval to continue install this device..."
}
catch
{
  Write-Error "$_.Exception.Message"
}
 
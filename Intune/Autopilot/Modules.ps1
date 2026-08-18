Install-Module AzureAD -force
Install-Module Microsoft.Graph.Intune -force
Install-Module WindowsAutopilotIntune -force

#https://www.powershellgallery.com/packages/AutopilotHealthCheck/1.0
Install-Script AutopilotHealthCheck 
AutopilotHealthCheck.ps1

#https://www.powershellgallery.com/packages/Convert-WindowsAutopilotProfile/1.0
Install-Script -Name Convert-WindowsAutopilotProfile 
Convert-WindowsAutopilotProfile.ps1 -file "C:\Temp\AP.json" -verbose


Connect-AutoPilotIntune
Get-Command -module WindowsAutoPilotIntune
Get-AutoPilotDevice | where-object "enrollmentstate" -ne "notcontacted"
Get-autopilotdevice | Select-Object deploymentprofileassignmentstatus, serialnumber, enrollmentstate, lastcontacteddatetime, userprincipalname | ft
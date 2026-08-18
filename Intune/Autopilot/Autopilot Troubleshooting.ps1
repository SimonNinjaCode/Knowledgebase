# Remote
Connect-AutoPilotIntune

Get-Command -Module WindowsAutoPilotIntune
Get-AutoPilotDevice | Where-Object "enrollmentstate" -ne "notcontacted"
Get-autopilotdevice | Select-Object deploymentprofileassignmentstatus, serialnumber, enrollmentstate, lastcontacteddatetime, userprincipalname | sort "enrollmentstate" | ft

Get-AutoPilotImportedDevice
Get-AutopilotProfile

# Local
Shift+F10
MDMdiagnosticstool.exe -area Autopilot -cab C:\Temp\autopilot.cab 
MDMdiagnosticstool.exe -area Deviceenrollment -cab C:\Temp\deviceenrollment.cab 

#Post-Autopilot/ESP
Set-ExecutionPolicy bypass
Install-Script -Name Get-AutopilotDiagnostics -Scope AllUsers -Force -Verbose
Get-AutopilotDiagnostics
Powershell.exe
Set-ExecutionPolicy Bypass -force -verbose 
Install-Module WindowsAutoPilotIntune -force -verbose
Import-Module WindowsAutoPilotIntune -force -verbose
Install-Script -Name "Get-WindowsAutopilotInfo" -force -verbose

Connect-MSgraph

Get-WindowsAutoPilotInfo.ps1 -Online -Grouptag ""

Set-ExecutionPolicy Restricted -force -verbose 
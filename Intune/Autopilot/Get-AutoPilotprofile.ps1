# JSON fetch using Powershell
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module AzureAD -Force
Install-Module Microsoft.Graph.Intune -Force
Install-Module WindowsAutopilotIntune -Force -allowclobber

Import-Module AzureAD
Import-Module Microsoft.Graph.Intune
Import-Module WindowsAutopilotIntune
Connect-MSGraph

$AutopilotProfile = Get-AutopilotProfile | Where Displayname -eq "..."
$AutopilotProfile | ConvertTo-AutopilotConfigurationJSON | Set-Content -Encoding Ascii "C:\Temp\AutopilotConfigurationFile.json"

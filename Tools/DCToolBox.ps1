Get-Module -Name DCToolbox -Verbose
Install-Module -Name DCToolBox -Force -verbose
Import-Module DCToolbox -Verbose
Update-Module DCToolbox -Verbose

Get-DCHelp

Connect-DCMsGraphAsUser -Scopes 'Policy.ReadWrite.ConditionalAccess', 'Policy.Read.All', 'Directory.Read.All' -Verbose

Deploy-DCConditionalAccessBaselinePoC -CreateDocumentation

# Invoke-DCConditionalAccessGallery
## Install Sharepoint Powershell and connect to a tenant
Install-Module -Name Microsoft.Online.SharePoint.PowerShell
Update-Module -Name Microsoft.Online.SharePoint.PowerShell
Connect-SPOService -Url https://contoso-admin.sharepoint.com -Credential admin@contoso.com

## Check status of AIP Integration and B2B Integrations
Get-SPOTenant | Select-Object EnableAIPIntegration, EnableAzureADB2BIntegration

## Enable AIP Integration
Set-SPOTenant -EnableAIPIntegration $true

## Enable AAD B2B Integration
Set-SPOTenant -EnableAzureADB2BIntegration $true 
Set-SPOTenant -SyncAadB2BManagementPolicy $true 

https://d   ocs.microsoft.com/en-us/sharepoint/sharepoint-azureb2b-integration
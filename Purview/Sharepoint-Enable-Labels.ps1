# Install the required module
Install-Module Microsoft.Online.SharePoint.PowerShell -force -verbose

# Import the required module
Import-Module Microsoft.Online.SharePoint.PowerShell -verbose

# Connect to SharePoint Online. This will prompt you to sign in.
$URL = "https://evergr33ndev-admin.sharepoint.com" # replace with your SharePoint admin URL
$UPN = "tool@evergr33ndev.onmicrosoft.com"
Connect-SPOService -Url $URL 

# Enable AIP Integration
Set-SPOTenant -EnableAIPIntegration $true
(Get-SPOTenant).EnableAIPIntegration
 
# Enable support for PDFs. Update SP Online Module if this fails. The link is https://www.microsoft.com/en-us/download/details.aspx?id=35588
Set-SPOTenant -EnableSensitivityLabelforPDF $true
(Get-SPOTenant).EnableSensitivityLabelforPDF
 
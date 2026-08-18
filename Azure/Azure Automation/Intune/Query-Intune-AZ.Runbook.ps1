$CSV = ".\Intune-Devices-Report.csv"

# Import the module
#Write-Host 'Installing...'
#Install-Module Microsoft.Graph.Intune -Force -AcceptLicense

# Log into test tenant
Write-Host 'Logging in...'
$creds = Get-AutomationPSCredential -Name 'IntuneAutomation' # To create credentials in Azure Automation: https://docs.microsoft.com/en-us/azure/automation/shared-resources/credentials#creating-a-new-credential-asset
Connect-MSGraph -PSCredential $creds

# Run a simple cmdlet (no network traffic)
Write-Host 'Get current MSGraph environment parameters'
Get-MSGraphEnvironment

# Make a call to Microsoft Graph using the cmdlets
Write-Host "List all Intune Devices"
$IntuneDevices = (Get-IntuneManagedDevice)
$IntuneDevices | Where-Object `
{$_.devicestate -notlike 'Wipe pending'} | Where-object `
{$_.operatingsystem -notlike $null} `
| Select-Object `
@{Name="UPN";Expression={$_.userprincipalname}},`
@{Name="Device Name";Expression={$_.devicename}},`
@{Name="Model";Expression={$_.model}},`
@{Name="Manufacturer";Expression={$_.manufacturer}},`
@{Name="Serial Number";Expression={$_.serialnumber}},`
@{Name="OS";Expression={$_.operatingsystem}},`
@{Name="OS Version";Expression={$_.osversion}},`
@{Name="Managed Device Name";Expression={$_.manageddevicename}},`
@{Name="Phone Number";Expression={$_.phonenumber}},`
@{Name="Enrollment Date";Expression={$_.enrolledDateTime}},`
@{Name="Last Sync";Expression={$_.lastsyncdatetime}},`
@{Name="MDM-Agent";Expression={$_.managementagent}}`
| Export-csv -path $CSV -Encoding UTF8 -NoTypeInformation

$attachment = Get-Item -Path $CSV
$encoding = [System.Text.Encoding]::UTF8
$Mail = "simon@evergr33n.onmicrosoft.com"
$From = "simon@evergr33n.onmicrosoft.com"
$Subject = "Intune-Devices-Report"
$Smtpserver = "smtp.office365.com"
$Port = "587"

#Params for Send-Mail
$params = @{
Encoding = $encoding
To = "$Mail"
From = "$From"
Body = "$IntuneDevices"
Subject = "$Subject"
BODYasHTML = $true
Smtpserver = "$Smtpserver"
Port = "$Port"
Attachments = $attachment.FullName
}

#Authentication and PSSession
$cred = Get-AutomationPSCredential -Name "O365Credential"

Send-MailMessage @params -UseSsl -Credential $cred
$ExportExcel = ".\Customer_Intune-Devices-$(Get-date -Format "yyyy-MM-dd").xlsx"

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

$IntuneDevices = @()
$DataSet = New-Object System.Data.DataSet
$IntuneDevices += $DataSet.Tables[0]
$IntuneDevices = (Get-IntuneManagedDevice)
#$OSGroup = ($IntuneDevices.operatingSystem | group -NoElement)
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
@{Name="MDM-Agent";Expression={$_.managementagent}} `
|export-excel "$ExportExcel" -WorkSheetname "Customer_Intune" -PivotTableDefinition @{ 
    "OS" = @{"SourceWorkSheet" = "Customer_Intune" ; 
    "PivotRows" = "OS" ; 
    "PivotData" = @{"OS"="count"} ; 
    "IncludePivotChart" = $true ; 
    "ChartType" = "Pie3D"; 
 } 
}

$attachment = Get-Item -Path $ExportExcel
$encoding = [System.Text.Encoding]::UTF8
$Mail = "simon@evergr33n.onmicrosoft.com"
$From = "RFC8314@evergr33n.onmicrosoft.com"
$Subject = "Intune-Devices-Export-Excel"
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
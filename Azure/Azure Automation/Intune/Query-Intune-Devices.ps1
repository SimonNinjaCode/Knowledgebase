Install-Module -Name Microsoft.Graph.Intune
Connect-MSGraph

#Get Managed Devices
Get-IntuneManagedDevice | `
Where-Object {$_.operatingsystem -eq 'ios'} | `
Select-Object userprincipalname, managementagent, devicename, model, manufacturer, serialnumber, operatingsystem, osVersion, manageddevicename, phonenumber, enrollmentdatetime, lastsyncdatetime | `
Sort-Object userprincipalname | `
Out-GridView

#Convert to array/Data
$Data = @()
$DataSet = New-Object System.Data.DataSet
$Data += $DataSet.Tables[0]
$Data = (Get-IntuneManagedDevice)
$Data | Where-Object `
{$_.devicename-notlike '??????'} `
`
| Select-Object `
userprincipalname, `
managementagent, `
devicename, `
model, `
manufacturer, `
serialnumber, `
operatingsystem, `
osVersion, `
manageddevicename, `
phonenumber, `
enrolleddatetime, `
lastsyncdatetime `
| Out-GridView
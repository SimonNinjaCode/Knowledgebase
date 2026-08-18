# Connect to Azure AD
Import-Module AzureAD

# Variables
$TenantID = "evergr33ndev.onmicrosoft.com"
$PrincipalID = "7824b1f7-f380-420f-919a-faf89b20027b"

# Add permissions
$Permissions = @(
    'DeviceManagementManagedDevices.Read.All'
    'Device.Read.All'
    'DeviceManagementServiceConfig.Read.All'
    'Directory.Read.All'
    'DeviceManagementConfiguration.Read.All'
    'DeviceManagementRBAC.Read.All'
    'DeviceManagementApps.Read.All'
)

Connect-AzureAD -TenantId $TenantID
$GraphServicePrincipal = Get-AzureADServicePrincipal -SearchString "Microsoft Graph" | Select-Object -first 1
$AppRole = $GraphServicePrincipal.AppRoles | Where-Object { $Permissions -contains $_.Value -and $_.AllowedMemberTypes -contains "Application" }
foreach ($Role in $AppRole) {
    New-AzureAdServiceAppRoleAssignment -ObjectId $PrincipalID -PrincipalId $PrincipalID -ResourceId $GraphServicePrincipal.ObjectId -Id $Role.Id
}

# Get permissions
$SP = (Get-AzureADServicePrincipal -ObjectId $PrincipalID).ObjectID
Get-AzureADServiceAppRoleAssignment -ObjectId $SP -All $True
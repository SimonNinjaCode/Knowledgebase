# Connect to Azure AD
Import-Module AzureAD

# Variables
$TenantID = "evergr33ndev.onmicrosoft.com"
$PrincipalID = "c99df263-8f2a-4c88-9e59-0a3f11dea50c"

# Add permissions
$Permissions = @(
    "Device.Read.All", 
    "DeviceManagementManagedDevices.Read.All", 
    "Group.Read.All", 
    "GroupMember.ReadWrite.All",
    "User.Read.All"
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
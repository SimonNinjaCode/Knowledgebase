# Managed Identity ID
$PrincipalID = "c99df263-8f2a-4c88-9e59-0a3f11dea50c"

# Pre-Requisites
$AzAccountsModule = Get-Module -Name Az.Accounts -ListAvailable
if ($AzAccountsModule -eq $null) {
    Write-Output "Az Accounts module is not installed. Installing..."
    Install-Module -Name Az.Accounts -Force -Verbose
    Write-Output "Az Accounts module installed successfully."
}
else {
    Write-Output "Az Accounts module is already installed."
}

$AzResourcesModule = Get-Module -Name Az.Resources -ListAvailable
if ($AzResourcesModule -eq $null) {
    Write-Output "Az Resources module is not installed. Installing..."
    Install-Module -Name Az.Resources -Force -Verbose
    Write-Output "Az Resources module installed successfully."
}
else {
    Write-Output "Az Resources module is already installed."
}

# Connect AzAccount
Connect-AzAccount

# Add Graph Permissions
$GraphPermissions = `
    "Device.Read.All", `
    "DeviceManagementManagedDevices.Read.All", `
    "GroupMember.ReadWrite.All", `
    "User.Read.All", `
    "Group.Read.All", `
    "DeviceManagementRBAC.ReadWrite.All"

$CurrentPermissions = Get-AzADServicePrincipalAppRoleAssignment -ServicePrincipalId $PrincipalID
$GraphServicePrincipal = Get-AzADServicePrincipal -SearchString "Microsoft Graph" | Select-Object -first 1
$GraphAppRoles = $GraphServicePrincipal.AppRole | Where-Object { $GraphPermissions -contains $_.Value -and $_.AllowedMemberType -contains "Application" }
foreach ($Role in $GraphAppRoles) {
    if ($CurrentPermissions.AppRoleId -notcontains $Role.Id) {
        try {
            New-AzADServicePrincipalAppRoleAssignment -ServicePrincipalId $PrincipalID -ResourceId $GraphServicePrincipal.Id -AppRoleId $Role.Id | Out-Null
            Write-Output "Assigned graph permission '$($Role.Value)' to service principal $($PrincipalID)"
        }
        catch {
            Write-Error "Failed to assign graph permission '$($Role.Value)' to service principal $($PrincipalID)"
        }
    }
    else {
        Write-Output "Graph permission '$($Role.Value)' is already assigned to service principal $($PrincipalID)"
    }
}
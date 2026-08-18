<#

.DESCRIPTION
This script will create the necessary resources for the DUDE application.

.PARAMETER SubscriptionId
The subscription id where the resources will be created.

.PARAMETER ResourceGroup
The resource group where the resources will be created. Default is 'RG-DUDE'.

.PARAMETER FunctionApp
The function app name. Default is 'DUDE-TenantName'.

.PARAMETER LogAnalyticsWorkspace
The log analytics workspace name. Default is 'LAW-DUDE'.

.PARAMETER AppServicePlan
The app service plan name. Default is 'ASP-DUDE'.

.PARAMETER AppServicePlanTier
The app service plan tier. Default is 'Standard'.

.PARAMETER Location
The location where the resources will be created.

.PARAMETER StorageAccount
The storage account name. Default is 'dudestorage'.

.PARAMETER ApplicationInsights
The application insights name. Default is 'AI-DUDE'.

.PARAMETER AzTable
The azure table name. Default is 'DUDE'.

.PARAMETER CreateGroupsPermission
Create groups permissions to the managed identity of the function app. This is only needed if you want to create groups in the tenant.

.PARAMETER CreateScopeTagsPermission
Create scope tags permissions to the managed identity of the function app. This is only needed if you want to create scope tags in the tenant.

.PARAMETER AddDefenderPermission
Add defender permissions to the managed identity of the function app. This is only needed if you want to tag devices in defender for endpoint.

.EXAMPLE
.\DUDE-PreReqs.ps1 -SubscriptionId 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' -Location 'West Europe'

.EXAMPLE
.\DUDE-PreReqs.ps1 -SubscriptionId 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' -ResourceGroup 'RG-DUDE' -FunctionApp 'DUDE-TenantName' -LogAnalyticsWorkspace 'LAW-DUDE' -AppServicePlan 'ASP-DUDE' -AppServicePlanTier 'Standard' -Location 'West Europe' -StorageAccount 'dudestorage' -ApplicationInsights 'AI-DUDE' -AzTable 'DUDE' -CreateGroupsPermission -CreateScopeTagsPermission -AddDefenderPermission

.NOTES
1.0 - 2024-02-10 - Initial version.

#>

#region Parameters
[cmdletbinding()]
param (
    [parameter(Mandatory = $true)]
    [string]$SubscriptionId,

    [parameter(Mandatory = $false)]
    [string]$ResourceGroup = 'RG-DUDE',

    [parameter(Mandatory = $false)]
    [string]$FunctionApp = 'DUDE-TenantName',

    [parameter(Mandatory = $false)]
    [string]$LogAnalyticsWorkspace = 'LAW-DUDE',

    [parameter(Mandatory = $false)]
    [string]$AppServicePlan = 'ASP-DUDE',

    [parameter(Mandatory = $false)]
    [string]$AppServicePlanTier = 'Standard',

    [parameter(Mandatory = $true)]
    [string]$Location,

    [parameter(Mandatory = $false)]
    [string]$StorageAccount = 'dudestorage',

    [parameter(Mandatory = $false)]
    [string]$ApplicationInsights = 'AI-DUDE',

    [parameter(Mandatory = $false)]
    [string]$AzTable = 'DUDE',

    [parameter(Mandatory = $false)]
    [Switch]$CreateGroupsPermission,

    [parameter(Mandatory = $false)]
    [Switch]$CreateScopeTagsPermission,

    [parameter(Mandatory = $false)]
    [Switch]$AddDefenderPermission
)
#endregion

#region Modules
$AzModule = Get-Module -Name Az -ListAvailable
if ($AzModule -eq $null) {
    Write-Output "Az module is not installed. Installing..."
    Install-Module -Name Az -Force
    Write-Output "Az module installed successfully."
}
else {
    Write-Output "Az module is already installed."
}
#endregion

#region Connect
try {
    Connect-AzAccount -Subscription $SubscriptionId | Out-Null
    Write-Output "Connected to tenant: $((Get-AzTenant).Name)"
}
catch {
    Write-Error "Could not connect to the tenant" -ErrorAction Stop
}
#endregion

#region Resource Group
if ((Get-AzResourceGroup -Name $ResourceGroup -ErrorAction SilentlyContinue).ResourceGroupName.Count -eq '1') {
    Write-Output "Using existing resource group: $($ResourceGroup)"
}
else {
    try {
        New-AzResourceGroup -Name $ResourceGroup -Location $Location | Out-Null
        Write-Output "Created resource group: $($ResourceGroup)"
    }
    catch {
        Write-Error "Could not create resource group: $($ResourceGroup)" -ErrorAction Stop
    }
}
#endregion

#region Log Analytics Workspace
if ((Get-AzOperationalInsightsWorkspace -ResourceGroupName $ResourceGroup -Name $LogAnalyticsWorkspace -ErrorAction SilentlyContinue).Name.Count -eq '1') {
    Write-Output "Using existing log analytics workspace: $($LogAnalyticsWorkspace)"
}
else {
    try {
        New-AzOperationalInsightsWorkspace -ResourceGroupName $ResourceGroup -Name $LogAnalyticsWorkspace -Location $Location | Out-Null
        Write-Output "Created log analytics workspace: $($LogAnalyticsWorkspace)"
    }
    catch {
        Write-Error "Could not create log analytics workspace: $($LogAnalyticsWorkspace)" -ErrorAction Stop
    }
}
try {
    $WorkspaceId = (Get-AzOperationalInsightsWorkspace -ResourceGroupName $ResourceGroup -Name $LogAnalyticsWorkspace).ResourceId
}
catch {
    Write-Error "Could not get the log analytics workspace resource id from: $($LogAnalyticsWorkspace)" -ErrorAction Stop
}
#endregion

#region Application Insight
if ((Get-AzApplicationInsights -ResourceGroupName $ResourceGroup -Name $ApplicationInsights -ErrorAction SilentlyContinue).Name.Count -eq '1') {
    Write-Output "Using existing application insights: $($ApplicationInsights)"
}
else {
    try {
        New-AzApplicationInsights -ResourceGroupName $ResourceGroup -Name $ApplicationInsights -Location $Location -Kind 'web' -ApplicationType 'web' -IngestionMode 'LogAnalytics' -WorkspaceResourceId $WorkspaceId | Out-Null
        Write-Output "Created application insights: $($ApplicationInsights)"
    }
    catch {
        Write-Error "Could not create application insights: $($ApplicationInsights)" -ErrorAction Stop
    }
}
#endregion

#region Storage Account
if ((Get-AzStorageAccount -ResourceGroupName $ResourceGroup -Name $StorageAccount -ErrorAction SilentlyContinue).StorageAccountName.Count -eq '1') {
    Write-Output "Using existing storage account: $($StorageAccount)"
}
else {
    try {
        New-AzStorageAccount -ResourceGroupName $ResourceGroup -Name $StorageAccount -Location $Location -Kind StorageV2 -SkuName Standard_LRS -AllowBlobPublicAccess $true -AllowCrossTenantReplication $false | Out-Null
        Write-Output "Created storage account: $($StorageAccount)"
    }
    catch {
        Write-Error "Could not create storage account: $($StorageAccount)" -ErrorAction Stop
    }
}
try {
    $StorageAccountInfo = Get-AzStorageAccount -Name $StorageAccount -ResourceGroupName $ResourceGroup
}
catch {
    Write-Error "Could not get storage account info: $($StorageAccount)" -ErrorAction Stop
}
#endregion

#region App Service Plan
if ((Get-AzAppServicePlan -ResourceGroupName $ResourceGroup -Name $AppServicePlan -ErrorAction SilentlyContinue).Name.Count -eq '1') {
    Write-Output "Using existing app service plan: $($AppServicePlan)"
}
else {
    try {
        New-AzAppServicePlan -ResourceGroupName $ResourceGroup -Name $AppServicePlan -Location $Location -Tier $AppServicePlanTier | Out-Null
        Write-Output "Created app service plan: $($AppServicePlan)"
    }
    catch {
        Write-Error "Could not app service plan: $($AppServicePlan)" -ErrorAction Stop
    }
}
#endregion

#region Function App
if ($FunctionApp -eq 'DUDE-TenantName') {
    $FunctionApp = 'DUDE-' + $(Get-AzTenant).Name
}
if ((Get-AzFunctionApp -ResourceGroupName $ResourceGroup -Name $FunctionApp -ErrorAction SilentlyContinue).Name.Count -eq '1') {
    Write-Output "Using existing function app: $($FunctionApp)"
}
else {
    try {
        New-AzFunctionApp -ResourceGroupName $ResourceGroup -Name $FunctionApp -FunctionsVersion 4 -Runtime PowerShell -RuntimeVersion 7.2 -OSType Windows -PlanName $AppServicePlan -StorageAccountName $StorageAccount -ApplicationInsightsName $ApplicationInsights -IdentityType SystemAssigned | Out-Null
        Write-Output "Created function app: $($FunctionApp)"
    }
    catch {
        Write-Error "Could not create function app: $($FunctionApp)" -ErrorAction Stop
    }
    try {
        Set-AzWebApp -ResourceGroupName $ResourceGroup -Name $FunctionApp -FtpsState Disabled | Out-Null
        Write-Output "Disabled ftpsstate on function app: $($FunctionApp)"
    }
    catch {
        Write-Error "Could not disable ftpsstate on function app: $($FunctionApp)" -ErrorAction Stop
    }
}
#endregion

#region Azure Table
if ((Get-AzStorageTable –Context $StorageAccountInfo.Context | Where-Object { $_.Name -eq $AzTable }).CloudTable.Count -eq '1') {
    Write-Output "Using existing azure table: $($AzTable)"
}
else {
    try {
        New-AzStorageTable -Context $StorageAccountInfo.Context -Name $AzTable | Out-Null
        Write-Output "Created azure table: $($AzTable)"
    }
    catch {
        Write-Error "Could not create azure table: $($AzTable)" -ErrorAction Stop
    }
}
try {
    $PrincipalId = (Get-AzWebApp -ResourceGroupName $ResourceGroup -Name $FunctionApp).Identity.PrincipalId
}
catch {
    Write-Error "Could not get the PrincipalId of the identity from function app: $($FunctionApp)"
}
if ((Get-AzRoleAssignment -ObjectId $PrincipalId -RoleDefinitionId 'c12c1c16-33a1-487b-954d-41c89c60f349' -Scope $StorageAccountInfo.Id -ErrorAction SilentlyContinue).DisplayName.Count -eq '1') {
    Write-Output "The 'Reader and Data Access' permissions are already assigned to the identity of function app: $($FunctionApp)"
}
else {
    try {
        New-AzRoleAssignment -ObjectId $PrincipalId -RoleDefinitionId 'c12c1c16-33a1-487b-954d-41c89c60f349' -Scope $StorageAccountInfo.Id | Out-Null
        Write-Output "Assigned 'Reader and Data Access' to the identity of function app: $($FunctionApp)"
    }
    catch {
        Write-Error "Could not assign 'Reader and Data Access' to the identity of function app: $($FunctionApp)"
    }
}
#endregion

#region Add permissions to the managed identity of the function app
$GraphPermissions = `
    "Device.Read.All", `
    "DeviceManagementManagedDevices.Read.All", `
    "GroupMember.ReadWrite.All", `
    "User.Read.All", `
    "AdministrativeUnit.ReadWrite.All"

if ($CreateGroupsPermission) {
    $GraphPermissions += "Group.ReadWrite.All"
}
else {
    $GraphPermissions += "Group.Read.All"
}

if ($CreateScopeTagsPermission) {
    $GraphPermissions += "DeviceManagementRBAC.ReadWrite.All"
}

if ($AddDefenderPermission) {
    $DefenderPermissions = `
        "Machine.ReadWrite.All"
}

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

if ($AddDefenderPermission) {
    $DefenderServicePrincipal = Get-AzADServicePrincipal -SearchString "WindowsDefenderATP" | Select-Object -first 1
    $DefenderAppRoles = $DefenderServicePrincipal.AppRole | Where-Object { $DefenderPermissions -contains $_.Value -and $_.AllowedMemberType -contains "Application" }
    foreach ($Role in $DefenderAppRoles) {
        if ($CurrentPermissions.AppRoleId -notcontains $Role.Id) {
            try {
                New-AzADServicePrincipalAppRoleAssignment -ServicePrincipalId $PrincipalID -ResourceId $DefenderServicePrincipal.Id -AppRoleId $Role.Id | Out-Null
                Write-Output "Assigned defender permission '$($Role.Value)' to service principal $($PrincipalID)"
            }
            catch {
                Write-Error "Failed to assign defender permission '$($Role.Value)' to service principal $($PrincipalID)"
            }
        }
        else {
            Write-Output "Defender permission '$($Role.Value)' is already assigned to service principal $($PrincipalID)"
        }
    }
}
#endregion
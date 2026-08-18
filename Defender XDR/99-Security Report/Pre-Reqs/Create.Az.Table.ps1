# Variables
$SubscriptionId = "39c4591e-44ce-40a5-b762-581e1d6b64c3"
$ResourceGroup = "Infrastructure-Security"
$StorageAccountName = "secreportstorageaccount1"
$AzTable = "mdetvm"
$PrincipalID = "d10dbd45-03b7-4e1f-9feb-72d85a39d3e7"
$RoleDefinitionID = "c12c1c16-33a1-487b-954d-41c89c60f349"

#region Modules (AzStorage, AzAccounts, AzResources)
$AzStorageModule = Get-Module -Name Az.Storage -ListAvailable
if ($null -eq $AzStorageModule) {
    Write-Output "Az Storage module is not installed. Installing..."
    Install-Module -Name Az.Storage -Force -Verbose
    Write-Output "Az Storage module installed successfully."
} else {
    Write-Output "Az Storage module is already installed."
}

$AzAccountsModule = Get-Module -Name Az.Accounts -ListAvailable
if ($null -eq $AzAccountsModule) {
    Write-Output "Az Accounts module is not installed. Installing..."
    Install-Module -Name Az.Accounts -Force -Verbose
    Write-Output "Az Accounts module installed successfully."
} else {
    Write-Output "Az Accounts module is already installed."
}

$AzResourcesModule = Get-Module -Name Az.Resources -ListAvailable
if ($null -eq $AzResourcesModule) {
    Write-Output "Az Resources module is not installed. Installing..."
    Install-Module -Name Az.Resources -Force -Verbose
    Write-Output "Az Resources module installed successfully."
} else {
    Write-Output "Az Resources module is already installed."
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

#region Storage Account
$StorageAccount = Get-AzStorageAccount -ResourceGroupName $ResourceGroup -Name $StorageAccountName -ErrorAction SilentlyContinue

if ($storageAccount) {
    Write-Output "Using existing storage account: $StorageAccountName"
} else {
    try {
        New-AzStorageAccount -ResourceGroupName $ResourceGroup -Name $StorageAccountName -Location $Location -Kind StorageV2 -SkuName Standard_LRS -AllowBlobPublicAccess $true -AllowCrossTenantReplication $false | Out-Null
        Write-Output "Created storage account: $($StorageAccount)"
    } catch {
        Write-Error "Could not create storage account: $($StorageAccount)" -ErrorAction Stop
    }
}

try {
    $StorageAccountInfo = Get-AzStorageAccount -Name $StorageAccountName -ResourceGroupName $ResourceGroup
    Write-Output "Storage Account Info:" $StorageAccountInfo
} catch {
    Write-Error "Could not get storage account info: $($StorageAccount)" -ErrorAction Stop
}
#endregion

#region Azure Table
Write-Output "AZ.Table Name: $AzTable"
Write-Output "Current Storage Account: $StorageAccountName"
Write-Output "Defining AZStorageTable..."
$azureTable = Get-AzStorageTable -Context $StorageAccountInfo.Context | Where-Object { $_.Name -eq $AzTable }

if ($azureTable) {
    Write-Output "Using existing azure table: $($AzTable)"
} else {
    try {
        New-AzStorageTable -Context $StorageAccountInfo.Context -Name $AzTable | Out-Null
        Write-Output "Created azure table: $($AzTable)"
    } catch {
        Write-Error "Could not create azure table: $($AzTable)" -ErrorAction Stop
    }
}
#endregion

# region Managed Identity Permissions
$roleAssignment = Get-AzRoleAssignment -ObjectId $PrincipalId -RoleDefinitionId $RoleDefinitionID -Scope $StorageAccountInfo.Id -ErrorAction SilentlyContinue

if ($roleAssignment) {
    Write-Output "The 'Reader and Data Access' permissions are already assigned to the managed identity: $PrincipalId"
} else {
    try {
        New-AzRoleAssignment -ObjectId $PrincipalId -RoleDefinitionId $RoleDefinitionID -Scope $StorageAccountInfo.Id | Out-Null
        Write-Output "Assigned 'Reader and Data Access' to the managed identity: $PrincipalId"
    } catch {
        Write-Error "Could not assign Reader and Data Access to the managed identity: $PrincipalId"
    }
}
#endregion
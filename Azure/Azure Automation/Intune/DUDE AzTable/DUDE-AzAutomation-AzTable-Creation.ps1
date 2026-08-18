# Creates Storage Account and Azure Table for DUDE
# Requires Managed Identity, Subscription/Resource Group

# Variables
$SubscriptionId = "39c4591e-44ce-40a5-b762-581e1d6b64c3"
$PrincipalID = "c99df263-8f2a-4c88-9e59-0a3f11dea50c"
$ResourceGroup = "Infrastructure-General"
$Location = "West Europe"
$StorageAccount = "dudestorageaccount1"
$AzTable = "DUDE"

#region Modules (AzStorage, AzAccounts, AzResources)
$AzStorageModule = Get-Module -Name Az.Storage -ListAvailable
if ($AzStorageModule -eq $null) {
    Write-Output "Az Storage module is not installed. Installing..."
    Install-Module -Name Az.Storage -Force -Verbose
    Write-Output "Az Storage module installed successfully."
}
else {
    Write-Output "Az Storage module is already installed."
}

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
    $PrincipalID = "c99df263-8f2a-4c88-9e59-0a3f11dea50c"
}
catch {
    Write-Error "Could not get the PrincipalId of the managed identity."
}
if ((Get-AzRoleAssignment -ObjectId $PrincipalId -RoleDefinitionId 'c12c1c16-33a1-487b-954d-41c89c60f349' -Scope $StorageAccountInfo.Id -ErrorAction SilentlyContinue).DisplayName.Count -eq '1') {
    Write-Output "The 'Reader and Data Access' permissions are already assigned to the identity of function app: $($FunctionApp)"
}
else {
    try {
        New-AzRoleAssignment -ObjectId $PrincipalId -RoleDefinitionId 'c12c1c16-33a1-487b-954d-41c89c60f349' -Scope $StorageAccountInfo.Id | Out-Null
        Write-Output "Assigned 'Reader and Data Access' to the managed identity: $PrincipalId"
    }
    catch {
        Write-Error "Could not assign 'Reader and Data Access' to the managed identity: $PrincipalId"
    }
}
#endregion
<#

.DESCRIPTION
This script will add a row to the DUDE AzTable.

.PARAMETER SubscriptionId
The subscription id where the DUDE AzTable is located.

.PARAMETER ResourceGroup
The resource group where the DUDE AzTable is located. Default is 'RG-DUDE'.

.PARAMETER StorageAccount
The storage account name where the DUDE AzTable is located. Default is 'dudestorage'.

.PARAMETER AzTable
The azure table name. Default is 'DUDE'.

.PARAMETER RowKey
The row key. Default is 'Default'. If 'Default' is used, the script will find the next available number.

.PARAMETER UserGroup
The user group name.

.PARAMETER CreateUserGroup
Create user group. Default is 'Disabled'. If 'Enabled' is used, DUDE will create the user group.

.PARAMETER UserGroupDescription
The user group description.

.PARAMETER UserGroupMembershipRule
The user group membership rule. Default is ''. If a rule is used, DUDE will create the dynamic user group.

.PARAMETER DeviceGroup
The device group name.

.PARAMETER CreateDeviceGroup
Create device group. Default is 'Disabled'. If 'Enabled' is used, DUDE will create the device group.

.PARAMETER DeviceGroupDescription
The device group description.

.PARAMETER ScopeTag
The scope tag name. Default is ''. If a tag is used, DUDE will create and assign the scope tag to the device group.

.PARAMETER ScopeTagDescription
The scope tag description.

.EXAMPLE
.\DUDE-AzTableRow -SubscriptionId 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' -UserGroup 'DUDE Users Rock' -DeviceGroup 'DUDE Devices Rock'
.\DUDE-AzAddTableRow.ps1 -SubscriptionId '39c4591e-44ce-40a5-b762-581e1d6b64c3' -UserGroup 'EvergreenDev-Dynamic Users IT' -DeviceGroup 'EvergreenDev-Dynamic Devices IT'

.\DUDE-AzTableRow -SubscriptionId '39c4591e-44ce-40a5-b762-581e1d6b64c3' -UserGroup 'DUDE Users Rock' -DeviceGroup 'DUDE Devices Rock'


.NOTES
1.0 - 2024-02-10 - Initial version.

#>

#region Parameters
[cmdletbinding()]
param (
    [parameter(Mandatory = $true)]
    [string]$SubscriptionId,

    [parameter(Mandatory = $false)]
    [string]$ResourceGroup = 'Infrastructure-General',

    [parameter(Mandatory = $false)]
    [string]$StorageAccount = 'dudestorageaccount1',

    [parameter(Mandatory = $false)]
    [string]$AzTable = 'DUDE',

    [parameter(Mandatory = $false)]
    [string]$RowKey = 'Default',

    [parameter(Mandatory = $true)]
    [string]$UserGroup,

    [parameter(Mandatory = $false)]
    [Switch]$CreateUserGroup,

    [parameter(Mandatory = $false)]
    [string]$UserGroupDescription = '',

    [parameter(Mandatory = $false)]
    [string]$UserGroupMembershipRule = '',

    [parameter(Mandatory = $true)]
    [string]$DeviceGroup,

    [parameter(Mandatory = $false)]
    [Switch]$CreateDeviceGroup,

    [parameter(Mandatory = $false)]
    [string]$DeviceGroupDescription = '',

    [parameter(Mandatory = $false)]
    [string]$ScopeTag = '',

    [parameter(Mandatory = $false)]
    [Switch]$CreateScopeTag,

    [parameter(Mandatory = $false)]
    [string]$ScopeTagDescription = ''
)
#endregion

#region Modules
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

$AzTableModule = Get-Module -Name AzTable -ListAvailable
if ($AzTableModule -eq $null) {
    Write-Output "Az Table module is not installed. Installing..."
    Install-Module -Name AzTable -Force -Verbose
    Write-Output "Az Table module installed successfully."
}
else {
    Write-Output "AzTable module is already installed."
}
#endregion

#region Connect
if ((Get-AzContext).Subscription.Id -ne $SubscriptionId) {
    try {
        Connect-AzAccount -Subscription $SubscriptionId | Out-Null
    }
    catch {
        Write-Error "Could not connect to the tenant" -ErrorAction Stop
    }
}
Write-Output "Connected to tenant: $((Get-AzTenant).Name)"
#endregion

#region Storage Account
try {
    $StorageAccountInfo = Get-AzStorageAccount -Name $StorageAccount -ResourceGroupName $ResourceGroup
}
catch {
    Write-Error "Could not get storage account info: $($StorageAccount)" -ErrorAction Stop
}
#endregion

#region AzTableContent
$AzTableInfo = (Get-AzStorageTable –Context $StorageAccountInfo.Context | Where-Object { $_.Name -eq $AzTable }).CloudTable
if ($AzTableInfo.Name.Count -ne "1") {
    Write-Error "Could not get AzTableInfo $($AzTable)" -ErrorAction Stop
}
$AzTableContent = Get-AzTableRow -Table $AzTableInfo
#endregion

#region Verify Parameters
if ($RowKey -eq 'Default') {
    $AvailableNumber = 1
    while ($AzTableContent.RowKey -contains $AvailableNumber.ToString('000000')) {
        $AvailableNumber++
    }
    $RowKey = $AvailableNumber.ToString('000000')
}
else {
    if ($AzTableContent.RowKey -contains $RowKey) {
        Write-Error "AzTable already contains RowKey $($RowKey)"
    }
}
if ($CreateUserGroup) {
    $CreateUserGroupValue = 'Enabled'
}
else {
    $CreateUserGroupValue = 'Disabled'
}
if ($CreateDeviceGroup) {
    $CreateDeviceGroupValue = 'Enabled'
}
else {
    $CreateDeviceGroupValue = 'Disabled'
}
if ($CreateScopeTag) {
    $CreateScopeTagValue = 'Enabled'
}
else {
    $CreateScopeTagValue = 'Disabled'
}
#endregion

#region AddAzTableRow
try {
    $Add = Add-AzTableRow `
        -Table $AzTableInfo `
        -PartitionKey 'DUDE' `
        -RowKey $RowKey `
        -property @{
        'UserGroup'               = "$($UserGroup)"
        'CreateUserGroup'         = "$($CreateUserGroupValue)"
        'UserGroupDescription'    = "$($UserGroupDescription)"
        'UserGroupMembershipRule' = "$($UserGroupMembershipRule)"
        'DeviceGroup'             = "$($DeviceGroup)"
        'CreateDeviceGroup'       = "$($CreateDeviceGroupValue)"
        'DeviceGroupDescription'  = "$($DeviceGroupDescription)"
        'ScopeTag'                = "$($ScopeTag)"
        'CreateScopeTag'          = "$($CreateScopeTagValue)"
        'ScopeTagDescription'     = "$($ScopeTagDescription)"
    }
    Write-Output 'Successfully added row to AzTable: '$($AzTable)''
}
catch {
    Write-Error 'Could not add row to AzTable: '$($AzTable)'' -ErrorAction Stop
}
#endregion
<#

.DESCRIPTION
    The purpose of this solution is to have dynamic user groups based on any attribute supported in Entra ID groups and a corresponding assigned device group.
    The script will then check who’s in the user group, grab all the users devices from Intune and add them to the corresponding device group.
    If a user is removed from the user group, their device will also automatically be removed from the device group.

.VARIABLES
    $RunLevel - The run level of the script. Can be 'Prod' or 'Debug'. Prod will make changes and Debug will only show what would have been done.
    $ResourceGroup - The resource group where the DUDE AzTable is located.
    $StorageAccount - The storage account name where the DUDE AzTable is located.
    $TableName - The azure table name. Default is 'DUDE'.

.NOTES
    1.0 - 2021-10-16 - Initial version.
    1.1 - 2021-11-16 - Matching users devices based on registeredOwner from Entra ID devices and fallback to userPrincipalName from Intune managedDevices.
    1.2 - 2021-11-17 - Added DeviceFilter to be able to choose between including all Intune and Entra ID devices or all Intune and only Managed Entra ID devices.
    1.3 - 2022-06-27 - Updated devices to add and devices to remove filter.
    1.4 - 2022-06-28 - Updated devices to add and devices to remove filter.
    1.5 - 2023-03-20 - PrimaryUser will only be gathered from Intune.
    3.1 - 2023-10-09 - Resolved an issue when counting $UserGroupMembersManagedDevices.
    4.0 - 2023-10-26 - Added support for nested device groups in the DUDE Devices groups.
    5.0 - 2024-01-11 - DUDE now use an azure table!

#>

#region Variables
$RunLevel -eq "Prod"
$ResourceGroup = "Infrastructure-General"
$StorageAccount = "dudestorageaccount1"
$TableName = "DUDE"
#endregion

#region Functions
function Get-GraphAccessToken {
    try {
        $ResourceURI = "https://graph.microsoft.com/"
        $TokenAuthURI = $env:IDENTITY_ENDPOINT + "?resource=$ResourceURI&api-version=2019-08-01"
        $TokenResponse = Invoke-RestMethod -Method Get -Headers @{"X-IDENTITY-HEADER" = "$env:IDENTITY_HEADER" } -Uri $TokenAuthURI -ErrorAction Stop
        $GraphAccessToken = @{ "Authorization" = "Bearer $($TokenResponse.access_token)" }
        return $GraphAccessToken
    }
    catch {
        Write-Error $_.Exception
    }
}

function Invoke-GraphCall {
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $false)]
        [ValidateSet('Get', 'Post', 'Patch', 'Delete')]
        [string]$Method = 'Get',

        [parameter(Mandatory = $false)]
        [hashtable]$GraphAccessToken = $script:GraphAccessToken,

        [parameter(Mandatory = $true)]
        [string]$Uri,

        [parameter(Mandatory = $false)]
        [string]$ContentType = 'Application/Json;CharSet=UTF-8',

        [parameter(Mandatory = $false)]
        [hashtable]$Body
    )
    try {
        $params = @{
            Method      = $Method
            Headers     = $GraphAccessToken
            Uri         = $Uri
            ContentType = $ContentType
        }
        if ($Body) {
            $params.Body = $Body | ConvertTo-Json -Depth 20
        }
        if ($Method -eq "Get") {
            $request = Invoke-RestMethod @params
            $pages = $request.'@odata.nextLink'
            while ($null -ne $pages) {
                $addtional = Invoke-RestMethod -Method Get -Uri $pages -Headers $GraphAccessToken
                if ($pages) {
                    $pages = $addtional."@odata.nextLink"
                }
                $request.value += $addtional.value
            }
            return $request
        }
        else {
            $request = Invoke-RestMethod @params
            return $request
        }
    }
    catch {
        Write-Warning $_.Exception.Message
    }
}

#region Connect AzAccount & Get StorageAccount
Connect-AzAccount -Identity | Out-Null
$StorageAccount = Get-AzStorageAccount -Name $StorageAccount -ResourceGroupName $ResourceGroup
#endregion


#region Get TableContent
$Table = (Get-AzStorageTable –Context $StorageAccount.Context | Where-Object { $_.Name -eq $TableName }).CloudTable
if ($Table.Name.Count -ne "1") {
    Write-Error "Could not get AzTable $($TableName)" -ErrorAction Stop
}
Write-Output "AzTableName = $($Table.Name)"
try {
    $TableContent = Get-AzTableRow -Table $Table
    Write-Output "TableContent = $($TableContent.Count)"
}
catch {
    Write-Error "Could not get TableContent $($Table.Name)" -ErrorAction Stop
}
#endregion

#region Get GraphAccessToken
$script:GraphAccessToken = Get-GraphAccessToken
#endregion

#region Get AllUserGroups
$AllUserGroups = @()
$Count = 0
do {
    $Results = @()
    $Batch = [System.Collections.ArrayList]@()
    $TableContent | Select-Object -First 20 -Skip $Count | Foreach-Object {
        $Object = [ordered]@{
            "id"     = $_.RowKey
            "method" = "GET"
            "url"    = "/groups?`$filter=(displayName eq '$($_.UserGroup)')&`$select=id,displayName,description,membershipRule"
        }
        $Batch.Add($Object) | Out-Null
        $Count++
    }
    $Body = @{
        "requests" = $Batch
    }
    $Results = (Invoke-GraphCall -Method "POST" -Uri "https://graph.microsoft.com/beta/`$batch" -Body $Body).responses
    $AllUserGroups += $Results | Where-Object { $_.body.error -eq $null -and $_.body.value -ne $null }
    $FailedRequests = $Results | Where-Object { $_.body.error -ne $null }
    if ($FailedRequests.id.Count -ge 1) {
        Write-Error "AllUserGroups batching failed" -ErrorAction Stop
    }
} until ($Count -eq $TableContent.RowKey.Count)
$AllUserGroups = $AllUserGroups.body.value
Write-Output "AllUserGroups = $($AllUserGroups.id.Count)"
#endregion

#region Get AllDeviceGroups
$AllDeviceGroups = @()
$Count = 0
do {
    $Results = @()
    $Batch = [System.Collections.ArrayList]@()
    $TableContent | Select-Object -First 20 -Skip $Count | Foreach-Object {
        $Object = [ordered]@{
            "id"     = $_.RowKey
            "method" = "GET"
            "url"    = "/groups?`$filter=(displayName eq '$($_.DeviceGroup)')&`$select=id,displayName,description,membershipRule"
        }
        $Batch.Add($Object) | Out-Null
        $Count++
    }
    $Body = @{
        "requests" = $Batch
    }
    $Results = (Invoke-GraphCall -Method "POST" -Uri "https://graph.microsoft.com/beta/`$batch" -Body $Body).responses
    $AllDeviceGroups += $Results | Where-Object { $_.body.error -eq $null -and $_.body.value -ne $null }
    $FailedRequests = $Results | Where-Object { $_.body.error -ne $null }
    if ($FailedRequests.id.Count -ge 1) {
        Write-Error "AllDeviceGroups batching failed" -ErrorAction Stop
    }
} until ($Count -eq $TableContent.RowKey.Count)
$AllDeviceGroups = $AllDeviceGroups.body.value
Write-Output "AllDeviceGroups = $($AllDeviceGroups.id.Count)"
#endregion

#region Get AllScopeTags
if ($TableContent.CreateScopeTag -contains "Enabled") {
    $AllScopeTags = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/deviceManagement/roleScopeTags").value
    if ($AllScopeTags.id.Count -eq "0") {
        Write-Error "Could not get AllScopeTags" -ErrorAction Stop
    }
    Write-Output "AllScopeTags = $($AllScopeTags.id.Count)"
}
#endregion

#region Get AllScopeTagAssignments
if ($TableContent.CreateScopeTag -contains "Enabled") {
    $AllScopeTagAssignments = @()
    foreach ($ScopeTag in $AllScopeTags) {
        $ScopeTagAssignment = @()
        $ScopeTagAssignment += (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/deviceManagement/roleScopeTags/$($ScopeTag.id)/assignments").value
        foreach ($Assignment in $ScopeTagAssignment) {
            $AllScopeTagAssignments += [PSCustomObject][Ordered]@{
                ScopeTag      = $ScopeTag.displayName
                id            = $ScopeTag.id
                TargetGroupId = $Assignment.target.groupId
            }
        }
    }
    Write-Output "AllScopeTagAssignments = $($AllScopeTagAssignments.id.Count)"
}
#endregion

#region Get AllManagedDevicesWithAADObjectTable
$AllManagedDevices = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/deviceManagement/managedDevices?`$select=id,deviceName,userPrincipalName,azureADDeviceId").value
if ($AllManagedDevices.id.Count -eq "0") {
    Write-Error "Could not get AllManagedDevices" -ErrorAction Stop
}
Write-Output "AllManagedDevices = $($AllManagedDevices.id.Count)"
$AllManagedDevicesWithAADObject = $AllManagedDevices | Where-Object { $_.azureADDeviceId -ne "00000000-0000-0000-0000-000000000000" }
if ($AllManagedDevicesWithAADObject.id.Count -eq "0") {
    Write-Error "Could not get AllManagedDevicesWithAADObject" -ErrorAction Stop
}
Write-Output "AllManagedDevicesWithAADObject = $($AllManagedDevicesWithAADObject.id.Count)"
$AllManagedDevicesWithAADObjectTable = foreach ($Device in $AllManagedDevicesWithAADObject) {
    [PSCustomObject][Ordered]@{
        MdmDeviceId = $Device.id
        AadDeviceId = $Device.azureADDeviceId
        DeviceName  = $Device.deviceName
        EnrolledBy  = $Device.userPrincipalName
        PrimaryUser = $null
    }
}
if ($AllManagedDevicesWithAADObjectTable.MdmDeviceId.Count -eq "0") {
    Write-Error "Could get AllManagedDevicesWithAADObjectTable" -ErrorAction Stop
}
Remove-Variable AllManagedDevices, AllManagedDevicesWithAADObject
Write-Output "AllManagedDevicesWithAADObjectTable = $($AllManagedDevicesWithAADObjectTable.MdmDeviceId.Count)"
#endregion

#region Get AllPrimaryUsers
$AllPrimaryUsers = @()
$Count = 0
do {
    $Results = @()
    $Batch = [System.Collections.ArrayList]@()
    $AllManagedDevicesWithAADObjectTable | Select-Object -First 20 -Skip $Count | Foreach-Object {
        $Object = [ordered]@{
            "id"     = $_.MdmDeviceId
            "method" = "GET"
            "url"    = "/deviceManagement/managedDevices/$($_.MdmDeviceId)/Users?`$select=userPrincipalName"
        }
        $Batch.Add($Object) | Out-Null
        $Count++
    }
    $Body = @{
        "requests" = $Batch
    }
    $Results = (Invoke-GraphCall -Method "POST" -Uri "https://graph.microsoft.com/beta/`$batch" -Body $Body).responses
    $AllPrimaryUsers += $Results | Where-Object { $_.body.error -eq $null }
    $FailedRequests = $Results | Where-Object { (($_.body.error -ne $null) -and ($_.body.error.code -ne "ResourceNotFound")) }
    if ($FailedRequests.id.Count -ge 1) {
        Write-Error "AllPrimaryUsers batching failed" -ErrorAction Stop
    }
} until ($Count -eq $AllManagedDevicesWithAADObjectTable.MdmDeviceId.Count)
$AllPrimaryUsers = $AllPrimaryUsers | Where-Object { $_.body.value.userPrincipalName -ne $null }
if ($AllPrimaryUsers.body.value.userPrincipalName.Count -eq "0") {
    Write-Error "Could not get AllPrimaryUsers" -ErrorAction Stop
}
Write-Output "AllPrimaryUsers = $($AllPrimaryUsers.PrimaryUser.Count)"
#endregion

#region Create AllPrimaryUsersHash
$AllPrimaryUsersHash = @{}
foreach ($User in $AllPrimaryUsers) {
    $AllPrimaryUsersHash.Add($User.id, $User.body.value)
}
if ($AllPrimaryUsersHash.Count -eq "0") {
    Write-Error "Could not create AllPrimaryUsersHash" -ErrorAction Stop
}
Remove-Variable AllPrimaryUsers
Write-Output "AllPrimaryUsersHash = $($AllPrimaryUsersHash.Count)"
#region

#region Get AllManagedDevicesWithAADObjectAndPrimaryUser
$AllManagedDevicesWithAADObjectAndPrimaryUser = foreach ($Device in $AllManagedDevicesWithAADObjectTable) {
    if ($AllPrimaryUsersHash.ContainsKey($Device.MdmDeviceId)) {
        $Device.PrimaryUser = $AllPrimaryUsersHash[$Device.MdmDeviceId].userPrincipalName
        $Device
    }
    else {
        $Device
    }
}
if ($AllManagedDevicesWithAADObjectAndPrimaryUser.MdmDeviceId.Count -eq "0") {
    Write-Error "Could not get AllManagedDevicesWithAADObjectAndPrimaryUser" -ErrorAction Stop
}
Remove-Variable AllPrimaryUsersHash, AllManagedDevicesWithAADObjectTable
Write-Output "AllManagedDevicesWithAADObjectAndPrimaryUser = $($AllManagedDevicesWithAADObjectAndPrimaryUser.MdmDeviceId.Count)"
#endregion

#region Manage groups
$EntityCount = 0
foreach ($Entity in $TableContent) {
    $EntityCount++
    Write-Output "Running Entity $($EntityCount) of $($TableContent.RowKey.count) = `"$($Entity.UserGroup)`""

    # Verify UserGroup
    $UserGroupExists = $True
    $UserGroup = $AllUserGroups | Where-Object { $_.displayName -eq $Entity.UserGroup }
    if ($UserGroup.id.count -eq "0") {
        if ($Entity.CreateUserGroup -eq "Enabled") {
            if ([string]::IsNullOrEmpty(($Entity.UserGroupDescription))) {
                $UserGroupDescription = "UserGroup created by DUDE"
            }
            else {
                $UserGroupDescription = $Entity.UserGroupDescription
            }
            if ($Entity.UserGroupMembershipRule -ne "") {
                $Body = @{
                    "displayName"                   = $Entity.UserGroup;
                    "description"                   = "UserGroup created by DUDE";
                    "membershipRule"                = $UserGroupDescription;
                    "groupTypes"                    = @("DynamicMembership");
                    "mailEnabled"                   = $False;
                    "mailNickname"                  = ([guid]::NewGuid().ToString());
                    "membershipRuleProcessingState" = "On";
                    "securityEnabled"               = $True
                }
                if ($RunLevel -eq "Prod") {
                    $UserGroup = Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups" -Method POST -Body $Body | Select-Object id, displayName, membershipRule
                    Write-Output "Created dynamic UserGroup `"$($Entity.UserGroup)`""
                }
                else {
                    Write-Output "Would create dynamic UserGroup `"$($Entity.UserGroup)`""
                    $UserGroupExists = $False
                }
            }
            else {
                if ($RunLevel -eq "Prod") {
                    $Body = @{
                        "displayName"     = $Entity.UserGroup;
                        "description"     = $UserGroupDescription;
                        "groupTypes"      = @();
                        "mailEnabled"     = $False;
                        "mailNickname"    = ([guid]::NewGuid().ToString());
                        "securityEnabled" = $True
                    }
                    $UserGroup = Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups" -Method POST -Body $Body | Select-Object id, displayName
                    Write-Output "Created static UserGroup `"$($Entity.UserGroup)`""
                }
                else {
                    Write-Output "Would create static UserGroup `"$($Entity.UserGroup)`""
                    $UserGroupExists = $False
                }
            }
        }
        else {
            Write-Error "Could not get UserGroup" -ErrorAction Continue
        }
    }
    elseif ($UserGroup.id.count -eq "1") {
        if ($Entity.CreateUserGroup -eq "Enabled") {
            if ([string]::IsNullOrEmpty(($Entity.UserGroupDescription))) {
                $UserGroupDescription = "UserGroup created by DUDE"
            }
            else {
                $UserGroupDescription = $Entity.UserGroupDescription
            }
            if ($UserGroup.description -ne $UserGroupDescription) {
                $Body = @{
                    "description" = $UserGroupDescription
                }
                if ($RunLevel -eq "Prod") {
                    Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups/$($UserGroup.id)" -Method PATCH -Body $Body | Out-Null
                    Write-Output "Updated UserGroup `"$($Entity.UserGroup)`" description"
                }
                else {
                    Write-Output "Would update UserGroup `"$($Entity.UserGroup)`" description"
                }
            }
            if ([string]::IsNullOrEmpty(($Entity.UserGroupMembershipRule))) {
            }
            else {
                if ($UserGroup.membershipRule -ne $Entity.UserGroupMembershipRule) {
                    $Body = @{
                        "membershipRule" = $Entity.UserGroupMembershipRule
                    }
                    if ($RunLevel -eq "Prod") {
                        Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups/$($UserGroup.id)" -Method PATCH -Body $Body | Out-Null
                        Write-Output "Updated UserGroup `"$($Entity.UserGroup)`" membershipRule"
                    }
                    else {
                        Write-Output "Would update UserGroup `"$($Entity.UserGroup)`" membershipRule"
                    }
                }
            }
        }
    }
    if ($UserGroup.id.count -ne "1" -and $RunLevel -eq "Prod") {
        Write-Error "Could not verify UserGroup. Please troubleshoot." -ErrorAction Stop
    }

    # Verify DeviceGroup
    $DeviceGroup = $AllDeviceGroups | Where-Object { $_.displayName -eq $Entity.DeviceGroup }
    if ($DeviceGroup.id.count -eq "0") {
        if ($Entity.CreateDeviceGroup -eq "Enabled") {
            if ([string]::IsNullOrEmpty(($Entity.DeviceGroupDescription))) {
                $DeviceGroupDescription = "DeviceGroup created by DUDE"
            }
            else {
                $DeviceGroupDescription = $Entity.DeviceGroupDescription
            }
            if ($RunLevel -eq "Prod") {
                $Body = @{
                    "displayName"     = $Entity.DeviceGroup;
                    "description"     = $DeviceGroupDescription;
                    "groupTypes"      = @();
                    "mailEnabled"     = $False;
                    "mailNickname"    = ([guid]::NewGuid().ToString());
                    "securityEnabled" = $True
                }
                $DeviceGroup = Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups" -Method POST -Body $Body | Select-Object id, displayName
                Write-Output "Created DeviceGroup `"$($Entity.DeviceGroup)`""
            }
            else {
                Write-Output "Would create DeviceGroup `"$($Entity.DeviceGroup)`""
            }
        }
        else {
            Write-Error "Could not get DeviceGroup" -ErrorAction Continue
        }
    }
    elseif ($DeviceGroup.id.count -eq "1") {
        if ($Entity.CreateDeviceGroup -eq "Enabled") {
            if ([string]::IsNullOrEmpty(($Entity.DeviceGroupDescription))) {
                $DeviceGroupDescription = "DeviceGroup created by DUDE"
            }
            else {
                $DeviceGroupDescription = $Entity.DeviceGroupDescription
            }
            if ($DeviceGroup.description -ne $DeviceGroupDescription) {
                $Body = @{
                    "description" = $DeviceGroupDescription
                }
                if ($RunLevel -eq "Prod") {
                    Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups/$($DeviceGroup.id)" -Method PATCH -Body $Body | Out-Null
                    Write-Output "Updated DeviceGroup `"$($Entity.DeviceGroup)`" description"
                }
                else {
                    Write-Output "Would update DeviceGroup `"$($Entity.DeviceGroup)`" description"
                }
            }
        }
    }
    if ($DeviceGroup.id.count -ne "1" -and $RunLevel -eq "Prod") {
        Write-Error "Could not verify DeviceGroup. Please troubleshoot." -ErrorAction Stop
    }

    # Verify ScopeTag
    if ($Entity.ScopeTag -ne "") {
        $ScopeTag = $AllScopeTags | Where-Object { $_.displayName -eq $Entity.ScopeTag }
        if ($ScopeTag.id.count -eq "0") {
            if ($Entity.CreateScopeTag -eq "Enabled") {
                if ($RunLevel -eq "Prod") {
                    if ([string]::IsNullOrEmpty($Entity.ScopeTagDescription)) {
                        $ScopeTagDescription = "ScopeTag created by DUDE"
                    }
                    else {
                        $ScopeTagDescription = $Entity.ScopeTagDescription
                    }
                    $Body = @{
                        "displayName" = $($Entity.ScopeTag)
                        "description" = $($ScopeTagDescription)
                    }
                    try {
                        $ScopeTagResponse = Invoke-GraphCall -Method Post -Uri "https://graph.microsoft.com/beta/deviceManagement/roleScopeTags" -Body $Body
                        $ScopeTag = $ScopeTagResponse
                        Write-Output "Created ScopeTag `"$($Entity.ScopeTag)`""
                    }
                    catch {
                        Write-Error "Could not create ScopeTag `"$($Group.ScopeTagName)`"" -ErrorAction Continue
                    }
                }
                else {
                    Write-Output "Would create ScopeTag `"$($Entity.ScopeTag)`""
                }
            }
            else {
                Write-Error "Could not get ScopeTag `"$($Entity.ScopeTag)`"" -ErrorAction Continue
            }
        }
        elseif ($ScopeTag.id.count -eq "1") {
            if ($Entity.CreateScopeTag -eq "Enabled") {
                if ([string]::IsNullOrEmpty(($Entity.ScopeTagDescription))) {
                    $ScopeTagDescription = "ScopeTag created by DUDE"
                }
                else {
                    $ScopeTagDescription = $Entity.ScopeTagDescription
                }
                if ($ScopeTag.description -ne $ScopeTagDescription) {
                    $Body = @{
                        "description" = $ScopeTagDescription
                    }
                    if ($RunLevel -eq "Prod") {
                        Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/deviceManagement/roleScopeTags/$($ScopeTag.id)" -Method PATCH -Body $Body | Out-Null
                        Write-Output "Updated ScopeTag `"$($Entity.ScopeTag)`" description"
                    }
                    else {
                        Write-Output "Would update ScopeTag `"$($Entity.ScopeTag)`" description"
                    }
                }
            }
        }
        if ($ScopeTag.id.count -ne "1" -and $RunLevel -eq "Prod") {
            Write-Error "Could not verify ScopeTag. Please troubleshoot." -ErrorAction Stop
        }
    }

    # Verify ScopeTagAssignment
    if ($Entity.ScopeTag -ne "") {
        $ScopeTagAssignment = $AllScopeTagAssignments | Where-Object { $_.ScopeTag -eq $Entity.ScopeTag -and $_.TargetGroupId -eq $DeviceGroup.id }
        if ($ScopeTagAssignment.id.Count -eq "0") {
            if ($Entity.CreateScopeTag -eq "Enabled") {
                if ($RunLevel -eq "Prod") {
                    $Body = @{
                        "assignments" = @(
                            @{
                                "target" = @{
                                    "@odata.type" = "#microsoft.graph.groupAssignmentTarget"
                                    "groupId"     = $DeviceGroup.id
                                }
                            }
                        )
                    }
                    try {
                        $ScopeTagAssignment = (Invoke-GraphCall -Method Post -Uri "https://graph.microsoft.com/beta/deviceManagement/roleScopeTags/$($ScopeTag.id)/assign" -Body $Body).Value
                        Write-Output "Assigned ScopeTag `"$($Entity.ScopeTag)`" to DeviceGroup `"$($DeviceGroup.displayName)`""
                    }
                    catch {
                        Write-Error "Could not assign ScopeTag `"$($Entity.ScopeTag)`" to DeviceGroup `"$($DeviceGroup.displayName)`"" -ErrorAction Continue
                    }
                }
                else {
                    Write-Output "Would assign ScopeTag `"$($Entity.ScopeTag)`" to DeviceGroup `"$($DeviceGroup.displayName)`""
                }
            }
            else {
                Write-Error "Could not get ScopeTagAssignment" -ErrorAction Continue
            }
        }
        if ($ScopeTagAssignment.id.count -ne "1" -and $RunLevel -eq "Prod") {
            Write-Error "Could not verify ScopeTagAssignment. Please troubleshoot." -ErrorAction Stop
        }
    }

    # Get UserGroupMembers
    if ($UserGroupExists) {
        $UserGroupMembers = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups/$($UserGroup.id)/members?`$select=id,userPrincipalName").value
        if ($UserGroupMembers.id.Count -eq "0") {
            Write-Output "Could not find any UserGroupMembers in `"$($UserGroup.displayName)`""
        }
        else {
            # Get UserGroupMembersManagedDevices
            $UserGroupMembersManagedDevices = $AllManagedDevicesWithAADObjectAndPrimaryUser | Where-Object { $UserGroupMembers.UserPrincipalName -contains $_.PrimaryUser }
            if ($UserGroupMembersManagedDevices.MdmDeviceId.Count -eq "0") {
                Write-Output "Could not find any UserGroupMembersManagedDevices"
            }
            else {
                # Get DeviceGroupMembers
                $DeviceGroupMembers = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups/$($DeviceGroup.id)/members?`$select=id,deviceId").value

                # Get DevicesToAddToDeviceGroup
                $DevicesToAddToDeviceGroup = $UserGroupMembersManagedDevices | Where-Object { $DeviceGroupMembers.deviceId -notcontains $_.AadDeviceId }

                # Get DevicesToRemoveFromDeviceGroup
                $DevicesToRemoveFromDeviceGroup = $DeviceGroupMembers | Where-Object { ($UserGroupMembersManagedDevices.AadDeviceId -notcontains $_.deviceId) -and ($DevicesToAddToDeviceGroup.AadDeviceId -notcontains $_.deviceId) }

                # Add devices to device group
                $DeviceCount = 0
                foreach ($Device in $DevicesToAddToDeviceGroup) {
                    $DeviceCount++
                    try {
                        $DeviceToAddInfo = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/devices?`$filter=DeviceID eq '$($Device.AadDeviceId)'&`$select=id,displayName").value
                        if ($DeviceToAddInfo.id.count -eq "1") {
                            if ($RunLevel -eq "Prod") {
                                $Body = @{"@odata.id" = "https://graph.microsoft.com/beta/devices/$($DeviceToAddInfo.id)" }
                                Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups/$($DeviceGroup.id)/members/`$ref" -Method POST -Body $Body | Out-Null
                                Write-Output "Device Group (Device $($DeviceCount) of $($DevicesToAddToDeviceGroup.AadDeviceId.count)) Added `"$($DeviceToAddInfo.displayName)`" to `"$($DeviceGroup.displayName)`""
                            }
                            elseif ($RunLevel -eq "Debug") {
                                Write-Output "Device Group (Device $($DeviceCount) of $($DevicesToAddToDeviceGroup.AadDeviceId.count)) Would add `"$($DeviceToAddInfo.displayName)`" to `"$($DeviceGroup.displayName)`""
                            }
                            else {
                                Write-Error "Please specify RunLevel and try again" -ErrorAction Stop
                            }
                        }
                        else {
                            Write-Warning "Device Group (Device $($DeviceCount) of $($DevicesToAddToDeviceGroup.AadDeviceId.count)) Could not find `"$($Device.DeviceName)`" with AadDeviceId `"$($Device.AadDeviceId)`" in Entra ID"
                        }
                    }
                    catch {
                        Write-Error "Device Group (Device $($DeviceCount) of $($DevicesToAddToDeviceGroup.AadDeviceId.count)) Could not add `"$($Device.DeviceName)`" to `"$($DeviceGroup.displayName)`"" -ErrorAction Continue
                    }
                }

                # Remove devices from device group
                $DeviceCount = 0
                foreach ($Device in $DevicesToRemoveFromDeviceGroup) {
                    $DeviceCount++
                    try {
                        $DeviceToRemoveInfo = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/devices?`$filter=id eq '$($Device.id)'&`$select=id,displayName").value
                        if ($RunLevel -eq "Prod") {
                            Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups/$($DeviceGroup.id)/members/$($DeviceToRemoveInfo.id)/`$ref" -Method Delete | Out-Null
                            Write-Output "Device Group (Device $($DeviceCount) of $($DevicesToRemoveFromDeviceGroup.id.count)) Removed `"$($DeviceRemoveInfo.displayName)`" from `"$($DeviceGroup.displayName)`""
                        }
                        elseif ($RunLevel -eq "Debug") {
                            Write-Output "Device Group (Device $($DeviceCount) of $($DevicesToRemoveFromDeviceGroup.id.count)) Would remove `"$($DeviceToRemoveInfo.displayName)`" from `"$($DeviceGroup.displayName)`""
                        }
                        else {
                            Write-Error "Please specify RunLevel and try again" -ErrorAction Stop
                        }
                    }
                    catch {
                        Write-Error "Device Group (Device $($DeviceCount) of $($DevicesToRemoveFromDeviceGroup.id.count)) Could not remove `"$($DeviceToRemoveInfo.displayName)`" from `"$($DeviceGroup.displayName)`"" -ErrorAction Continue
                    }
                }

                if (($Entity.AdminUnit -ne "") -or ($Entity.DefenderTag -ne "")) {
                    # Get nested devicegroups
                    $NestedDeviceGroups = $DeviceGroupMembers | Where-Object { $_."@odata.type" -eq "#microsoft.graph.group" }

                    # Get nested devicegroup members
                    if ($NestedDeviceGroups.id.count -ge "1") {
                        $NestedDeviceGroupsMembers = @()
                        foreach ($Group in $NestedDeviceGroups) {
                            $NestedDeviceGroupsMembers += (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups/$($Group.id)/members?`$select=id,deviceId,displayName").value
                        }
                        $UserGroupMembersManagedDevices += $AllManagedDevicesWithAADObjectAndPrimaryUser | Where-Object { $NestedDeviceGroupsMembers.deviceId -contains $_.AadDeviceId }
                    }
                }
            }
        }
    }
}
#endregion
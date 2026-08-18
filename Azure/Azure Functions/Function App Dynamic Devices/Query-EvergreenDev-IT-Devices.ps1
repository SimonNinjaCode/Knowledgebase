# Input bindings are passed in via param block.
param($Timer)

#region functions
function Get-AccessToken {
    try {
        $ResourceURI = "https://graph.microsoft.com/"
        $TokenAuthURI = $env:IDENTITY_ENDPOINT + "?resource=$ResourceURI&api-version=2019-08-01"
        $TokenResponse = Invoke-RestMethod -Method Get -Headers @{"X-IDENTITY-HEADER" = "$env:IDENTITY_HEADER" } -Uri $TokenAuthURI -ErrorAction Stop
        $AccessToken = @{ "Authorization" = "Bearer $($TokenResponse.access_token)" }
        return $AccessToken
    }
    catch {
        Write-Error $_.Exception
    }
}

function Invoke-GraphCall {
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $false)]
        [ValidateSet('Get', 'Post', 'Delete')]
        [string]$Method = 'Get',

        [parameter(Mandatory = $false)]
        [hashtable]$AccessToken = $script:AccessToken,

        [parameter(Mandatory = $true)]
        [string]$Uri,

        [parameter(Mandatory = $false)]
        [string]$ContentType = 'Application/Json',

        [parameter(Mandatory = $false)]
        [hashtable]$Body
    )
    try {
        $params = @{
            Method      = $Method
            Headers     = $AccessToken
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
                $addtional = Invoke-RestMethod -Method Get -Uri $pages -Headers $AccessToken
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
#endregion

#region get AccessToken
$script:AccessToken = Get-AccessToken
#endregion

#region get AllManagedDevices
$AllManagedDevices = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/deviceManagement/managedDevices?`$select=id,deviceName,userPrincipalName,azureADDeviceId").value
if ($AllManagedDevices.id.Count -eq "0") {
    Write-Error "Could not load AllManagedDevices" -ErrorAction Stop
}
#endregion

#region get AllAzureADDevices
if ($env:DeviceFilter -eq "All") {
    $AllAzureADDevices = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/devices?`$expand=registeredOwners(`$select=id,userPrincipalName)&`$select=id,deviceId,displayName").value | Where-Object { $_.registeredOwners -ne $null }
    if ($AllAzureADDevices.id.Count -eq "0") {
        Write-Error "Could not load AllAzureADDevices" -ErrorAction Stop
    }
}
elseif ($env:DeviceFilter -eq "Managed") {
    $AllAzureADDevices = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/devices?`$expand=registeredOwners(`$select=id,userPrincipalName)&`$select=id,deviceId,displayName,managementType").value | Where-Object { ($_.registeredOwners -ne $null) -and ($_.managementType -ne $null) }
    if ($AllAzureADDevices.id.Count -eq "0") {
        Write-Error "Could not load AllAzureADDevices" -ErrorAction Stop
    }
}
else {
    Write-Error "Please specify DeviceFilter and try again" -ErrorAction Stop
}
#endregion

#region get AllDevices
$AllDevices = $AllManagedDevices | Where-Object { $AllAzureADDevices.deviceId -notcontains $_.azureADDeviceId }
$AllDevices += $AllAzureADDevices
Remove-Variable -Name AllManagedDevices, AllAzureADDevices
#endregion 

Write-Host $AllAzureADDevices
Write-Host $AllDevices

#region get AllUserGroups
$UserGroupList = "EvergreenDev-Dynamic Users IT"
Write-Host $UserGroupList
$AllUserGroups = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups?`$filter=startswith(displayName,'$($UserGroupList)')&`$select=id,displayName").value
$AllUserGroups = $AllUserGroups | Where-Object {$UserGroupList -eq $_.displayName}
Write-Host "AllUserGroups $($AllUserGroups.id.Count)"
if ($AllUserGroups.id.Count -eq "0") {
    Write-Error "Could not load AllUserGroups" -ErrorAction Stop
}
#endregion

#region get AllDeviceGroups
$DeviceGroupList = "EvergreenDev-Dynamic Devices IT"
Write-Host $DeviceGroupList
$AllDeviceGroups = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups?`$filter=startswith(displayName,'$($DeviceGroupList)')&`$select=id,displayName").value
$AllDeviceGroups = $AllDeviceGroups | Where-Object {$DeviceGroupList -eq $_.displayName}
Write-Host "AllDeviceGroups $($AllDeviceGroups.id.Count)"
if ($AllDeviceGroups.id.Count -eq "0") {
    Write-Error "Could not load AllDeviceGroups" -ErrorAction Stop
}
#endregion

$GroupCount = 0
foreach ($Group in $AllUserGroups) {
    $GroupCount++
    Write-Output "Group $($GroupCount) of $($AllUserGroups.id.count): $($Group.displayName)"
    
    # Get usergroup members
    $UserGroupMembers = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups/$($Group.id)/members?`$select=id,userPrincipalName").value
    if ($UserGroupMembers.id.Count -eq "0") {
        Write-Output "Could not find any UserGroupMembers in $($Group.displayName)"
    }
    else {
        # Get usergroup members devices
        $UserGroupMembersDevices = $AllDevices | Where-Object { ($UserGroupMembers.UserPrincipalName -contains $_.UserPrincipalName) -or ($UserGroupMembers.UserPrincipalName -contains $_.registeredOwners.UserPrincipalName) }   
        if ($UserGroupMembersDevices.id.Count -eq "0") {
            Write-Output "Could not find any UserGroupMembersDevices"
        }
        else {
            # Get matching device group
            $DeviceGroup = $AllDeviceGroups | Where-Object { $_.DisplayName -eq ($Group.displayName -replace $env:UserGroupNames, $env:DeviceGroupNames) }
            if ($DeviceGroup.count -eq "0") {
                Write-Error "Could not find any matching device group" -ErrorAction Continue
            }
            else {
                # Get devicegroup members
                $DeviceGroupMembers = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups/$($DeviceGroup.id)/members?`$select=id,deviceId").value

                # Get devices to add
                if ($DeviceGroupMembers.id.count -eq "0") {
                    $DevicesToAdd = $UserGroupMembersDevices
                }
                else {
                    $DevicesToAdd = $UserGroupMembersDevices | Where-Object { ($DeviceGroupMembers.DeviceId -notcontains $_.azureADDeviceId) -and ($DeviceGroupMembers.DeviceId -notcontains $_.deviceId) }
                }
                Write-Host "Devices to add:" $DevicesToAdd
                Write-Host "Count of devices to add" $DevicesToAdd.count

                # Get devices to remove
                $DevicesToRemove = $DeviceGroupMembers | Where-Object { ($UserGroupMembersDevices.azureADDeviceId -notcontains $_.DeviceId) -and ($UserGroupMembersDevices.DeviceId -notcontains $_.DeviceId) -and ($DevicesToAdd.azureADDeviceId -notcontains $_.DeviceId) -and ($DevicesToAdd.azureADDeviceId -notcontains $_.DeviceId) }
                Write-Host "Devices to remove:" $DevciesToRemove
                Write-Host "Count of devices to remove" $DevicesToRemove.count

                 # Add devices
                 $DeviceCount = 0
                 foreach ($Device in $DevicesToAdd) {
                     $DeviceCount++
                     try {
                         if ($null -ne $Device.azureADDeviceId) {
                             $DeviceAddInfo = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/devices?`$filter=DeviceID eq '$($Device.azureADDeviceId)'&`$select=id,displayName").value
                             if ($env:RunLevel -eq "Prod") {
                                 $Body = @{"@odata.id" = "https://graph.microsoft.com/beta/devices/$($DeviceAddInfo.id)" }
                                 Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups/$($DeviceGroup.id)/members/`$ref" -Method POST -Body $Body | Out-Null
                                 Write-Output "Device $($DeviceCount) of $($DevicesToAdd.id.count): Added $($DeviceAddInfo.displayName) to $($DeviceGroup.displayName)"
                             }
                             elseif ($env:RunLevel -eq "Debug") {
                                 Write-Output "Device $($DeviceCount) of $($DevicesToAdd.id.count): Would add $($DeviceAddInfo.displayName) to $($DeviceGroup.displayName)"
                             }
                             else {
                                 Write-Error "Please specify RunLevel and try again" -ErrorAction Stop
                             }
                         }
                         else {
                             if ($env:RunLevel -eq "Prod") {
                                 $Body = @{"@odata.id" = "https://graph.microsoft.com/beta/devices/$($Device.id)" }
                                 Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups/$($DeviceGroup.id)/members/`$ref" -Method POST -Body $Body | Out-Null
                                 Write-Output "Device $($DeviceCount) of $($DevicesToAdd.id.count): Added $($Device.displayName) to $($DeviceGroup.displayName)"
                             }
                             elseif ($env:RunLevel -eq "Debug") {
                                 Write-Output "Device $($DeviceCount) of $($DevicesToAdd.id.count): Would add $($Device.displayName) to $($DeviceGroup.displayName)"
                             }
                             else {
                                 Write-Error "Please specify RunLevel and try again" -ErrorAction Stop
                             }
                         }
 
                     }
                     catch {
                         Write-Error "Device $($DeviceCount) of $($DevicesToAdd.id.count): Could not add $($Device.displayName)$($Device.deviceName) to $($DeviceGroup.displayName)" -ErrorAction Continue
                     }
                 }
 
                 # Remove devices
                 $DeviceCount = 0
                 foreach ($Device in $DevicesToRemove) {
                     $DeviceCount++
                     try {
                         $DeviceRemoveInfo = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/devices?`$filter=id eq '$($Device.id)'&`$select=id,displayName").value
                         if ($env:RunLevel -eq "Prod") {
                             Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups/$($DeviceGroup.id)/members/$($DeviceRemoveInfo.id)/`$ref" -Method Delete | Out-Null
                             Write-Output "Device $($DeviceCount) of $($DevicesToRemove.id.count): Removed $($DeviceRemoveInfo.displayName) from $($DeviceGroup.displayName)"
                         }
                         elseif ($env:RunLevel -eq "Debug") {
                             Write-Output "Device $($DeviceCount) of $($DevicesToRemove.id.count): Would remove $($DeviceRemoveInfo.displayName) from $($DeviceGroup.displayName)"
                         }
                         else {
                             Write-Error "Please specify RunLevel and try again" -ErrorAction Stop
                         }
                     }
                     catch {
                         Write-Error "Device $($DeviceCount) of $($DevicesToRemove.id.count): Could not remove $($Device.displayName)$($Device.deviceName) from $($DeviceGroup.displayName)" -ErrorAction Continue
                     }
                }
            }
        }
    }
}
#endregion
# Variables
$DeviceGroupID = "744b41f6-e227-44a7-b716-b90ac51b91ee" # EvergreenDev-Dynamic Devices IT
#endregion

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

#region Get AllAutopilotDevices
$AllAutopilotDevices = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeviceIdentities").value
if ($AllAutopilotDevices.id.Count -eq "0") {
    Write-Error "Could not get AllAutopilotDevices" -ErrorAction Stop
}
Write-Output "AllAutopilotDevices = $($AllAutopilotDevices.id.Count)"
#endregion

# azureAdDeviceId

#region Get DeviceGroupMembers
$DeviceGroupMembers = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups/$($DeviceGroupID)/members?`$select=id,deviceId").value
$DeviceGroupMembers = $DeviceGroupMembers | Where-Object {$_.deviceId -ne $null}
if ($DeviceGroupMembers.id.Count -eq "0") {
    Write-Error "Could not get DeviceGroupMembers" -ErrorAction Stop
}
Write-Output "DeviceGroupMembers = $($DeviceGroupMembers.id.Count)"
#endregion

#region Create DeviceGroupMembersHash
$DeviceGroupMembersHash = @{}
foreach ($Device in $DeviceGroupMembers) {
    $DeviceGroupMembersHash.Add($Device.deviceId, $Device)
}
if ($DeviceGroupMembersHash.Count -eq "0") {
    Write-Error "Could not create DeviceGroupMembersHash" -ErrorAction Stop
}
Write-Output "DeviceGroupMembersHash = $($DeviceGroupMembersHash.Count)"
#region

#region Get AllDevicesToUpdate



$AllDevicesToUpdate = @()
$AllDevicesToUpdate = foreach ($Device in $AllAutopilotDevices) {
    if ($DeviceGroupMembersHash.ContainsKey($Device.azureAdDeviceId)) {
        $Device
    }
}
if ($AllDevicesToUpdate.id.Count -eq "0") {
    Write-Error "Could not get AllDevicesToUpdate" -ErrorAction Stop
}
Write-Output "AllDevicesToUpdate = $($AllDevicesToUpdate.id.Count)"
#endregion

#region Write output and apply groupTag
foreach($Device in $AllDevicesToUpdate){
    Write-Output "Device: $($Device.serialNumber) has id: $($Device.id)"
    Write-Output "Device: $($Device.serialNumber) has Grouptag: $($Device.grouptag)"
    if ($Device.groupTag -eq 'null') {
    Write-Output "Would update GroupTag on $($Device.serialNumber)"
    Write-Output "Device $($Device.serialNumber) is missing its Grouptag... applying the Grouptag 'SE'"
    $Grouptag = "SE"
    $Body = @{'groupTag' = 'SE'}
    Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeviceIdentities/$($Device.id)/UpdateDeviceProperties" -Method POST -Body $Body | Out-Null
    Write-Output "Updated GroupTag "$GroupTag" on $($Device.serialNumber)"    
    }
    Write-Output "Grouptag does not need to be updated..."
    Write-Output "Device $($Device.serialNumber) has GroupTag $($Device.groupTag)"
}
<# 
SE-CL9CRC2
automationid = 1b523a77-c620-4d71-8279-00f7e7a9aa1e
deviceid = a424659e-e655-4077-8ad2-8beb4f651970
objectid = a57f2c9e-f6bb-403f-8dd5-f31d651a953c
#>
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
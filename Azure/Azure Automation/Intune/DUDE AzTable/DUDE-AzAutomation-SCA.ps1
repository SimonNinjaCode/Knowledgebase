
#region Variables
$RunLevel = "Debug"
$ResourceGroup = ""
$StorageAccount = ""
$TableName = "DUDE"
#endregion

Write-Output "Loading Variables..."
Write-Output "RunLevel: $RunLevel"
Write-Output "Resource Group: $ResourceGroup"
Write-Output "Storage Account: $StorageAccount"
Write-Output "Table Name: $TableName"

Write-Output "Load Function - Get-GraphAccessToken..."
#region Functions
function Get-GraphAccessToken {
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

Write-Output "Load Function - Invoke-GraphCall..."

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

#region Get GraphAccessToken
Write-Output "Get Graph Access token using '$ script : GraphAccessToken'..."
$script:GraphAccessToken = Get-GraphAccessToken
Write-Output $script:GraphAccessToken
#endregion

Write-Output "Connect to AzAccount & GetAzStorageAccount..."

#region Connect AzAccount & Get StorageAccount
Connect-AzAccount -Identity | Out-Null
$StorageAccount = Get-AzStorageAccount -Name $StorageAccount -ResourceGroupName $ResourceGroup
#endregion
Write-Output "Storage Account Name: $($StorageAccount.Name)"

Write-Output "Get Az Table Content..."

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
Write-Output "Get Graph Access token using '$ script : GraphAccessToken'..."
$script:GraphAccessToken = Get-GraphAccessToken
Write-Output $script:GraphAccessToken
#endregion

Write-Output "Get All DUDE User Groups from table..."

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
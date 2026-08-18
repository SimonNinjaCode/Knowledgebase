$TenantID = "4d2b1c1b-741f-485a-91d0-31aa9cff5461"
$SubscriptionId = "39c4591e-44ce-40a5-b762-581e1d6b64c3"
$ResourceGroup = "Infrastructure-Security"
$StorageAccountName = "secreportstorageaccount1"
$AzTable = "graphsecurityscore"


$Date = Get-Date
#$Date = (Get-Date).AddDays(-1)
$RetentionDate = $Date.AddDays(-7)
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
        [ValidateSet("Get", "Post", "Patch", "Delete")]
        [string]$Method = 'Get',

        [parameter(Mandatory = $false)]
        [hashtable]$GraphAccessToken = $script:GraphAccessToken,

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
#endregion

#region Get GraphAccessToken
$script:GraphAccessToken = Get-GraphAccessToken
#endregion
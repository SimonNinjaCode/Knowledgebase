$TenantID = "4d2b1c1b-741f-485a-91d0-31aa9cff5461"
$AppID = "a56a29ed-88f9-4b65-8b4f-c926ecc08fa3"
$AppSecret = "_Xv8Q~DNHhH-o6~vKGlEsyV2yShRa-QteR.JJaYw"

$SubscriptionId = "39c4591e-44ce-40a5-b762-581e1d6b64c3"
$ResourceGroup = "Infrastructure-Security"
$StorageAccountName = "secreportstorageaccount1"
$AzTable = "graphsecurityscore"


$Date = Get-Date
$RetentionDate = $Date.AddDays(-7)


#region Functions
function Get-GraphAccessToken {
        try {
            $GraphHost = "https://graph.microsoft.com/"
            $Body = @{client_id = $AppID; client_secret = $AppSecret; grant_type = "client_credentials"; scope = "$GraphHost/.default"; }
            $OAuthReq = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token" -Body $Body
            $GraphAccessToken = @{ "Authorization" = "Bearer $($OAuthReq.access_token)" }
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
Get-GraphAccessToken
#endregion

# Define the API endpoint
$url = "https://graph.microsoft.com/v1.0/security/secureScores"

# Make the API request using the existing invoke-graphcall function
$response = invoke-graphcall -Uri $url -Method Get

# Parse the JSON response
$secureScores = $response.value

# Loop through the secure scores and extract the required values
foreach ($comparativeScore in $score.averageComparativeScores) {
        if ($comparativeScore.basis -eq "AllTenants") {
            $appsScore = $comparativeScore.appsScore
            $appsScoreMax = $comparativeScore.appsScoreMax
            $dataScore = $comparativeScore.dataScore
            $dataScoreMax = $comparativeScore.dataScoreMax
            $deviceScore = $comparativeScore.deviceScore
            $deviceScoreMax = $comparativeScore.deviceScoreMax
            $identityScore = $comparativeScore.identityScore
            $identityScoreMax = $comparativeScore.identityScoreMax
            
            # Output the extracted values
            Write-Output "Apps Score: $appsScore / $appsScoreMax"
            Write-Output "Data Score: $dataScore / $dataScoreMax"
            Write-Output "Device Score: $deviceScore / $deviceScoreMax"
            Write-Output "Identity Score: $identityScore / $identityScoreMax"
        }
    }

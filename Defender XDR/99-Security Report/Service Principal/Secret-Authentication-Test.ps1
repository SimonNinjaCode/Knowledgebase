$TenantID = "4d2b1c1b-741f-485a-91d0-31aa9cff5461"
$ClientID = "a56a29ed-88f9-4b65-8b4f-c926ecc08fa3"
$ClientSecret = "_Xv8Q~DNHhH-o6~vKGlEsyV2yShRa-QteR.JJaYw"
$SubscriptionId = "39c4591e-44ce-40a5-b762-581e1d6b64c3"
$ResourceGroup = "Infrastructure-Security"
$StorageAccountName = "secreportstorageaccount1"
$AzTable = "graphsecurityscore"

function Get-GraphAccessToken {
    param (
        [string]$TenantId,
        [string]$ClientId,
        [string]$ClientSecret
    )
    try {
        $body = @{
            grant_type    = "client_credentials"
            client_id     = $ClientId
            client_secret = $ClientSecret
            scope         = "https://graph.microsoft.com/.default"
        }
        $TokenAuthURI = "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token"
        $TokenResponse = Invoke-RestMethod -Method Post -Uri $TokenAuthURI -ContentType "application/x-www-form-urlencoded" -Body $body -ErrorAction Stop
        $AccessToken = @{ "Authorization" = "Bearer $($TokenResponse.access_token)" }
        return $AccessToken
    }
    catch {
        Write-Error "Error getting Graph access token: $($_.Exception.Message)"
    }
}

Write-Output "Get Graph Access token using service principal..."
$script:GraphAccessToken = Get-GraphAccessToken -TenantId $TenantId -ClientId $ClientId -ClientSecret $ClientSecret
Write-Output $script:GraphAccessToken

#region Connect AzAccount & Get StorageAccount
Connect-AzAccount -Subscription $SubscriptionId | Out-Null
$StorageAccount = Get-AzStorageAccount -Name $StorageAccountName -ResourceGroupName $ResourceGroup
Write-Output "Storage Account Name:" $StorageAccount.StorageAccountName
#endregion
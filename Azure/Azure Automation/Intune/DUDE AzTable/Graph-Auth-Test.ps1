Write-Output "Loading Function... Get-GraphAccessToken"

function Get-GraphAccessToken {
    try {
        $ResourceURI = "https://graph.microsoft.com/"
        $TokenAuthURI = $env:IDENTITY_ENDPOINT + "?resource=$ResourceURI&api-version=2019-08-01"
        $TokenResponse = Invoke-RestMethod -Method Get -Headers @{"X-IDENTITY-HEADER" = "$env:IDENTITY_HEADER" } -Uri $TokenAuthURI -ErrorAction Stop
        $AccessToken = @{ "Authorization" = "Bearer $($TokenResponse.access_token)" }
        return $AccessToken
    }
    catch {
        Write-Error "Error getting Graph access token: $($_.Exception.Message)"
    }
}

Write-Output "Running Function... Get-GraphAccessToken"
Get-GraphAccessToken

#region Get GraphAccessToken
Write-Output "Get Graph Access token using '$ script : GraphAccessToken'..."
$script:GraphAccessToken = Get-GraphAccessToken
Write-Output $script:GraphAccessToken
#endregion
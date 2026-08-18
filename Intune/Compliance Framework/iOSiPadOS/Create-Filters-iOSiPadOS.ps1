$ClientID = "d2d49a7d-1d8c-48a8-b439-c10de5a1530c"
$TenantID = "4d2b1c1b-741f-485a-91d0-31aa9cff5461"

# Install the MSAL.PS module if not already installed
if (!(Get-Module -ListAvailable -Name MSAL.PS)) {
    Install-Module -Name MSAL.PS -Scope CurrentUser
}

# Acquire an access token interactively
$Token = Get-MsalToken -ClientId $ClientID -TenantID $TenantID  -Interactive

# Set header for Graph-requests
$Header = @{
    "Authorization" = "Bearer $($token.AccessToken)"
    "Content-Type"  = "application/json"
}

# API Endpoint for creating an iOS/iPadOS filter
$Endpoint = "https://graph.microsoft.com/beta/deviceManagement/assignmentfilters"

# Body Properties - Filter iOS/iPadOS Version 17.0
$Body = @{
    displayName = 'iOS/iPadOS Version 17.0'
    description = 'All iOS/iPadOS devices with OS-version 17.0'
    platform    = 'iOS'
    rule        = '(device.osVersion -startsWith \"17\")'
} | ConvertTo-Json -Depth 10

# Send the request to the Endpoint - Create the filter
$Response = Invoke-RestMethod -Uri $Endpoint -Method Post -Headers $Header -Body $Body

# Output the response
$Response
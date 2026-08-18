# Import the module
#Write-Host 'Installing...'
#Install-Module Microsoft.Graph.Intune -Force -AcceptLicense

# Log into test tenant
Write-Host 'Logging in...'
#$creds = Get-AutomationPSCredential -Name 'IntuneAutomation' # To create credentials in Azure Automation: https://docs.microsoft.com/en-us/azure/automation/shared-resources/credentials#creating-a-new-credential-asset
#Connect-MSGraph -PSCredential $creds

####################
## AUTHENTICATION ##
####################

## Get MS Graph access token 
# Managed Identity
$url = $env:IDENTITY_ENDPOINT  
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]" 
$headers.Add("X-IDENTITY-HEADER", $env:IDENTITY_HEADER) 
$headers.Add("Metadata", "True") 
$body = @{resource='https://graph.microsoft.com/' } 
$accessToken = (Invoke-RestMethod $url -Method 'POST' -Headers $headers -ContentType 'application/x-www-form-urlencoded' -Body $body ).access_token
$authHeader = @{
    'Authorization' = "Bearer $accessToken"
}

#Connect-AzAccount -Identity

# Run a simple cmdlet (no network traffic)
Write-Host 'Get current MSGraph environment parameters'
Get-MSGraphEnvironment

#########################
## GET DATA FROM GRAPH ##
#########################

$URI = "https://graph.microsoft.com/beta/deviceManagement/manageddevices"
$Response = Invoke-WebRequest -Uri $URI -Method Get -Headers $authHeader -UseBasicParsing 
$JsonResponse = $Response.Content | ConvertFrom-Json
$DeviceData = $JsonResponse.value
If ($JsonResponse.'@odata.nextLink')
{
    do {
        $URI = $JsonResponse.'@odata.nextLink'
        $Response = Invoke-WebRequest -Uri $URI -Method Get -Headers $authHeader -UseBasicParsing 
        $JsonResponse = $Response.Content | ConvertFrom-Json
        $DeviceData += $JsonResponse.value
    } until ($null -eq $JsonResponse.'@odata.nextLink')
}

Write-Host "$DeviceData"
$DeviceData
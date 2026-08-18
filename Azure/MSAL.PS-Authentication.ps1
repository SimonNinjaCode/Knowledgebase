#Install-Module MSAL.PS
$ClientId    = '...'
$TenantId    = '...'
   
$Auth = Get-MsalToken -ClientId $ClientId -TenantId $TenantId -Interactive
# Display Token $Auth
$AuthHeader = @{Authorization = $auth.CreateAuthorizationHeader()}

$BaseGraphURI = "https://graph.microsoft.com/beta/users"
$Users = (Invoke-RestMethod -Method Get -Uri $BaseGraphURI -Headers $authHeader -ContentType 'Application/Json').value
$Users | Select-Object id, displayName, userPrincipalName
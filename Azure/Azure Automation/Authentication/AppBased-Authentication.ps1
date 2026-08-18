# App based authentication
$tenant = "TENANT.onmicrosoft.com"
$authority = "https://login.windows.net/$tenant"
$clientId = "COPIED-CLIENT-ID"
$clientSecret = "COPIED-CLIENT-SECRET"

Update-MSGraphEnvironment -AppId $clientId -Quiet
Update-MSGraphEnvironment -AuthUrl $authority -Quiet
Connect-MSGraph -ClientSecret $ClientSecret -Quiet

###################################

# User Account based authentication
$creds = Get-AutomationPSCredential -Name 'CREDENTIAL-NAME' 
Connect-MSGraph -PSCredential $creds

###################################

# OUTPUT
Write-Output 'Get current MSGraph environment parameters'
Get-MSGraphEnvironment

$devices = Get-IntuneManagedDevice | Select-Object -First 2
Write-Output "Found $($devices.Count) devices."
$devices
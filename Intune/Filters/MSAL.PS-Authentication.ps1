#Install-Module MSAL.PS
$authParams = @{
    ClientId    = 'd2d49a7d-1d8c-48a8-b439-c10de5a1530c'
    TenantId    = 'evergr33ndev.onmicrosoft.com'
    DeviceCode  = $false
}
$authToken = Get-MsalToken @authParams
$authToken
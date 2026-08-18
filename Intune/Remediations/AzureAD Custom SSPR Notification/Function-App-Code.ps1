##############################
## Parameters
##############################

using namespace System.Net

# Input bindings are passed in via param block.
param($Request)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

##############################
## Variables
##############################

$TenantID = "Enter Tenant ID"
$ApplicationID = "Enter Application ID"
$AppSecret = 'Enter Secret Value'

##############################
## Functions
##############################

Function Get-MSGraphAuthToken {
    [cmdletbinding()]
    Param(
        [parameter(Mandatory = $true)]
        [pscredential]$Credential,
        [parameter(Mandatory = $true)]
        [string]$tenantID
    )
    
    #Get token
    $AuthUri = "https://login.microsoftonline.com/$TenantID/oauth2/token"
    $Resource = 'graph.microsoft.com'
    $AuthBody = "grant_type=client_credentials&client_id=$($credential.UserName)&client_secret=$($credential.GetNetworkCredential().Password)&resource=https%3A%2F%2F$Resource%2F"

    $Response = Invoke-RestMethod -Method Post -Uri $AuthUri -Body $AuthBody
    If ($Response.access_token) {
        return $Response.access_token
    }
    Else {
        Throw "Authentication failed"
    }
}
Function Invoke-MSGraphQuery {
    [CmdletBinding(DefaultParametersetname = "Default")]
    Param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Default')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Refresh')]
        [string]$URI,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Refresh')]
        [string]$Body,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Refresh')]
        [string]$token,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Refresh')]
        [ValidateSet('GET', 'POST', 'PUT', 'PATCH', 'DELETE')]
        [string]$method = "GET",
    
        [Parameter(Mandatory = $false, ParameterSetName = 'Default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Refresh')]
        [switch]$recursive,
    
        [Parameter(Mandatory = $true, ParameterSetName = 'Refresh')]
        [switch]$tokenrefresh,
    
        [Parameter(Mandatory = $true, ParameterSetName = 'Refresh')]
        [pscredential]$credential,
    
        [Parameter(Mandatory = $true, ParameterSetName = 'Refresh')]
        [string]$tenantID
    )
    $authHeader = @{
        'Accept'        = 'application/json'
        'Content-Type'  = 'application/json'
        'Authorization' = "Bearer $Token"
    }
    
    [array]$returnvalue = $()
    Try {
        If ($body) {
            $Response = Invoke-RestMethod -Uri $URI -Headers $authHeader -Body $Body -Method $method -ErrorAction Stop
        }
        Else {
            $Response = Invoke-RestMethod -Uri $URI -Headers $authHeader -Method $method -ErrorAction Stop
        }
    }
    Catch {
        If (($Error[0].ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue).error.Message -eq 'Access token has expired.' -and $tokenrefresh) {
            $token = Get-MSGraphAuthToken -credential $credential -tenantID $TenantID

            $authHeader = @{
                'Content-Type'  = 'application/json'
                'Authorization' = $Token
            }
            $returnvalue = $()
            If ($body) {
                $Response = Invoke-RestMethod -Uri $URI -Headers $authHeader -Body $Body -Method $method -ErrorAction Stop
            }
            Else {
                $Response = Invoke-RestMethod -Uri $uri -Headers $authHeader -Method $method
            }
        }
        Else {
            Throw $_
        }
    }

    $returnvalue += $Response
    If (-not $recursive -and $Response.'@odata.nextLink') {
        Write-Warning "Query contains more data, use recursive to get all!"
        Start-Sleep 1
    }
    ElseIf ($recursive -and $Response.'@odata.nextLink') {
        If ($PSCmdlet.ParameterSetName -eq 'default') {
            If ($body) {
                $returnvalue += Invoke-MSGraphQuery -URI $Response.'@odata.nextLink' -token $token -body $body -method $method -recursive -ErrorAction SilentlyContinue
            }
            Else {
                $returnvalue += Invoke-MSGraphQuery -URI $Response.'@odata.nextLink' -token $token -method $method -recursive -ErrorAction SilentlyContinue
            }
        }
        Else {
            If ($body) {
                $returnvalue += Invoke-MSGraphQuery -URI $Response.'@odata.nextLink' -token $token -body $body -method $method -recursive -tokenrefresh -credential $credential -tenantID $TenantID -ErrorAction SilentlyContinue
            }
            Else {
                $returnvalue += Invoke-MSGraphQuery -URI $Response.'@odata.nextLink' -token $token -method $method -recursive -tokenrefresh -credential $credential -tenantID $TenantID -ErrorAction SilentlyContinue
            }
        }
    }
    Return $returnvalue
}

##############################
## Scriptstart
##############################

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Setting inital Status Code: 
$StatusCode = [HttpStatusCode]::OK

Write-Output "Request from Device: $($Request.Headers.from)"
$InboundDeviceID= $Request.Body.AzureADDeviceID
$InboundTenantID = $Request.Body.AzureADTenantID

# Write to the Azure Functions log stream.
Write-Information "Inbound DeviceID $($InboundDeviceID)"
Write-Information "Inbound TenantID $($InboundTenantID)"
Write-Information "Environment TenantID $TenantID"

# Verify request comes from correct tenant
if ($TenantID -eq $InboundTenantID) {
    Write-Information "Request is comming from correct tenant"

    #Authenticate to Enterprise Application
    $Credential = New-Object System.Management.Automation.PSCredential($ApplicationID, (ConvertTo-SecureString $AppSecret -AsPlainText -Force))
    $Token = Get-MSGraphAuthToken -credential $Credential -TenantID $TenantID

    # Query graph for device verification 
    $resourceURL = "https://graph.microsoft.com/v1.0/devices?`$filter=deviceId eq '$($InboundDeviceID)'"
    $DeviceIDResponse = Invoke-MSGraphQuery -method GET -URI $resourceURL -token $token
    $DeviceIDResponse = $DeviceIDResponse.Value

    # Assign to variables for matching 
    $DeviceID = $DeviceIDResponse.deviceId  
    $DeviceEnabled = $DeviceIDResponse.accountEnabled    
    Write-Information "DeviceID $DeviceID"   
    Write-Information "DeviceEnabled: $DeviceEnabled"

    # Verify request comes from a valid device
    if ($DeviceID -eq $InboundDeviceID) {
        Write-Information "Request is coming from a valid device in Azure AD"
        if ($DeviceEnabled -eq "True") {
            Write-Information "Requesting device is not disabled in Azure AD"           
        }            

        else {
            Write-Warning "Device is not enabled - Forbidden"
            $StatusCode = [HttpStatusCode]::Forbidden
        }
    }
    else {
        Write-Warning  "Device not in my Tenant - Forbidden"
        $StatusCode = [HttpStatusCode]::Forbidden
    }
}
else {
    Write-Warning "Tenant not allowed - Forbidden"
    $StatusCode = [HttpStatusCode]::Forbidden
}

$userName = $Request.Body.userName

Write-Output "userName from Input: $userName"

$resourceURL = "https://graph.microsoft.com/v1.0/users/$UserName`?`$select=userprincipalname,lastPasswordChangeDateTime"
$User = Invoke-MSGraphQuery -method GET -URI $resourceURL -token $token

$Data = [PSCustomObject]@{
	userprincipalname           = $User.userprincipalname
	lastPasswordChangeDateTime  = $User.lastPasswordChangeDateTime
}

$JSONData = $Data | ConvertTo-Json -Depth 9

$body = $JSONData

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $StatusCode
    Body = $body
})
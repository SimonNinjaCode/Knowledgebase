#Connect-AzureAD
Write-Output 'Logging in...'
$creds = Get-AutomationPSCredential -Name 'AzureADAutomation' 
Connect-AzureAD -Credential $creds

Write-Output "List all Stale Azure AD-Devices..."
$deletionTresholdDays = 160
$deletionTreshold= (Get-Date).AddDays(-$deletionTresholdDays)
$allDevices=Get-AzureADDevice -All:$true | Where-Object-Object-Object {$_.ApproximateLastLogonTimeStamp -le $deletionTreshold} | Where-Object {$_.ApproximateLastLogonTimeStamp -ne $null} `
| Where-Object-Object {$_.DeviceOSType -ne "Windows Server 2019 Datacenter"} | Where-Object {$_.DeviceOSType -ne "Windows Server 2016 Standard"}

$allDevices | Select-Object -Property DisplayName, ObjectId, ApproximateLastLogonTimeStamp, DeviceOSType, DeviceOSVersion, IsCompliant, IsManaged `
| Write-Output $allDevices

# replace with your application ID
$client_id = Get-AutomationVariable -Name 'AzureSendMail-ID'
# replace with your secret key
$client_secret = Get-AuutomationVariable -Name 'AzureSendMail-Secret'
# replace with your tenant ID
$tenant_id = Get-AutomationVariable -Name 'TenantID'

# DO NOT CHANGE ANYTHING BELOW THIS LINE
$request = @{
        Method = 'POST'
        URI    = "https://login.microsoftonline.com/$tenant_id/oauth2/v2.0/token"
        body   = @{
            grant_type    = "client_credentials"
            scope         = "https://graph.microsoft.com/.default"
            client_id     = $client_id
            client_secret = $client_secret
        }
    }
# Get the access token
$token = (Invoke-RestMethod @request).access_token
# view the token value
$token

# Provide the sender and recipient email address
$fromAddress = 'RFC8314@evergr33n.onmicrosoft.com'
$toAddress = 'simon@evergr33n.onmicrosoft.com'

# Specify the email subject and the message
$mailSubject = "Stale-AzureAD-Devices-Report"
$mailMessage = 'This is a test message from Azure via Microsoft Graph API'

# DO NOT CHANGE ANYTHING BELOW THIS LINE
# Build the Microsoft Graph API request
$params = @{
  "URI"         = "https://graph.microsoft.com/v1.0/users/$fromAddress/sendMail"
  "Headers"     = @{
    "Authorization" = ("Bearer {0}" -F $token)
  }
  "Method"      = "POST"
  "ContentType" = 'application/json'
  "Body" = (@{
    "message" = @{
      "subject" = $mailSubject
      "body"    = @{
        "contentType" = 'Text'
        "content"     = $mailMessage
      }
      "toRecipients" = @(
        @{
          "emailAddress" = @{
            "address" = $toAddress
          }
        }
      )
    }
  }) | ConvertTo-JSON -Depth 10
}

# Send the message
Invoke-RestMethod @params -Verbose
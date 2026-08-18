# replace with your application ID
$client_id = Get-AutomationVariable -Name '...'
# replace with your secret key
$client_secret = Get-AutomationVariable -Name '...'
# replace with your tenant ID
$tenant_id = Get-AutomationVariable -Name '...'

# Provide the sender and recipient email address
$fromAddress = '...'
$toAddress = '...'

# Specify the email subject and the message
$mailSubject = '...'
$mailMessage = '...'

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
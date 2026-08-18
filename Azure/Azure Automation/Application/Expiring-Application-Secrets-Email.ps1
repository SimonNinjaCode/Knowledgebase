$AppID = Get-AutomationVariable -Name 'AppID' 
$TenantID = Get-AutomationVariable -Name 'TenantID'
$AppSecret = Get-AutomationVariable -Name 'AppSecret'  

[int32] $expirationDays = 90
[string] $emailSender = "Testuser@Evergr33ndev.onmicrosoft.com"
[string] $emailTo = "Testuser@Evergr33ndev.onmicrosoft.com"

Function Connect-MSGraphAPI {
    param (
        [system.string]$AppID,
        [system.string]$TenantID,
        [system.string]$AppSecret
    )
    begin {
        $URI = "https://login.microsoftonline.com/$TenantID/oauth2/v2.0/token"
        $ReqTokenBody = @{
            Grant_Type    = "client_credentials"
            Scope         = "https://graph.microsoft.com/.default"
            client_Id     = $AppID
            Client_Secret = $AppSecret
        } 
    }
    Process {
        Write-Host "Connecting to the Graph API"
        $Response = Invoke-RestMethod -Uri $URI -Method POST -Body $ReqTokenBody
    }
    End {
        $Response
    }
}

Function Get-MSGraphRequest {
    param (
        [system.string]$Uri,
        [system.string]$AccessToken
    )
    begin {
        [array]$allPages = @()
        $ReqTokenBody = @{
            Headers = @{
                "Content-Type"  = "application/json"
                "Authorization" = "Bearer $($AccessToken)"
            }
            Method  = "Get"
            Uri     = $Uri
        }
    }
    process {
        do {
            $data = Invoke-RestMethod @ReqTokenBody
            $allpages += $data.value
            if ($data.'@odata.nextLink') {
                $ReqTokenBody.Uri = $data.'@odata.nextLink'
            }
        } until (!$data.'@odata.nextLink')
    }
    end {
        $allPages
    }
}

Function Send-MSGraphEmail {
    param (
        [system.string]$Uri,
        [system.string]$AccessToken,
        [system.string]$To,
        [system.string]$Subject = "Important! Expiring Azure Application Secrets!",
        [system.string]$Body
    )
    begin {
        $headers = @{
            "Authorization" = "Bearer $($AccessToken)"
            "Content-type"  = "application/json"
        }

        $BodyJsonsend = @"
{
   "message": {
   "subject": "$Subject",
   "body": {
      "contentType": "HTML",
      "content": "$($Body)"
   },
   "toRecipients": [
      {
      "emailAddress": {
      "address": "$to"
          }
      }
   ],
   "importance": "high"
   },
   "saveToSentItems": "true"
}
"@
    }
    process {
        $data = Invoke-RestMethod -Method POST -Uri $Uri -Headers $headers -Body $BodyJsonsend
    }
    end {
        $data
    }
}

$tokenResponse = Connect-MSGraphAPI -AppID $AppID -TenantID $TenantID -AppSecret $AppSecret

$array = @()
$apps = Get-MSGraphRequest -AccessToken $tokenResponse.access_token -Uri "https://graph.microsoft.com/v1.0/applications/" 
foreach ($app in $apps) {
    $app.passwordCredentials | foreach-object {
        #If there is a secret with a enddatetime, we need to get the expiration of each one
        if ($_.endDateTime -ne $null) {
            [system.string]$secretdisplayName = $_.displayName
            [system.string]$id = $app.id
            [system.string]$displayname = $app.displayName
            $Date = [TimeZoneInfo]::ConvertTimeBySystemTimeZoneId($_.endDateTime, 'Central Standard Time')
            [int32]$daysUntilExpiration = (New-TimeSpan -Start ([System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::Now, "Central Standard Time")) -End $Date).Days
            
            if (($daysUntilExpiration -ne $null) -and ($daysUntilExpiration -le $expirationDays)) {
                $array += $_ | Select-Object @{
                    name = "id"; 
                    expr = { $id } 
                }, 
                @{
                    name = "Application Name"; 
                    expr = { $displayName } 
                }, 
                @{
                    name = "Secret Name"; 
                    expr = { $secretdisplayName } 
                },
                @{
                    name = "Days Until Expiration"; 
                    expr = { $daysUntilExpiration } 
                }
            }
            $daysUntilExpiration = $null
            $secretdisplayName = $null
        }
    }
}

if ($array -ne 0) {
    Write-Output "Sending email..."
    $textTable = $array | Sort-Object daysUntil | Select-Object 'Application Name', 'Secret Name', 'Days Until Expiration' | ConvertTo-Html -Fragment
    Send-MSGraphEmail -Uri "https://graph.microsoft.com/v1.0/users/$emailSender/sendMail" -AccessToken $tokenResponse.access_token -To $emailTo -Body $textTable 
    Write-Output "Done! Email sent!"
}
else {
    Write-Output "No applications with expiring secrets found!"
}
##############################
## Parameters
##############################
 
##############################
## Variables
##############################
 
$FunctionURL = "https://intune-custom-sspr-notification.azurewebsites.net/api/Intune-Custom-SSPR-Notification?code=8ukw4YYbgLtkFmC0CC-SYsGdLf63YxQO4j0J1myzNo_XAzFu55VRmA=="
 
$PasswordExpirationDays = 1
 
$WindirTemp = Join-Path $Env:Windir -Childpath "Temp"
$UserTemp = $Env:Temp
$UserContext = [Security.Principal.WindowsIdentity]::GetCurrent()
 
Switch ($UserContext) {
    { $PSItem.Name -Match       "System"    } { Write-Output "Running as System"  ; $Temp =  $UserTemp   }
    { $PSItem.Name -NotMatch    "System"    } { Write-Output "Not running System" ; $Temp =  $WindirTemp }
    Default { Write-Output "Could not translate Usercontext" }
}
 
$logfilename = "PasswordNotificationDS"
$logfile = Join-Path $Temp -Childpath "$logfilename.log"
 
$LogfileSizeMax = 100
 
##############################
## Functions
##############################
function Get-AzureADDeviceID {
    <#
    .SYNOPSIS
        Get the Azure AD device ID from the local device.
    
    .DESCRIPTION
        Get the Azure AD device ID from the local device.
    
    .NOTES
        Author:      Nickolaj Andersen
        Contact:     @NickolajA
        Created:     2021-05-26
        Updated:     2021-05-26
    
        Version history:
        1.0.0 - (2021-05-26) Function created
    #>
	Process {
		# Define Cloud Domain Join information registry path
		$AzureADJoinInfoRegistryKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\CloudDomainJoin\JoinInfo"
		
		# Retrieve the child key name that is the thumbprint of the machine certificate containing the device identifier guid
		$AzureADJoinInfoThumbprint = Get-ChildItem -Path $AzureADJoinInfoRegistryKeyPath | Select-Object -ExpandProperty "PSChildName"
		if ($AzureADJoinInfoThumbprint -ne $null) {
			# Retrieve the machine certificate based on thumbprint from registry key
			$AzureADJoinCertificate = Get-ChildItem -Path "Cert:\LocalMachine\My" -Recurse | Where-Object { $PSItem.Thumbprint -eq $AzureADJoinInfoThumbprint }
			if ($AzureADJoinCertificate -ne $null) {
				# Determine the device identifier from the subject name
				$AzureADDeviceID = ($AzureADJoinCertificate | Select-Object -ExpandProperty "Subject") -replace "CN=", ""
				# Handle return value
				return $AzureADDeviceID
			}
		}
	}
} #endfunction 
 
##############################
## Scriptstart
##############################
 
If ($logfilename) {
    If (((Get-Item -ErrorAction SilentlyContinue $logfile).length / 1MB) -gt $LogfileSizeMax) { Remove-Item $logfile -Force }
    Start-Transcript $logfile -Append | Out-Null
    Get-Date
}
 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
 
Try {
    $LoggedSID = Get-WmiObject -Class win32_computersystem | Select-Object -ExpandProperty Username | ForEach-Object { ([System.Security.Principal.NTAccount]$_).Translate([System.Security.Principal.SecurityIdentifier]).Value }
}
Catch {
    Write-Error -Message "Failed to gather SID for current user" -ErrorAction Stop
}
 
Try {
    $CurrentAzureADUser = (Get-ItemProperty -ErrorAction SilentlyContinue -Path "HKLM:\SOFTWARE\Microsoft\IdentityStore\Cache\$LoggedSID\IdentityCache\$LoggedSID" -Name UserName).UserName
}
Catch {
    Write-Error -Message "Failed to gather CurrentAzureADUser" -ErrorAction Stop
}
 
If (!($CurrentAzureADUser)) { Write-Output "Failed to gather CurrentAzureADUser, Exiting" ; Exit 0 }
 
$UserName   = $CurrentAzureADUser
$AADTenantID = (Get-ChildItem -Path "HKLM:\SYSTEM\CurrentControlSet\Control\CloudDomainJoin\TenantInfo\" | Select-Object PSChildName).PSChildName
$AADDeviceID = Get-AzureADDeviceID
 
$Data = [PSCustomObject]@{
	AzureADTenantID = $AADTenantID
	AzureADDeviceID = $AADDeviceID
	UserName = $UserName
}
 
$JSONData = $Data | ConvertTo-Json -Depth 9
 
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")
 
try {
	$Response = Invoke-RestMethod $FunctionURL -Method 'POST' -Headers $headers -Body $JSONData
	$Output = "OK " + $Response
} 
catch {
	$Response = "Error Code: $($_.Exception.Response.StatusCode.value__)"
	$ResponseException = $_.Exception.Message
	$Output = $Response + " $ResponseException"
}
 
Write-Output $Output
$User = $Response
 
[datetime]$lastpasswordChange = $User.lastPasswordChangeDateTime -replace "T", " " -replace "Z",""
 
$PasswordExpirationDate = ($lastpasswordChange).AddDays($PasswordExpirationDays)
 
$StartDate  = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
 
$TimeSpan = New-Timespan -Start $StartDate -End $PasswordExpirationDate
 
If (($TimeSpan.Days -le 10) -and ($TimeSpan.Days -ge -5)) {
    Write-Output "Password Expires after $($TimeSpan.Days) days"
    Exit 1
}
 
If ($logfilename) {
    Stop-Transcript | Out-Null
}
 
Exit 0
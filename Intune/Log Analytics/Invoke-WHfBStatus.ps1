#region functions
# Function to create the authorization signature
Function Build-Signature ($customerId, $sharedKey, $date, $contentLength, $method, $contentType, $resource)
{
    $xHeaders = "x-ms-date:" + $date
    $stringToHash = $method + "`n" + $contentLength + "`n" + $contentType + "`n" + $xHeaders + "`n" + $resource

    $bytesToHash = [Text.Encoding]::UTF8.GetBytes($stringToHash)
    $keyBytes = [Convert]::FromBase64String($sharedKey)

    $sha256 = New-Object System.Security.Cryptography.HMACSHA256
    $sha256.Key = $keyBytes
    $calculatedHash = $sha256.ComputeHash($bytesToHash)
    $encodedHash = [Convert]::ToBase64String($calculatedHash)
    $authorization = 'SharedKey {0}:{1}' -f $customerId,$encodedHash
    return $authorization
}
# Function to create and post the request
Function Post-LogAnalyticsData($customerId, $sharedKey, $body, $logType)
{
    $method = "POST"
    $contentType = "application/json"
    $resource = "/api/logs"
    $rfc1123date = [DateTime]::UtcNow.ToString("r")
    $contentLength = $body.Length
    $signature = Build-Signature `
        -customerId $customerId `
        -sharedKey $sharedKey `
        -date $rfc1123date `
        -contentLength $contentLength `
        -method $method `
        -contentType $contentType `
        -resource $resource
    $uri = "https://" + $customerId + ".ods.opinsights.azure.com" + $resource + "?api-version=2016-04-01"

    $headers = @{
        "Authorization" = $signature;
        "Log-Type" = $logType;
        "x-ms-date" = $rfc1123date;
        "time-generated-field" = $TimeStampField;
    }

    $response = Invoke-WebRequest -Uri $uri -Method $method -ContentType $contentType -Headers $headers -Body $body -UseBasicParsing
    return $response.StatusCode

}
#endregion functions

#region script
#region initialize
# Replace with your Workspace ID
$CustomerId = ""  

# Replace with your Primary Key
$SharedKey = ""

# You can use an optional field to specify the timestamp from the data. If the time field is not specified, Azure Monitor assumes the time is the message ingestion time
$TimeStampField = ""

#endregion initialize
$WHFBLOG = "WindowsHelloLogs"
#region WINDOWSHELLOLOGS
#Set Name of Log

#Get Intune DeviceID and ManagedDeviceName
if(@(Get-ChildItem HKLM:SOFTWARE\Microsoft\Enrollments\ -Recurse | Where-Object {$_.PSChildName -eq 'MS DM Server'}))
{
  $MSDMServerInfo = Get-ChildItem HKLM:SOFTWARE\Microsoft\Enrollments\ -Recurse | Where-Object {$_.PSChildName -eq 'MS DM Server'}
  $ManagedDeviceInfo = Get-ItemProperty -LiteralPath "Registry::$($MSDMServerInfo)"
}
$ManagedDeviceName = $ManagedDeviceInfo.EntDeviceName
$ManagedDeviceID = $ManagedDeviceInfo.EntDMID

#Get the AzureAD Device ID
$command = (dsregcmd.exe /status) | Select-String ("DeviceID : ")
$output = $command.ToString().trim() -split " : "
$AADDeviceID = $output[1]

#Collect DSREGCMDStatus and turn it into a PSOBject    
$dsregcmd = dsregcmd /status
$o = New-Object -TypeName PSObject
foreach($line in $dsregcmd){
    if($line -like "| *"){
      if(-not [String]::IsNullOrWhiteSpace($currentSection) -and $null -ne $so){
       Add-Member -InputObject $o -MemberType NoteProperty -Name $currentSection -Value $so -ErrorAction SilentlyContinue
      }
      $currentSection = $line.Replace("|","").Replace(" ","").Trim()
      $so = New-Object -TypeName PSObject
     } elseif($line -match " *[A-z]+ : [A-z0-9\{\}]+ *"){
      Add-Member -InputObject $so -MemberType NoteProperty -Name (([String]$line).Trim() -split " : ")[0] -Value (([String]$line).Trim() -split " : ")[1] -ErrorAction SilentlyContinue
     }
    }
    if(-not [String]::IsNullOrWhiteSpace($currentSection) -and $null -ne $so){
        Add-Member -InputObject $o -MemberType NoteProperty -Name $currentSection -Value $so -ErrorAction SilentlyContinue
    }
    #return $o
    
#Collect the relevant WHfB-information based on the status of the PSOBject on each property    
$TPMProtected = $o.DeviceDetails.TpmProtected   
$DeviceAuth = $o.DeviceDetails.DeviceAuthStatus    
$WHFBKeySet = $O.UserState.NGCSet
$WHFBKeyId = $O.UserState.NGCID
$DeviceAADjoined = $o.NgcPrerequisiteCheck.IsDeviceJoined
$UserAADpresent = $o.NgcPrerequisiteCheck.IsUserAzureAD
$WHfBPolicyStatus = $o.NgcPrerequisiteCheck.PolicyEnabled 
$WHfBNativeTrigger = $o.NgcPrerequisiteCheck.PostLogonEnabled
$DeviceHWReq = $o.NgcPrerequisiteCheck.DeviceEligible
$UserRemote = $o.NgcPrerequisiteCheck.SessionIsNotRemote
$EnrollmentAuthority = $o.NgcPrerequisiteCheck.CertEnrollment
$CertTrustADFSToken = $o.NgcPrerequisiteCheck.AdfsRefreshToken
$ADFSRALogonTemplate = $o.NgcPrerequisiteCheck.AdfsRaIsReady
$TroubleshootADFSRA = $o.NgcPrerequisiteCheck.LogonCertTemplateReady
$PrereqResult = $o.NgcPrerequisiteCheck.PreReqResult

#Build Inventory
$Inventory = New-Object System.Object
$Inventory | Add-Member -MemberType NoteProperty -Name "ManagedDeviceName" -Value "$ManagedDeviceName" -Force   
$Inventory | Add-Member -MemberType NoteProperty -Name "ManagedDeviceID" -Value "$ManagedDeviceID" -Force   
$Inventory | Add-Member -MemberType NoteProperty -Name "AADDeviceID" -Value "$AADDeviceID" -Force
$Inventory | Add-Member -MemberType NoteProperty -Name "TPMProtected" -Value "$TPMProtected" -Force
$Inventory | Add-Member -MemberType NoteProperty -Name "DeviceAuth" -Value "$DeviceAuth" -Force
$Inventory | Add-Member -MemberType NoteProperty -Name "WHFBKeySet" -Value "$WHFBKeySet" -Force
$Inventory | Add-Member -MemberType NoteProperty -Name "WHFBKeyId " -Value "$WHFBKeyId " -Force
$Inventory | Add-Member -MemberType NoteProperty -Name "DeviceAADjoined" -Value "$DeviceAADjoined" -Force
$Inventory | Add-Member -MemberType NoteProperty -Name "UserAADpresent" -Value "$UserAADpresent" -Force
$Inventory | Add-Member -MemberType NoteProperty -Name "WHfBPolicyStatus" -Value "$WHfBPolicyStatus" -Force
$Inventory | Add-Member -MemberType NoteProperty -Name "WHfBNativeTrigger" -Value "$WHfBNativeTrigger" -Force
$Inventory | Add-Member -MemberType NoteProperty -Name "DeviceHWReq" -Value "$DeviceHWReq" -Force
$Inventory | Add-Member -MemberType NoteProperty -Name "UserRemote" -Value "$UserRemote" -Force
$Inventory | Add-Member -MemberType NoteProperty -Name "EnrollmentAuthority" -Value "$EnrollmentAuthority" -Force
$Inventory | Add-Member -MemberType NoteProperty -Name "CertTrustADFSToken" -Value "$CertTrustADFSToken" -Force
$Inventory | Add-Member -MemberType NoteProperty -Name "ADFSRALogonTemplate" -Value "$ADFSRALogonTemplate" -Force
$Inventory | Add-Member -MemberType NoteProperty -Name "PrereqResult" -Value "$PrereqResult" -Force

$json = $Inventory | ConvertTo-Json

# Submit the data to the API endpoint
Post-LogAnalyticsData -customerId $customerId -sharedKey $sharedKey -body ([System.Text.Encoding]::UTF8.GetBytes($json)) -logType $WHFBLOG | Out-Null
#endregion DEVICEINVENTORY

#endregion APPINVENTORY
$date = get-date -Format "dd-MM HH:mm"
Write-Output "Inventory Updated $date"
Exit 0
#endregion script
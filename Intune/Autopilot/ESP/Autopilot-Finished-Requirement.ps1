#Alternative 1
$ProcessActive = Get-Process "WWAHost" -ErrorAction silentlycontinue
$CheckNull = $null -eq $ProcessActive 
$CheckNull

# Boolean
# True

#Alternative 2
$ESPProcesses = Get-Process -Name 'CloudExperienceHostBroker' -ErrorAction 'SilentlyContinue'

if ($ESPProcesses.Count -gt 0) {
    Write-Host 'ESP is running.'
    exit 1
}
else {
    Write-Host 'ESP is not running.'
    exit 0
}

#Alternative 3 - Time Based
$AppInstallDelay = New-TimeSpan -Days 0 -Hours 1 -Minutes 0

$ime = Get-Item "C:\Program Files (x86)\Microsoft Intune Management Extension"  | select Name,CreationTime 
$EnrolmentDate = $ime.creationtime
$futuredate = $EnrolmentDate + $AppInstallDelay

#checking date and futuredate
$outcome = ((Get-Date) -ge ($futuredate))
$outcome
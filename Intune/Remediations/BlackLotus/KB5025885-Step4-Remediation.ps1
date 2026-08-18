<# 
    KB5025885 Remediation Script-Intune
    Step 4 of 4 — Apply the SVN update to the firmware
    Version: 25.09.25

    Sets AvailableUpdates to 0x200 and starts the Secure-Boot-Update scheduled
    task. The firmware SVN is updated on the next reboot.

    Reference: https://support.microsoft.com/en-us/topic/kb5025885
#>

function Set-PendingUpdate {
    # Set the registry key to indicate a pending update
    $RebootRequiredPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"
    if (-not (Test-Path $RebootRequiredPath)) {New-Item -Path $RebootRequiredPath -Force | Out-Null}
    # Create a value to indicate a pending update
    New-ItemProperty -Path $RebootRequiredPath -Name "UpdatePending" -Value 1 -PropertyType DWord -Force | Out-Null

    # Set the orchestrator key
    $OrchestratorPath = "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator"
    if (-not (Test-Path $OrchestratorPath)) {New-Item -Path $OrchestratorPath -Force | Out-Null}
    $Values = get-item -Path $OrchestratorPath
    if (($Null -eq $Values.GetValue('ShutdownFlyoutOptions')) -or ($Values.GetValue('ShutdownFlyoutOptions') -eq 0)){
        New-ItemProperty -Path $OrchestratorPath -Name "ShutdownFlyoutOptions" -Value 10 -PropertyType DWord -Force | Out-Null
    }
    if (($Null -eq $Values.GetValue('EnhancedShutdownEnabled')) -or ($Values.GetValue('EnhancedShutdownEnabled') -eq 0)){
        New-ItemProperty -Path $OrchestratorPath -Name "EnhancedShutdownEnabled" -Value 1 -PropertyType DWord -Force | Out-Null
    }

    $RebootDowntimePath = "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\RebootDowntime"
    if (-not (Test-Path $RebootDowntimePath)) {New-Item -Path $RebootDowntimePath -Force | Out-Null}
    $Values = get-item -Path $RebootDowntimePath
    if (($Null -eq $Values.GetValue('DowntimeEstimateHigh')) -or ($Values.GetValue('DowntimeEstimateHigh') -eq 0)){
        New-ItemProperty -Path $RebootDowntimePath -Name "DowntimeEstimateHigh" -Value 1 -PropertyType DWord -Force | Out-Null
    }
    if (($Null -eq $Values.GetValue('DowntimeEstimateLow')) -or ($Values.GetValue('DowntimeEstimateLow') -eq 0)){
        New-ItemProperty -Path $RebootDowntimePath -Name "DowntimeEstimateLow" -Value 1 -PropertyType DWord -Force | Out-Null
    }
}

Function Get-SecureBootUpdateSTaskStatus {
    [CmdletBinding()]
    param ()
    $taskName = "Secure-Boot-Update"
    $Task = Get-ScheduledTask -TaskName $TaskName
    if ($null -eq $Task) {
        Write-Verbose "Scheduled Task '$TaskName' not found."
        return $null
    }
    $TaskHistory = Get-ScheduledTaskInfo -InputObject $Task
    $LastRunTime = $TaskHistory.LastRunTime
    $LastTaskResult = $TaskHistory.LastTaskResult
    if ($TaskHistory.LastTaskResult -eq 0) {
        $LastTaskResultDescription = "Successfully completed"
    }
    elseif ($TaskHistory.LastTaskResult -eq 2147942750) {
        $LastTaskResultDescription = "No action was taken as a system reboot is required."
    }
    elseif ($TaskHistory.LastTaskResult -eq 2147946825) {
        $LastTaskResultDescription = "Secure Boot is not enabled on this machine."
    }
    else {
        $LastTaskResultDescription = "Unknown error"
    }
    [PSCustomObject]@{
        TaskName            = $TaskName
        LastRunTime         = $LastRunTime
        LastTaskResult      = $LastTaskResult
        LastTaskDescription = $LastTaskResultDescription
    }
}

#Region Applicability
$CurrentOSInfo = Get-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
$Build = $CurrentOSInfo.GetValue('CurrentBuild')
[int]$UBR = $CurrentOSInfo.GetValue('UBR')

#July 2025 UBRs
$JulyPatch = @('19045.6093','22621.5624','22631.5624','26100.4652','26200.4652')
$MatchedPatch = $JulyPatch | Where-Object {$_ -match $Build}
if ($null -eq $MatchedPatch){
    Write-Output "The OS ($Build.$UBR) is not supported for this remediation."
    Write-Error "Exit 5 - OS Version not supported"
    exit 5
}
[int]$MatchedUBR = $MatchedPatch.split(".")[1]

if ($UBR -ge $MatchedUBR){
    #$OSSupported = $true
}
else {
    #$OSSupported = $false
    Write-Output "The OS ($Build.$UBR) is not supported for this remediation."
    exit 5
}
if (Confirm-SecureBootUEFI -ErrorAction SilentlyContinue) {
    #This is required for remediation to work
}
else {
    Write-Output "Secure Boot is not enabled."
    exit 4
}
#endregion Applicability

$SecureBootRegPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot'
$RemediationRegPath = 'HKLM:\SOFTWARE\Remediation\KB5025885'
if (-not (Test-Path -Path $RemediationRegPath)){
    New-Item -Path $RemediationRegPath -Force -ItemType Directory | Out-Null
}

#region Test if Remediation is already applied for each Step
#Test: Applying the DB update
$Step1Complete = [System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI db).bytes) -match 'Windows UEFI CA 2023'

#Test: Updating the boot manager
$Volume = Get-Volume | Where-Object {$_.FileSystemType -eq "FAT32" -and $_.DriveType -eq "Fixed"}
$SystemDisk = Get-Disk | Where-Object {$_.IsSystem -eq $true}
$SystemPartition = Get-Partition -DiskNumber $SystemDisk.DiskNumber | Where-Object {$_.IsSystem -eq $true}  
$SystemVolume = $Volume | Where-Object {$_.UniqueId -match $SystemPartition.Guid}
$FilePath = "$($SystemVolume.Path)\EFI\Microsoft\Boot\bootmgfw.efi"
$CertCollection = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
$CertCollection.Import($FilePath, $null, 'DefaultKeySet')
If ($CertCollection.Subject -like "*Windows UEFI CA 2023*") {$Step2Complete = $true}
else {$Step2Complete = $false}

#Test: Applying the DBX update
$Step3Complete = [System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI dbx).bytes) -match 'Microsoft Windows Production PCA 2011'

#endregion Test if Remediation is already applied for each Step

#region Remediation

# If the Secure-Boot-Update task is already waiting for a reboot, just nudge the reboot
if ((Get-SecureBootUpdateSTaskStatus).LastTaskResult -eq 2147942750){
    Write-Output "Secure Boot Update Task is already waiting for a reboot"
    Set-PendingUpdate
    exit 0
}

# Step 4 already complete
$Step4Success = (Get-Item -Path $RemediationRegPath -ErrorAction SilentlyContinue).GetValue('Step4Success')
if ($Step4Success -eq 1){
    Write-Output "Step 4 SVN firmware update already applied."
    exit 0
}

# Dependency check — Steps 1-3 must be complete
if ($Step1Complete -ne $true){
    Write-Output "Dependency not met | Step 1 - 2023 Cert Not Found in DB"
    exit 2
}
if ($Step2Complete -ne $true){
    Write-Output "Dependency not met | Step 2 - Boot Manager Not Updated"
    exit 2
}
if ($Step3Complete -ne $true){
    Write-Output "Dependency not met | Step 3 - DBX update not applied"
    exit 2
}

# Apply Step 4 — SVN firmware update
Write-Output "Applying remediation | Setting Secure Boot Key to 0x200 for SVN firmware update"
New-ItemProperty -Path $SecureBootRegPath -Name "AvailableUpdates" -PropertyType dword -Value 0x200 -Force | Out-Null
Start-Sleep -Seconds 1
Start-ScheduledTask -TaskName "\Microsoft\Windows\PI\Secure-Boot-Update"
Start-Sleep -Seconds 1

# Track remediation timestamp
$DetectionTime = Get-Date -Format "yyyyMMddHHmmss"
New-ItemProperty -Path $RemediationRegPath -Name "Step4Set0x200" -PropertyType String -Value $DetectionTime -Force | Out-Null

# Signal reboot required
Set-PendingUpdate
Write-Output "Step 4 SVN firmware update applied. Reboot required."

#endregion Remediation

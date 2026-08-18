<# 
    KB5025885 Detection Script-Intune
    Step 4 of 4 — Apply the SVN update to the firmware
    Version: 25.09.25

    After the July 9 2024 updates, the Secure Version Number (SVN) is incremented
    in both the Boot Manager and the firmware. Setting AvailableUpdates to 0x200
    triggers the firmware SVN update via the Secure-Boot-Update scheduled task.
    Once applied and rebooted, the 0x200 bit is consumed (cleared).

    Reference: https://support.microsoft.com/en-us/topic/kb5025885
#>

#Test if Remediation is applicable
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
$SecureBootKey = Get-Item -Path $SecureBootRegPath
$SecureBootRegValue = $SecureBootKey.GetValue("AvailableUpdates")
$RemediationRegPath = 'HKLM:\SOFTWARE\Remediation\KB5025885'
if (Test-Path -Path $RemediationRegPath){
    $Key = Get-Item -Path $RemediationRegPath
    $Step4Success = ($Key).GetValue('Step4Success')
    $Step4Set0x200 = ($Key).GetValue('Step4Set0x200')
}
else{
    New-Item -Path $RemediationRegPath -Force -ItemType Directory | Out-Null
}

$Last9Reboots = (Get-WinEvent -LogName System -MaxEvents 10 -FilterXPath "*[System[EventID=6005]]" | Select-Object -Property TimeCreated).TimeCreated

if ($null -ne $Step4Set0x200){
    $Step4Set0x200DateTime = [System.DateTime]::ParseExact($Step4Set0x200, "yyyyMMddHHmmss", $null)
}
else{
    $Step4Set0x200DateTime = Get-Date
}
$CountOfRebootsSinceRemediation = ($Last9Reboots | Where-Object {$_ -gt $Step4Set0x200DateTime}).Count

if ($null -ne $Step4Success){
    if ($Step4Success -eq 1){
        $Step4Success = $true
    }
    else {
        $Step4Success = $false
    }
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

#Test: SVN firmware update applied
# After 0x200 is set and consumed by the Secure-Boot-Update task + reboot, the bit is cleared
$Step4Complete = $false
if ($null -ne $Step4Set0x200 -and $null -ne $SecureBootRegValue){
    $Step4Complete = (($SecureBootRegValue -band 0x200) -eq 0)
}

#endregion Test if Remediation is already applied for each Step

#region Remediation
# All 4 steps complete and tracked
if ($Step4Success -eq $true -and $Step4Complete -eq $true -and $Step1Complete -eq $true -and $Step2Complete -eq $true -and $Step3Complete -eq $true){
    Write-Output "Step 4 Complete | SBKey: $SecureBootRegValue"
    exit 0
}
# Steps 1-3 done, Step 4 consumed + rebooted — stamp success
if ($Step1Complete -eq $true -and $Step2Complete -eq $true -and $Step3Complete -eq $true -and $Step4Complete -eq $true -and $CountOfRebootsSinceRemediation -ge 1){
    Write-Output "Step 4 Complete | SBKey: $SecureBootRegValue"
    if ($Null -eq $Step4Success){
        New-ItemProperty -Path $RemediationRegPath -Name "Step4Success" -PropertyType dword -Value 1 -Force | Out-Null
    }
    exit 0
}
# Steps 1-3 done, 0x200 set but needs reboot
if ($Step1Complete -eq $true -and $Step2Complete -eq $true -and $Step3Complete -eq $true -and $Step4Complete -ne $true -and $null -ne $Step4Set0x200 -and $CountOfRebootsSinceRemediation -lt 1){
    Write-Output "Step 4 applied, pending reboot | SBKey: $SecureBootRegValue"
    exit 1
}
# Dependency checks
if ($Step1Complete -ne $true){
    Write-Output "Dependency not complete | Step 1 - 2023 Cert Not Found in DB: Needs Remediation | SBKey: $SecureBootRegValue"
    exit 2
}
if ($Step2Complete -ne $true){
    Write-Output "Dependency not complete | Step 2 - Boot Manager Not Updated: Needs Remediation | SBKey: $SecureBootRegValue"
    exit 2
}
if ($Step3Complete -ne $true){
    Write-Output "Dependency not complete | Step 3 - DBX update not applied: Needs Remediation | SBKey: $SecureBootRegValue"
    exit 2
}
# Steps 1-3 complete but Step 4 not yet applied
if ($Step4Complete -ne $true){
    Write-Output "Step 4 - SVN firmware update: Needs Remediation | SBKey: $SecureBootRegValue"
    exit 1
}
#endregion Remediation

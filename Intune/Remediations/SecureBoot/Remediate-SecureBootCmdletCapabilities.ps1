#Requires -Version 5.1
<#
.SYNOPSIS
    Intune Proactive Remediation - Remediation Script
    Best-effort remediation for missing Secure Boot cmdlet capabilities.

.DESCRIPTION
    When detection identifies missing support for:
      1) Get-SecureBootUEFI -Decoded
      2) Get-SecureBootSVN

    this script performs a best-effort Windows Update trigger and logs guidance.
    It does not force install or reboot.

.EXITCODES
    0 = Remediation actions completed (best-effort trigger + guidance output)
    1 = Script execution failure

.NOTES
    Reference:
    - https://support.microsoft.com/en-us/topic/february-24-2026-kb5077241-os-builds-26200-7922-and-26100-7922-preview-b8cc7bc8-d640-4f18-9437-3ee59298b970
    Revision: 1.0 - 2026-03-12
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Test-DecodedSupport {
    param (
        [System.Management.Automation.CommandInfo]$Command
    )

    if ($null -eq $Command) {
        return $false
    }

    return $Command.Parameters.ContainsKey("Decoded")
}

function Invoke-BestEffortUpdateScan {
    $actions = @()

    $usoclientPath = Join-Path $env:WINDIR "System32\UsoClient.exe"
    if (Test-Path $usoclientPath) {
        try {
            Start-Process -FilePath $usoclientPath -ArgumentList "StartScan" -WindowStyle Hidden -ErrorAction Stop
            $actions += "UsoClient:StartScan:Triggered"
        }
        catch {
            $actions += "UsoClient:StartScan:Failed:$($_.Exception.Message)"
        }
    }
    else {
        $actions += "UsoClient:NotFound"
    }

    try {
        $au = New-Object -ComObject "Microsoft.Update.AutoUpdate"
        $au.DetectNow()
        $actions += "AutoUpdate:DetectNow:Triggered"
    }
    catch {
        $actions += "AutoUpdate:DetectNow:Failed:$($_.Exception.Message)"
    }

    return ($actions -join ",")
}

try {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
    $build = [int]$os.BuildNumber
    $ubr = 0
    try {
        $cv = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -ErrorAction Stop
        if ($cv.PSObject.Properties.Name -contains "UBR") {
            $ubr = [int]$cv.UBR
        }
    }
    catch {
        $ubr = 0
    }

    $cmdUefi = Get-Command -Name "Get-SecureBootUEFI" -ErrorAction SilentlyContinue
    $cmdSvn = Get-Command -Name "Get-SecureBootSVN" -ErrorAction SilentlyContinue

    $decodedSupported = Test-DecodedSupport -Command $cmdUefi
    $svnPresent = ($null -ne $cmdSvn)

    $alreadyCompliant = ($decodedSupported -and $svnPresent)
    if ($alreadyCompliant) {
        Write-Output "Build:$build.$ubr | Status:ALREADY_COMPLIANT | No remediation needed"
        exit 0
    }

    $scanActions = Invoke-BestEffortUpdateScan

    $guidance = "Install latest Windows quality updates and reboot device to obtain Secure Boot cmdlet capability updates"

    Write-Output (
        "Build:$build.$ubr | DecodedSupported:$decodedSupported | SvnCmdletPresent:$svnPresent | " +
        "UpdateScanActions:$scanActions | Guidance:$guidance"
    )

    exit 0
}
catch {
    Write-Output "ERROR: Remediation failed - $($_.Exception.Message)"
    exit 1
}

#Requires -Version 5.1
<#
.SYNOPSIS
    Intune Proactive Remediation - Detection Script
    Detect Secure Boot cmdlet capabilities introduced in newer Windows quality updates.

.DESCRIPTION
    Validates device state for:
      1) Get-SecureBootUEFI support for the -Decoded parameter
      2) Get-SecureBootSVN cmdlet presence and runtime capability

    This script is designed for phased rollout tracking of Secure Boot key updates.

.OUTPUTS
    Single-line summary suitable for Intune remediation output.

.EXITCODES
    0 = Compliant (both capabilities present)
    1 = Non-compliant (one or both capabilities missing)

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

function Invoke-DecodedProbe {
    $probeNames = @("db", "dbx", "KEK", "PK")
    foreach ($name in $probeNames) {
        try {
            $result = Get-SecureBootUEFI -Name $name -Decoded -ErrorAction Stop
            if ($null -ne $result) {
                return @{ Success = $true; Detail = "ProbeSuccess:$name" }
            }
        }
        catch {
            # Continue probing additional variable names to reduce false negatives
            $lastError = $_.Exception.Message
        }
    }

    if ($lastError) {
        return @{ Success = $false; Detail = "ProbeFailed:$lastError" }
    }

    return @{ Success = $false; Detail = "ProbeFailed:NoDataReturned" }
}

function Invoke-SvnProbe {
    try {
        $result = Get-SecureBootSVN -ErrorAction Stop
        if ($null -eq $result) {
            return @{ Success = $false; Detail = "CmdletReturnedNull" }
        }

        return @{ Success = $true; Detail = "ProbeSuccess" }
    }
    catch {
        return @{ Success = $false; Detail = $_.Exception.Message }
    }
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
    $decodedProbe = @{ Success = $false; Detail = "Skipped" }
    if ($decodedSupported) {
        $decodedProbe = Invoke-DecodedProbe
    }

    $svnProbe = @{ Success = $false; Detail = "CmdletMissing" }
    if ($null -ne $cmdSvn) {
        $svnProbe = Invoke-SvnProbe
    }

    $compliant = ($decodedSupported -and ($null -ne $cmdSvn))

    $resultLine = @(
        "Build:$build.$ubr"
        "Get-SecureBootUEFI:$([bool]($null -ne $cmdUefi))"
        "DecodedSupported:$decodedSupported"
        "DecodedProbe:$($decodedProbe.Success)"
        "DecodedDetail:$($decodedProbe.Detail)"
        "Get-SecureBootSVN:$([bool]($null -ne $cmdSvn))"
        "SvnProbe:$($svnProbe.Success)"
        "SvnDetail:$($svnProbe.Detail)"
        "Status:$(if ($compliant) { 'COMPLIANT' } else { 'NON-COMPLIANT' })"
    ) -join " | "

    Write-Output $resultLine

    if ($compliant) {
        exit 0
    }

    exit 1
}
catch {
    Write-Output "ERROR: Detection failed - $($_.Exception.Message)"
    exit 1
}

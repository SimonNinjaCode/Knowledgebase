#Requires -Version 5.1
<#
.SYNOPSIS
    Intune Proactive Remediation - Detection Script
    Surface UEFI Readiness for 2026 Secure Boot Certificate Update

.DESCRIPTION
    Checks whether a Microsoft Surface device already includes the Windows UEFI
    CA 2023 certificate in firmware, or whether its UEFI version meets the
    minimum Microsoft-published requirement.

.NOTES
    Sources:
    - Surface: https://support.microsoft.com/en-gb/surface/surface-secure-boot-certificates-532abf3b-bafe-420f-b615-bf174105549e
    - MS: https://support.microsoft.com/en-us/topic/secure-boot-certificate-updates-guidance-for-it-professionals-and-organizations-e2b43f9f-b424-42df-bc6a-8476db65ab2f
    Revision: 1.0 - 2026-03-17
#>

$MinFirmwareVersions = [ordered]@{
    'Surface Book 3' = '17.200.140.0'
    'Surface Go 3' = '11.200.143.0'
    'Surface Go 4' = '8.200.143.0'
    'Surface Hub 3' = 'Any'
    'Surface Laptop 13-inch' = 'Any'
    'Surface Laptop 4 (AMD)' = '4.200.140.0'
    'Surface Laptop 4 (Intel)' = '23.200.143.0'
    'Surface Laptop 5' = '9.200.143.0'
    'Surface Laptop 5G for Business' = 'Any'
    'Surface Laptop 6 for Business' = 'Any'
    'Surface Laptop 7th Edition, Intel processor' = 'Any'
    'Surface Laptop 7th Edition, Snapdragon processor' = 'Any'
    'Surface Laptop Go 2' = '26.102.143.0'
    'Surface Laptop Go 3' = '10.200.143.0'
    'Surface Laptop SE' = '7.9.139.0'
    'Surface Laptop Studio' = '23.200.143.0'
    'Surface Laptop Studio 2' = '16.200.143.0'
    'Surface Pro 10 for Business' = 'Any'
    'Surface Pro 10 with 5G' = 'Any'
    'Surface Pro 11th Edition 5G' = 'Any'
    'Surface Pro 11th Edition, Intel processor' = 'Any'
    'Surface Pro 11th Edition, Snapdragon processor' = 'Any'
    'Surface Pro 12-inch' = 'Any'
    'Surface Pro 7' = '17.200.140.0'
    'Surface Pro 7+' = '23.200.143.0'
    'Surface Pro 8' = '23.200.143.0'
    'Surface Pro 9' = '12.200.143.0'
    'Surface Pro 9 with 5G' = '18.7.235.0'
    'Surface Pro X WiFi' = '10.703.140.0'
    'Surface Studio 2+' = '20.101.143.0'
    'Windows Dev Kit 2023' = '12.6.235.0'
}

$ManualVerificationModels = @(
    'Surface Laptop 3',
    'Surface Laptop 4'
)

$SbServicingPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing'

function Get-ComparableVersion {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $null
    }

    $matches = [regex]::Matches($Value, '(?i)(\d+(?:\.\d+){1,3})')
    if ($matches.Count -gt 0) {
        return $matches[$matches.Count - 1].Groups[1].Value
    }

    return $null
}

function Compare-FirmwareVersion {
    param(
        [string]$Current,
        [string]$Minimum
    )

    if ($Minimum -eq 'Any') {
        return $true
    }

    $currentComparable = Get-ComparableVersion -Value $Current
    $minimumComparable = Get-ComparableVersion -Value $Minimum
    if ($currentComparable -and $minimumComparable) {
        return ([Version]$currentComparable -ge [Version]$minimumComparable)
    }

    return ($Current.Trim() -eq $Minimum.Trim())
}

function Find-MatchedRequirement {
    param([string[]]$Candidates)

    $bestMatch = $null
    foreach ($candidate in $Candidates) {
        foreach ($entry in $MinFirmwareVersions.GetEnumerator()) {
            if ($candidate -match [regex]::Escape($entry.Key)) {
                if (-not $bestMatch -or $entry.Key.Length -gt $bestMatch.Key.Length) {
                    $bestMatch = [PSCustomObject]@{
                        Candidate = $candidate
                        Key       = $entry.Key
                        Minimum   = $entry.Value
                    }
                }
            }
        }
    }

    return $bestMatch
}

try {
    $cs = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction Stop
    if ($cs.Manufacturer -notmatch 'Microsoft') {
        Write-Output "SKIP: Not a Surface/Microsoft device (Manufacturer: $($cs.Manufacturer))"
        exit 0
    }

    $csp = Get-CimInstance -ClassName Win32_ComputerSystemProduct -ErrorAction SilentlyContinue
    $biosWmi = Get-CimInstance -ClassName Win32_BIOS -ErrorAction Stop

    $modelCandidates = @($cs.Model, $csp.Name, $csp.Version) | Where-Object {
        -not [string]::IsNullOrWhiteSpace($_)
    } | ForEach-Object {
        $_.Trim()
    } | Select-Object -Unique

    $displayModel = if ($modelCandidates.Count -gt 0) { $modelCandidates[0] } else { $cs.Model.Trim() }
    $biosVersion = $biosWmi.SMBIOSBIOSVersion
    $biosDate = if ($biosWmi.ReleaseDate -is [DateTime]) { $biosWmi.ReleaseDate } else { [DateTime]::MinValue }
    $biosDateStr = if ($biosDate -ne [DateTime]::MinValue) { $biosDate.ToString('yyyy-MM-dd') } else { 'Unknown' }

    $uefiStatus = $null
    $uefiError = $null
    if (Test-Path $SbServicingPath) {
        $uefiStatus = (Get-ItemProperty -Path $SbServicingPath -Name 'UEFICA2023Status' -ErrorAction SilentlyContinue).UEFICA2023Status
        $uefiError = (Get-ItemProperty -Path $SbServicingPath -Name 'UEFICA2023Error' -ErrorAction SilentlyContinue).UEFICA2023Error
    }

    $baseInfo = "Model: $displayModel | BIOS: $biosVersion | Date: $biosDateStr"

    if ($uefiStatus -eq 'Updated') {
        Write-Output "$baseInfo | Status: COMPLIANT | Reason: Secure Boot CA 2023 certificates already deployed"
        exit 0
    }

    if ($null -ne $uefiError -and $uefiError -ne 0) {
        Write-Output "$baseInfo | Status: NON-COMPLIANT | Reason: UEFI CA 2023 error (code: $uefiError) - remediation required"
        exit 1
    }

    $matchedRequirement = Find-MatchedRequirement -Candidates $modelCandidates
    if ($matchedRequirement) {
        if ($matchedRequirement.Minimum -eq 'Any') {
            Write-Output "$baseInfo | Status: COMPLIANT | Reason: $($matchedRequirement.Key) shipped with the 2023 CA in UEFI"
            exit 0
        }

        if (Compare-FirmwareVersion -Current $biosVersion -Minimum $matchedRequirement.Minimum) {
            Write-Output "$baseInfo | Status: COMPLIANT | Reason: UEFI version meets Microsoft minimum $($matchedRequirement.Minimum) for $($matchedRequirement.Key)"
            exit 0
        }

        Write-Output "$baseInfo | Status: NON-COMPLIANT | Reason: UEFI version is below Microsoft minimum $($matchedRequirement.Minimum) for $($matchedRequirement.Key)"
        exit 1
    }

    foreach ($manualVerificationModel in $ManualVerificationModels) {
        if ($modelCandidates -contains $manualVerificationModel) {
            Write-Output "$baseInfo | Status: NON-COMPLIANT | Reason: Surface model not in Microsoft table - verify manually"
            exit 1
        }
    }

    Write-Output "$baseInfo | Status: NON-COMPLIANT | Reason: Surface model not in Microsoft table - verify manually"
    exit 1
}
catch {
    Write-Output "ERROR: Detection script failed - $($_.Exception.Message)"
    exit 1
}
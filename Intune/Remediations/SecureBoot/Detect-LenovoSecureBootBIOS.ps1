#Requires -Version 5.1
<#
.SYNOPSIS
    Intune Proactive Remediation - Detection Script
    Lenovo BIOS Firmware Readiness for 2026 Secure Boot Certificate Update

.DESCRIPTION
    Checks whether a Lenovo commercial device has a BIOS version that meets the
    Lenovo-published minimum requirement before rolling out the 2026 Secure Boot
    certificate update.

    Lenovo's guidance differs slightly from Dell/HP: a BIOS update can be a
    prerequisite for the 2023 certificates, but some devices may still require
    Microsoft-managed deployment or a BIOS factory key restore step. This script
    therefore reports BIOS readiness for deployment, while still honoring the
    Microsoft UEFICA2023 registry state when present.

.NOTES
    Sources:
    - Lenovo: https://support.lenovo.com/us/en/solutions/HT518129
    - MS: https://support.microsoft.com/en-us/topic/secure-boot-certificate-updates-guidance-for-it-professionals-and-organizations-e2b43f9f-b424-42df-bc6a-8476db65ab2f
    Revision: 1.0 - 2026-03-17
#>

$MinFirmwareVersions = [ordered]@{
    '11e 5th Gen' = '1.24'
    '11e Yoga Gen 6' = '1.18'
    'E14 Gen 2' = '1.63'
    'E14 Gen 3 AMD' = '1.24'
    'E14 Gen 4' = '1.33'
    'E14 Gen 4 AMD' = '1.20'
    'E14 Gen 5' = '1.36'
    'E14 Gen 5 AMD' = '1.22'
    'E14 Gen 6' = '1.16'
    'E14 Gen 6 AMD' = '1.12'
    'E15 Gen 2' = '1.63'
    'E15 Gen 3 AMD' = '1.24'
    'E15 Gen 4' = '1.33'
    'E15 Gen 4 AMD' = '1.20'
    'E16 Gen 1 AMD' = '1.22'
    'E16 Gen 1 Intel' = '1.36'
    'E16 Gen 2 AMD' = '1.12'
    'E16 Gen 2 Intel' = '1.16'
    'E490' = '1.38'
    'E490s' = '1.38'
    'E495' = '1.30'
    'E590' = '1.38'
    'E595' = '1.30'
    'L13' = '1.41'
    'L13 2-in-1 Gen 5' = '1.07'
    'L13 Gen 2 AMD' = '1.38'
    'L13 Gen 2 non-vPro' = '1.31'
    'L13 Gen 2 vPro' = '1.29'
    'L13 Gen 3' = '1.23'
    'L13 Gen 3 AMD' = '1.25'
    'L13 Gen 4' = '1.15'
    'L13 Gen 5' = '1.07'
    'L13 Yoga' = '1.41'
    'L13 Yoga Gen 2 AMD' = '1.38'
    'L13 Yoga Gen 2 non-vPro' = '1.31'
    'L13 Yoga Gen 2 vPro' = '1.29'
    'L13 Yoga Gen 3' = '1.23'
    'L13 Yoga Gen 3 AMD' = '1.25'
    'L13 Yoga Gen 4' = '1.15'
    'L14 Gen 1' = '1.24'
    'L14 Gen 1 AMD' = '1.39'
    'L14 Gen 2' = '1.69'
    'L14 Gen 2 AMD' = '1.35'
    'L14 Gen 3 AMD' = '1.31'
    'L14 Gen 4' = '1.16'
    'L14 Gen 5' = '1.08'
    'L14 Gen 5 AMD' = '1.32'
    'L14 Gen3' = '1.35'
    'L15 Gen 1' = '1.24'
    'L15 Gen 1 AMD' = '1.39'
    'L15 Gen 2' = '1.69'
    'L15 Gen 2 AMD' = '1.35'
    'L15 Gen 3 AMD' = '1.31'
    'L15 Gen 4' = '1.16'
    'L15 Gen3' = '1.35'
    'L16 Gen 1' = '1.08'
    'L16 Gen1 AMD' = '1.30'
    'L380' = '1.35'
    'L380 Yoga' = '1.35'
    'L390' = '1.46'
    'L490' = '1.38'
    'L590' = '1.38'
    'P1' = '1.46'
    'P1 Gen 2' = '1.50'
    'P1 Gen 3' = '1.32'
    'P1 Gen 4' = '1.27'
    'P1 Gen 5' = '1.22'
    'P1 Gen 6' = '1.20'
    'P1 Gen 7' = '0.08'
    'P14s Gen 1 AMD' = '1.54'
    'P14s Gen 2' = '1.13'
    'P14s Gen 2 AMD' = '1.33'
    'P14s Gen 3' = '1.38'
    'P14s Gen 3 AMD' = '1.62'
    'P14s Gen 4' = '1.44'
    'P14s Gen 5' = '1.24'
    'P14s Gen 5 AMD' = '1.16'
    'P14s Gen4 AMD' = '1.45'
    'P15 Gen 1' = '1.36'
    'P15 Gen 2' = '1.33'
    'P15s Gen 2' = '1.61'
    'P15v Gen 1' = '1.36'
    'P15v Gen 3' = '1.25'
    'P15v Gen2' = '1.26'
    'P15v Gen3 AMD' = '1.20'
    'P16 Gen 1' = '1.28'
    'P16 Gen 2' = '1.56'
    'P16s Gen 1' = '1.18'
    'P16s Gen 1 AMD' = '1.62'
    'P16s Gen 2' = '1.44'
    'P16s Gen 3' = '1.24'
    'P16s Gen2 AMD' = '1.45'
    'P16v Gen 1' = '1.50'
    'P16v Gen 2' = '1.01'
    'P17 Gen 1' = '1.36'
    'P17 Gen 2' = '1.33'
    'P43s' = '1.82'
    'P52' = '1.53'
    'P52s' = '1.39'
    'P53' = '1.44'
    'P53s' = '1.82'
    'P72' = '1.53'
    'P73' = '1.44'
    'S2 Gen 3' = '1.35'
    'S2 Gen 4' = '1.46'
    'S2 Gen 9' = '1.07'
    'T14 Gen 1' = '1.31'
    'T14 Gen 1 AMD' = '1.54'
    'T14 Gen 2' = '1.61'
    'T14 Gen 2 AMD' = '1.33'
    'T14 Gen 3' = '1.38'
    'T14 Gen 3 AMD' = '1.62'
    'T14 Gen 4' = '1.44'
    'T14 Gen 4 AMD' = '1.45'
    'T14 Gen 5' = '1.01'
    'T14 Gen 5 AMD' = '1.16'
    'T14p Gen 2' = '1.24'
    'T14s Gen 1' = '1.36'
    'T14s Gen 1 AMD' = '1.54'
    'T14s Gen 2' = '1.58'
    'T14s Gen 2 AMD' = '1.36'
    'T14s Gen 3' = '1.43'
    'T14s Gen 3 AMD' = '1.50'
    'T14s Gen 4' = '1.15'
    'T14s Gen 4 AMD' = '1.26'
    'T14s Gen 5' = '1.05'
    'T14s Gen 6' = '1.23'
    'T14s Gen 6 AMD' = '1.15'
    'T15 Gen 1' = '1.31'
    'T15 Gen 2' = '1.13'
    'T15g Gen 1' = '1.36'
    'T15g Gen 2' = '1.33'
    'T15p Gen 1' = '1.36'
    'T15p Gen 3' = '1.25'
    'T16 Gen 1' = '1.18'
    'T16 Gen 1 AMD' = '1.62'
    'T16 Gen 2' = '1.44'
    'T16 Gen2 AMD' = '1.45'
    'T16 Gen3' = '1.01'
    'T480' = '1.51'
    'T480s' = '1.57'
    'T490' = '1.82'
    'T490 CML' = '1.24'
    'T490s' = '1.86'
    'T495 AMD' = '1.36'
    'T495s AMD' = '1.32'
    'T580' = '1.39'
    'T590' = '1.82'
    'ThinkBook 13x G4 IMH' = '1.46'
    'ThinkBook 14 G2 ITL' = '2.22'
    'ThinkBook 14 G7+ IAH' = '1.27'
    'ThinkBook 14/16 G5+ APO' = '1.31'
    'ThinkBook 14/16 G6 ABP' = '1.37'
    'ThinkBook 14/16 G7 AHP' = '1.38'
    'ThinkBook 14/16 G7 ARP' = '1.29'
    'ThinkBook 14/16 G7/G4 YOGA IML' = '1.51'
    'ThinkBook 14/16 G7+ AHP' = '1.12'
    'ThinkBook 14/16 G7+ AKP' = '1.17'
    'ThinkBook 14/16 G7+ ASP' = '1.29'
    'ThinkBook 14/16 G8 IRL' = '1.17'
    'ThinkBook 14/16 G8/G5 YOGA IAL' = '1.21'
    'ThinkBook 16 G7+ IAH' = '1.55'
    'ThinkBook 16p G6 ADR' = '1.23'
    'ThinkBook 16P G6 AFR' = '1.13'
    'ThinkBook 16P G6 IAX' = '1.31'
    'ThinkBook Plus G6 Rollable' = '1.38'
    'ThinkBook X G2 IAH' = '1.28'
    'ThinkCentre M70A_GEN 3' = '1.38'
    'ThinkCentre M70A_GEN 6' = '1.22'
    'ThinkCentre M70q Gen 2' = '1.43'
    'ThinkCentre M70q Gen 3' = '1.48'
    'ThinkCentre M70q Gen 4' = '1.43'
    'ThinkCentre M70q Gen 5' = '1.34'
    'ThinkCentre M70q Gen 6' = '1.29'
    'ThinkCentre M70q-1' = '1.64'
    'ThinkCentre M70t/s Gen 3' = '1.96'
    'ThinkCentre M70t/s Gen 4' = '1.64'
    'ThinkCentre M70t/s Gen 5' = '1.90'
    'ThinkCentre M70t/s Gen 6' = '1.57'
    'ThinkCentre M75n' = '1.32'
    'ThinkCentre M75Q-GEN 2' = '1.62'
    'ThinkCentre M75Q-GEN 5' = '1.29'
    'ThinkCentre M75s-Gen 2' = '1.37'
    'ThinkCentre M75t/s Gen 2' = '1.88'
    'ThinkCentre M75t/s Gen 5' = '1.48'
    'ThinkCentre M80q Gen 4' = '1.64'
    'ThinkCentre M80q-1' = '1.96'
    'ThinkCentre M90a' = '1.102'
    'ThinkCentre M90a Gen 2' = '1.46'
    'ThinkCentre M90a Gen 3' = '1.37'
    'ThinkCentre M90a Pro Gen 4' = '1.56'
    'ThinkCentre M90a Pro GEN 6' = '1.22'
    'ThinkCentre M90a-5' = '1.34'
    'ThinkCentre M90q Gen 2' = '1.68'
    'ThinkCentre M90q Gen 3' = '1.55'
    'ThinkCentre M90q Gen 4' = '1.86'
    'ThinkCentre M90q Gen 5' = '1.32'
    'ThinkCentre M90q Gen 6' = '1.38'
    'ThinkCentre M90q-1' = '1.99'
    'ThinkCentre M90n-1' = '1.72'
    'ThinkCentre M90t/s Gen 3' = '1.96'
    'ThinkCentre M90t/s Gen 4' = '1.64'
    'ThinkCentre M90t/s Gen 5' = '1.122'
    'ThinkCentre M720q' = '1.0.0.120'
    'ThinkCentre M720s' = '1.0.0.120'
    'ThinkCentre M720t' = '1.0.0.120'
    'ThinkCentre M920q' = '1.0.0.120'
    'ThinkCentre M920s' = '1.0.0.120'
    'ThinkCentre M920t' = '1.0.0.120'
    'ThinkCentre M920x' = '1.0.0.120'
    'ThinkCentre Neo 50a Gen 5' = '1.36'
    'ThinkCentre Neo 50s Gen 3' = '1.50'
    'ThinkCentre Neo 50s Gen 4' = '1.74'
    'ThinkCentre Neo 50s Gen 5' = '1.32'
    'ThinkCentre Neo 50s Gen 6' = '1.18'
    'ThinkCentre neo 50q Gen 4' = '1.29'
    'ThinkCentre neo 50q Gen 5' = '1.20'
    'ThinkCentre neo 50t Gen 3' = '1.85'
    'ThinkCentre neo 50t Gen 4' = '1.74'
    'ThinkCentre neo 50t Gen 6' = '1.56'
    'ThinkCentre neo 30s Gen 5' = '1.38'
    'ThinkCentre Neo55q Gen 6' = '1.19'
    'ThinkEdge SE10' = '1.0.0.29'
    'ThinkEdge SE30' = '1.0.0.64'
    'ThinkEdge SE50' = '20.0.0.49'
    'ThinkStation P2 Tower' = '1.0.0.118'
    'ThinkStation P2 Tower Gen 2' = '1.0.0'
    'ThinkStation P3 Tiny' = '1.89'
    'ThinkStation P3 Tower' = '1.0.0.118'
    'ThinkStation P3 Tower Gen 2' = '1.0.0'
    'ThinkStation P3 Ultra SFF' = '1.0.0.50'
    'ThinkStation P320 SFF' = '10.0.0.105'
    'ThinkStation P320 Tower' = '10.0.0.105'
    'ThinkStation P330 SFF' = '10.0.0.120'
    'ThinkStation P330 Tiny' = '1.0.0.120'
    'ThinkStation P330 Tower' = '10.0.0.120'
    'ThinkStation P340 SFF' = '1.0.0.95'
    'ThinkStation P340 Tiny' = '1.98'
    'ThinkStation P340 Tower' = '1.0.0.95'
    'ThinkStation P348 Tower' = '1.0.0.73'
    'ThinkStation P350 SFF' = '1.0.0.73'
    'ThinkStation P350 Tiny' = '1.46'
    'ThinkStation P350 Tower' = '1.0.0.73'
    'ThinkStation P358 Tower' = '1.0.0.41'
    'ThinkStation P360 Tiny' = '1.53'
    'ThinkStation P360 Tower' = '1.96'
    'ThinkStation P360 Ultra' = '1.0.0.57'
    'ThinkStation P5' = '1.0.0.39'
    'ThinkStation P520' = '1.0.0.112'
    'ThinkStation P520c' = '1.0.0.112'
    'ThinkStation P620' = '1.107'
    'ThinkStation P7' = '1.0.0.39'
    'ThinkStation P720' = '1.0.0.119'
    'ThinkStation P8' = '1.0.0.71'
    'ThinkStation P920' = '1.0.0.119'
    'ThinkStation PX' = '1.35'
    'X1 2-in-1 Gen 9' = '1.23'
    'X1 Carbon Gen 10' = '1.45'
    'X1 Carbon Gen 11' = '1.26'
    'X1 Carbon Gen 12' = '1.23'
    'X1 Carbon Gen 6' = '1.63'
    'X1 Carbon Gen 7' = '1.49'
    'X1 Carbon Gen 8' = '1.35'
    'X1 Carbon Gen 9' = '1.67'
    'X1 Extreme' = '1.46'
    'X1 Extreme Gen 2' = '1.50'
    'X1 Extreme Gen 3' = '1.32'
    'X1 Extreme Gen 4' = '1.27'
    'X1 Extreme Gen 5' = '1.22'
    'X1 Fold 16 Gen 1' = '1.19'
    'X1 Fold Gen 1' = '1.30'
    'X1 Nano Gen 1' = '1.62'
    'X1 Nano Gen 2' = '1.25'
    'X1 Nano Gen 3' = '1.17'
    'X1 Tablet Gen 3' = '1.51'
    'X1 Titanium' = '1.31'
    'X1 Yoga Gen 3' = '1.53'
    'X1 Yoga Gen 4' = '1.49'
    'X1 Yoga Gen 6' = '1.67'
    'X1 Yoga Gen 7' = '1.45'
    'X1 Yoga Gen 8' = '1.26'
    'X12 Detachable' = '1.36'
    'X12 Detachable Gen 2' = '1.10'
    'X13 2-in-1 Gen 5' = '1.08'
    'X13 AMD Gen 4' = '1.34'
    'X13 Gen 1' = '1.36'
    'X13 Gen 2' = '1.58'
    'X13 Gen 2 AMD' = '1.36'
    'X13 Gen 3' = '1.43'
    'X13 Gen 3 AMD' = '1.50'
    'X13 Gen 4' = '1.14'
    'X13 Gen 5' = '1.08'
    'X13 Gen1 AMD' = '1.54'
    'X13 Yoga Gen 1' = '1.51'
    'X13 Yoga Gen 2' = '1.45'
    'X13 Yoga Gen 3' = '1.18'
    'X13 Yoga Gen 4' = '1.14'
    'X13s Gen 1' = '1.65'
    'X280' = '1.53'
    'X380 Yoga' = '1.40'
    'X390' = '1.31'
    'X390 Yoga' = '1.99'
    'X395 AMD' = '1.32'
    'Yoga 11e 5th Gen' = '1.31'
    'Yoga Gen 5' = '1.35'
    'Z13 Gen 1' = '1.71'
    'Z13 Gen 2' = '1.30'
    'Z16 Gen 1' = '1.71'
    'Z16 Gen 2' = '1.30'
    '21DH' = '2.17'
}

$ModelAliases = [ordered]@{
    '21MX' = @('ThinkBook 14 2-In-1 G4 IML', 'ThinkBook 14/16 G7/G4 YOGA IML')
    '20VD' = @('ThinkBook 14 G2 ITL')
    '20VE' = @('ThinkBook 14 G2 ITL')
}

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

function Get-ModelInfo {
    param(
        [object]$ComputerSystem,
        [object]$ComputerSystemProduct
    )

    $rawCandidates = @($ComputerSystem.Model, $ComputerSystemProduct.Name, $ComputerSystemProduct.Version) | Where-Object {
        -not [string]::IsNullOrWhiteSpace($_)
    } | ForEach-Object {
        $_.Trim()
    } | Select-Object -Unique

    $expandedCandidates = New-Object System.Collections.Generic.List[string]
    $displayModel = $null

    foreach ($candidate in $rawCandidates) {
        $expandedCandidates.Add($candidate)

        foreach ($typeCode in [regex]::Matches($candidate.ToUpperInvariant(), '\b[A-Z0-9]{4}\b')) {
            $resolvedCode = $typeCode.Value
            if ($ModelAliases.Contains($resolvedCode)) {
                foreach ($alias in $ModelAliases[$resolvedCode]) {
                    $expandedCandidates.Add($alias)
                }

                if (-not $displayModel) {
                    $displayModel = $ModelAliases[$resolvedCode][0]
                }
            }
        }
    }

    if (-not $displayModel) {
        $displayModel = if ($rawCandidates.Count -gt 0) { $rawCandidates[0] } else { $ComputerSystem.Model.Trim() }
    }

    return [PSCustomObject]@{
        DisplayModel = $displayModel
        Candidates    = $expandedCandidates | Select-Object -Unique
    }
}

try {
    $cs = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction Stop
    if ($cs.Manufacturer -notmatch 'Lenovo') {
        Write-Output "SKIP: Not a Lenovo device (Manufacturer: $($cs.Manufacturer))"
        exit 0
    }

    $csp = Get-CimInstance -ClassName Win32_ComputerSystemProduct -ErrorAction SilentlyContinue
    $biosWmi = Get-CimInstance -ClassName Win32_BIOS -ErrorAction Stop

    $modelInfo = Get-ModelInfo -ComputerSystem $cs -ComputerSystemProduct $csp
    $modelCandidates = $modelInfo.Candidates
    $displayModel = $modelInfo.DisplayModel
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
        Write-Output "$baseInfo | Status: NON-COMPLIANT | Reason: UEFI CA 2023 error (code: $uefiError) - BIOS or deployment remediation required"
        exit 1
    }

    $matchedRequirement = Find-MatchedRequirement -Candidates $modelCandidates
    if ($matchedRequirement) {
        if (Compare-FirmwareVersion -Current $biosVersion -Minimum $matchedRequirement.Minimum) {
            Write-Output "$baseInfo | Status: COMPLIANT | Reason: BIOS meets Lenovo minimum $($matchedRequirement.Minimum) for $($matchedRequirement.Key)"
            exit 0
        }

        Write-Output "$baseInfo | Status: NON-COMPLIANT | Reason: BIOS is below Lenovo minimum $($matchedRequirement.Minimum) for $($matchedRequirement.Key)"
        exit 1
    }

    Write-Output "$baseInfo | Status: NON-COMPLIANT | Reason: Lenovo model not in commercial version table - verify manually"
    exit 1
}
catch {
    Write-Output "ERROR: Detection script failed - $($_.Exception.Message)"
    exit 1
}
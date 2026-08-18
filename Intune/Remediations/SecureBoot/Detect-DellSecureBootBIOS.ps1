#Requires -Version 5.1
<#
.SYNOPSIS
    Intune Proactive Remediation - Detection Script
    Dell BIOS Firmware Readiness for 2026 Secure Boot Certificate Update

.DESCRIPTION
    Checks whether a Dell device has a BIOS version that meets Dell's published
    minimum requirement before deploying Microsoft's 2026 Secure Boot
    certificate update.

    This script follows the same decision pattern as the HP variant:
      1. Non-Dell device                -> Exit 0
      2. UEFICA2023Status=Updated       -> Exit 0
      3. UEFICA2023Error set            -> Exit 1
      4. Model in version table         -> Compare BIOS version
      5. Fallback: BIOS date threshold  -> Compare BIOS date
      6. Unknown model/date             -> Exit 1

.NOTES
    Sources:
    - Dell: https://www.dell.com/support/kbdoc/en-us/000347876/microsoft-2011-secure-boot-certificate-expiration
    - MS: https://support.microsoft.com/en-us/topic/secure-boot-certificate-updates-guidance-for-it-professionals-and-organizations-e2b43f9f-b424-42df-bc6a-8476db65ab2f
    Revision: 1.0 - 2026-03-17
#>

$MinFirmwareVersions = [ordered]@{
    'Dell Pro 13 Plus PB13250' = '2.6.1'
    'Dell Pro 13 Plus PB13255' = '1.7.0'
    'Dell Pro 13 Premium PA13250' = '2.6.1'
    'Dell Pro 14 Essential PV14250' = '1.1.1'
    'Dell Pro 14 Essential PV14255' = '1.5.0'
    'Dell Pro 14 PC14250' = '1.7.0'
    'Dell Pro 14 PC14255' = '1.7.0'
    'Dell Pro 14 Plus PB14250' = '2.6.1'
    'Dell Pro 14 Plus PB14255' = '1.7.0'
    'Dell Pro 14 Premium PA14250' = '2.6.1'
    'Dell Pro 15 Essential PV15250' = '1.0.0'
    'Dell Pro 15 Essential PV15255' = '1.2.1'
    'Dell Pro 16 PC16250' = '1.7.0'
    'Dell Pro 16 PC16255' = '1.7.0'
    'Dell Pro 16 Plus PB16250' = '2.6.1'
    'Dell Pro 16 Plus PB16255' = '1.7.0'
    'Dell Pro 24 All-in-One Plus QB24250' = '1.8.1'
    'Dell Pro 24 All-in-One QC24250' = '1.8.1'
    'Dell Pro 24 All-in-One QC24251' = '1.8.1'
    'Dell Pro Laptop PC14250' = '1.7.0'
    'Dell Pro Laptop PC16250' = '1.7.0'
    'Dell Pro Max 14 MC14250' = '1.7.0'
    'Dell Pro Max 14 MC14255' = '1.2.1'
    'Dell Pro Max 14 Premium MA14250' = '1.4.2'
    'Dell Pro Max 16 MC16250' = '1.7.0'
    'Dell Pro Max 16 MC16255' = '1.2.1'
    'Dell Pro Max 16 Plus MB16250' = '1.3.3'
    'Dell Pro Max 16 Premium MA16250' = '1.4.2'
    'Dell Pro Max 18 Plus MB18250' = '1.3.3'
    'Dell Pro Max Micro FCM2250' = '1.7.1'
    'Dell Pro Max Slim FCS1250' = '1.7.1'
    'Dell Pro Max Tower T2 FCT2250' = '1.7.1'
    'Dell Pro Max with GB10 FCM1253' = '1.1.0'
    'Dell Pro Micro QCM1250' = '1.7.0'
    'Dell Pro Micro QCM1255' = '1.4.2'
    'Dell Pro Micro QCT1255' = '1.4.2'
    'Dell Pro Micro Plus QBM1250' = '1.7.0'
    'Dell Pro Rugged 10 Tablet' = '1.1.0'
    'Dell Pro Rugged 12 Tablet' = '1.1.0'
    'Dell Pro Rugged 13 RA13250' = '1.9.0'
    'Dell Pro Rugged 14 RB14250' = '1.9.0'
    'Dell Pro Slim Essential QVS1260' = '1.8.1'
    'Dell Pro Slim Plus QBS1250' = '1.7.0'
    'Dell Pro Slim QCS1250' = '1.7.0'
    'Dell Pro Slim QCS1255' = '1.4.2'
    'Dell Pro Tower Essential QVT1260' = '1.8.1'
    'Dell Pro Tower Plus QBT1250' = '1.7.0'
    'Dell Pro Tower QCT1250' = '1.7.0'
    'Dell Pro Tower QCT1255' = '1.4.2'
    'Latitude 12 Rugged Extreme 7214' = '1.52.0'
    'Latitude 3120' = '1.37.0'
    'Latitude 3140' = '1.25.5'
    'Latitude 3140 2-in-1' = '1.25.5'
    'Latitude 3190' = '1.42.0'
    'Latitude 3190 2-in-1' = '1.42.0'
    'Latitude 3301' = '1.37.0'
    'Latitude 3310' = '1.31.0'
    'Latitude 3310 2-In-1' = '1.30.0'
    'Latitude 3320' = '1.40.0'
    'Latitude 3330' = '1.32.1'
    'Latitude 3340' = '1.25.1'
    'Latitude 3400' = '1.39.0'
    'Latitude 3410' = '1.36.0'
    'Latitude 3420' = '1.44.0'
    'Latitude 3430' = '1.30.1'
    'Latitude 3440' = '1.25.1'
    'Latitude 3450' = '1.16.1'
    'Latitude 3500' = '1.39.0'
    'Latitude 3510' = '1.36.0'
    'Latitude 3520' = '1.44.0'
    'Latitude 3530' = '1.30.1'
    'Latitude 3540' = '1.25.1'
    'Latitude 3550' = '1.16.1'
    'Latitude 5300' = '1.37.0'
    'Latitude 5300 2-in-1' = '1.37.0'
    'Latitude 5310' = '1.30.0'
    'Latitude 5310 2-in-1' = '1.30.0'
    'Latitude 5320' = '1.46.0'
    'Latitude 5330' = '1.32.1'
    'Latitude 5340' = '1.24.1'
    'Latitude 5350' = '1.16.1'
    'Latitude 5400' = '1.41.1'
    'Latitude 5401' = '1.42.1'
    'Latitude 5410' = '1.38.1'
    'Latitude 5411' = '1.39.1'
    'Latitude 5420' = '1.49.0'
    'Latitude 5420 Rugged' = '1.40.0'
    'Latitude 5421' = '1.41.0'
    'Latitude 5424 Rugged' = '1.40.0'
    'Latitude 5430' = '1.32.1'
    'Latitude 5430 Rugged Laptop' = '1.39.0'
    'Latitude 5431' = '1.33.1'
    'Latitude 5440' = '1.25.1'
    'Latitude 5450' = '1.16.2'
    'Latitude 5455' = '2.11.0'
    'Latitude 5500' = '1.41.1'
    'Latitude 5501' = '1.42.1'
    'Latitude 5510' = '1.38.1'
    'Latitude 5511' = '1.39.1'
    'Latitude 5520' = '1.46.0'
    'Latitude 5521' = '1.39.0'
    'Latitude 5530' = '1.32.1'
    'Latitude 5531' = '1.32.1'
    'Latitude 5540' = '1.24.1'
    'Latitude 5550' = '1.16.2'
    'Latitude 7030 Rugged Extreme' = '1.17.3'
    'Latitude 7200 2-In-1' = '1.38.0'
    'Latitude 7210 2-in-1' = '1.40.0'
    'Latitude 7212 Rugged Extreme Tablet' = '1.58.0'
    'Latitude 7220 Rugged Extreme' = '1.48.0'
    'Latitude 7230 Rugged Extreme' = '1.26.4'
    'Latitude 7300' = '1.42.1'
    'Latitude 7310' = '1.41.1'
    'Latitude 7320' = '1.46.0'
    'Latitude 7320 Detachable' = '1.43.0'
    'Latitude 7330' = '1.34.1'
    'Latitude 7330 Rugged Laptop' = '1.39.0'
    'Latitude 7340' = '1.25.1'
    'Latitude 7350' = '1.16.1'
    'Latitude 7350 Detachable' = '1.14.1'
    'Latitude 7400' = '1.42.1'
    'Latitude 7400 2-In-1' = '1.37.0'
    'Latitude 7410' = '1.41.1'
    'Latitude 7420' = '1.46.0'
    'Latitude 7424 Rugged Extreme' = '1.40.0'
    'Latitude 7430' = '1.34.1'
    'Latitude 7440' = '1.25.1'
    'Latitude 7450' = '1.16.0'
    'Latitude 7455' = '2.11.0'
    'Latitude 7520' = '1.46.0'
    'Latitude 7530' = '1.34.1'
    'Latitude 7640' = '1.25.1'
    'Latitude 7650' = '1.16.0'
    'Latitude 9330' = '1.31.0'
    'Latitude 9410' = '1.39.1'
    'Latitude 9420' = '1.42.0'
    'Latitude 9430' = '1.34.1'
    'Latitude 9440 2-in-1' = '1.23.1'
    'Latitude 9450' = '1.15.0'
    'Latitude 9510 2-in-1' = '1.38.0'
    'Latitude 9520' = '1.43.0'
    'Latitude Rugged 7220EX' = '1.48.0'
    'OptiPlex 3000 Micro / OptiPlex 3000 Small Form Factor / OptiPlex 3000 Tower' = '1.34.1'
    'OptiPlex 3000 Thin Client' = '1.29.2'
    'OptiPlex 3070' = '1.35.0'
    'OptiPlex 3080' = '2.33.0'
    'OptiPlex 3090' = '2.27.0'
    'OptiPlex 3090 Ultra' = '1.38.0'
    'OptiPlex 3280 All-in-One' = '1.41.0'
    'OptiPlex 5000 Micro / OptiPlex 5000 Small Form Factor / OptiPlex 5000 Tower' = '1.33.0'
    'OptiPlex 5070' = '1.35.0'
    'OptiPlex 5080' = '1.33.0'
    'OptiPlex 5090 Micro / OptiPlex 5090 Small Form Factor / OptiPlex 5090 Tower' = '1.37.0'
    'OptiPlex 5270 All-in-One' = '1.40.0'
    'OptiPlex 5400 All-In-One' = '1.1.53'
    'OptiPlex 5480 All-in-One' = '1.42.0'
    'OptiPlex 5490 All-In-One' = '1.43.0'
    'OptiPlex 7000 Micro' = '1.33.2'
    'OptiPlex 7000 Small Form Factor' = '1.33.2'
    'OptiPlex 7000 Tower' = '1.33.2'
    'OptiPlex 7000 XE Micro' = '1.33.2'
    'OptiPlex 7070' = '1.35.0'
    'OptiPlex 7070 Ultra' = '1.33.0'
    'OptiPlex 7071' = '1.35.0'
    'OptiPlex 7080' = '1.36.0'
    'OptiPlex 7090 Tower' = '1.37.0'
    'OptiPlex 7090 Ultra' = '1.38.0'
    'OptiPlex 7400 All-In-One' = '1.1.53'
    'OptiPlex 7470 All-in-One' = '1.40.0'
    'OptiPlex 7480 All-in-One' = '1.42.0'
    'OptiPlex 7490 All-In-One' = '1.43.0'
    'OptiPlex 7770 All-in-One' = '1.40.0'
    'OptiPlex 7780 All-in-One' = '1.42.0'
    'OptiPlex AIO 7420' = '1.20.0'
    'OptiPlex All-in-One 7410' = '1.30.0'
    'OptiPlex Micro 7010 / OptiPlex Micro Plus 7010' = '1.30.0'
    'OptiPlex Micro 7020' = '1.20.0'
    'OptiPlex SFF 7020' = '1.20.0'
    'OptiPlex Small Form Factor 7010 / OptiPlex Small Form Factor Plus 7010' = '1.30.0'
    'OptiPlex Tower 7010 / OptiPlex Tower Plus 7010' = '1.30.0'
    'OptiPlex Tower 7020' = '1.20.0'
    'OptiPlex XE3' = '1.38.0'
    'OptiPlex XE4 SFF' = '1.33.2'
    'OptiPlex XE4 Tower' = '1.33.2'
    'Precision 3240 Compact' = '1.38.0'
    'Precision 3260 Compact' = '3.18.3'
    'Precision 3260 XE Compact' = '3.18.3'
    'Precision 3280 CFF' = '1.16.2'
    'Precision 3430 Tower' = '1.37.0'
    'Precision 3431 Tower' = '1.36.0'
    'Precision 3440' = '1.36.0'
    'Precision 3450' = '1.37.0'
    'Precision 3460 Small Form Factor' = '3.18.3'
    'Precision 3460 XE Small Form Factor' = '3.18.3'
    'Precision 3470' = '1.33.1'
    'Precision 3480' = '1.25.1'
    'Precision 3490' = '1.16.2'
    'Precision 3540' = '1.41.1'
    'Precision 3541' = '1.42.1'
    'Precision 3550' = '1.38.1'
    'Precision 3551' = '1.39.1'
    'Precision 3560' = '1.46.0'
    'Precision 3561' = '1.39.0'
    'Precision 3570' = '1.32.1'
    'Precision 3571' = '1.32.1'
    'Precision 3580' = '1.24.1'
    'Precision 3581' = '1.24.1'
    'Precision 3590' = '1.16.2'
    'Precision 3591' = '1.16.2'
    'Precision 3630 Tower' = '2.37.0'
    'Precision 3640' = '1.41.0'
    'Precision 3650 Tower' = '1.44.0'
    'Precision 3660' = '2.30.1'
    'Precision 3680 Tower' = '1.18.2'
    'Precision 3930 Rack' = '2.40.0'
    'Precision 5470' = '1.34.0'
    'Precision 5480' = '1.22.1'
    'Precision 5490' = '1.14.2'
    'Precision 5540' = '1.39.0'
    'Precision 5550' = '1.39.0'
    'Precision 5560' = '1.41.0'
    'Precision 5570' = '1.35.0'
    'Precision 5680' = '1.23.1'
    'Precision 5690' = '1.15.1'
    'Precision 5750' = '1.37.0'
    'Precision 5760' = '1.37.0'
    'Precision 5770' = '1.35.0'
    'Precision 5820 Tower' = '2.46.0'
    'Precision 5860 Tower' = '3.1.1'
    'Precision 7540' = '1.43.1'
    'Precision 7550' = '1.41.1'
    'Precision 7560' = '1.42.0'
    'Precision 7670' = '1.32.0'
    'Precision 7680' = '1.23.6'
    'Precision 7740' = '1.43.1'
    'Precision 7750' = '1.41.1'
    'Precision 7760' = '1.42.0'
    'Precision 7770' = '1.32.0'
    'Precision 7780' = '1.23.6'
    'Precision 7820 Tower' = '2.50.0'
    'Precision 7865 Tower' = '1.21.1'
    'Precision 7875 Tower' = '2.2.1'
    'Precision 7920 Tower' = '2.50.0'
    'Precision 7920 Rack' = '2.25.1'
    'Precision 7920 XL Rack' = '2.25.1'
    'Precision 7960 Tower' = '2.13.1'
    'Precision 7960 Rack' = '2.8.3'
    'Precision 7960 XL Rack' = '2.8.3'
    'XPS 13 9305' = '1.33.0'
    'XPS 13 9310' = '3.34.0'
    'XPS 13 9315' = '1.32.0'
    'XPS 13 9340' = '1.19.0'
    'XPS 13 9345' = '2.0.9'
    'XPS 13 9350 (shipped 2024 or later)' = '1.14.0'
    'XPS 13 Plus 9320' = '2.24.1'
    'XPS 14 9440' = '1.17.0'
    'XPS 15 9500' = '1.39.0'
    'XPS 15 9510' = '1.41.0'
    'XPS 15 9520' = '1.35.0'
    'XPS 15 9530' = '1.25.1'
    'XPS 16 9640' = '1.17.0'
    'XPS 17 9710' = '1.37.0'
    'XPS 17 9720' = '1.35.0'
    'XPS 17 9730' = '1.22.1'
    'XPS 8950' = '1.29.0'
    'XPS 8960' = '2.20.1'
    'XPS 9315 2-in-1' = '1.25.0'
    'XPS 9320' = '2.24.1'
}

[DateTime]$FallbackMinBiosDate = '2026-01-01'

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

function ConvertTo-VersionObject {
    param([string]$Value)

    try {
        return [Version]$Value
    }
    catch {
        return $null
    }
}

function Compare-FirmwareVersion {
    param(
        [string]$Current,
        [string]$Minimum
    )

    $currentComparable = Get-ComparableVersion -Value $Current
    $minimumComparable = Get-ComparableVersion -Value $Minimum

    if ($currentComparable -and $minimumComparable) {
        $currentVersion = ConvertTo-VersionObject -Value $currentComparable
        $minimumVersion = ConvertTo-VersionObject -Value $minimumComparable
        if ($currentVersion -and $minimumVersion) {
            return ($currentVersion -ge $minimumVersion)
        }
    }

    return ($Current.Trim() -eq $Minimum.Trim())
}

function Get-ModelCandidates {
    param(
        [object]$ComputerSystem,
        [object]$ComputerSystemProduct
    )

    return @(
        $ComputerSystem.Model,
        $ComputerSystemProduct.Name,
        $ComputerSystemProduct.Version
    ) | Where-Object {
        -not [string]::IsNullOrWhiteSpace($_)
    } | ForEach-Object {
        $_.Trim()
    } | Select-Object -Unique
}

function Get-NormalizedModelString {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $null
    }

    return (($Value.ToLowerInvariant() -replace '[^a-z0-9]+', ' ').Trim())
}

function Get-DellModelAliases {
    param([string]$Value)

    @($Value, ($Value -split '\s+/\s+')) | Where-Object {
        -not [string]::IsNullOrWhiteSpace($_)
    } | ForEach-Object {
        $_.Trim()
    } | Select-Object -Unique
}

function Get-ModelMatchScore {
    param(
        [string]$Candidate,
        [string]$Pattern
    )

    $normalizedCandidate = Get-NormalizedModelString -Value $Candidate
    $normalizedPattern = Get-NormalizedModelString -Value $Pattern

    if (-not $normalizedCandidate -or -not $normalizedPattern) {
        return -1
    }

    if ($normalizedCandidate -eq $normalizedPattern) {
        return 10000 + $normalizedPattern.Length
    }

    if ($normalizedPattern.Contains($normalizedCandidate)) {
        return 5000 + $normalizedCandidate.Length - ($normalizedPattern.Length - $normalizedCandidate.Length)
    }

    if ($normalizedCandidate.Contains($normalizedPattern)) {
        return 4000 + $normalizedPattern.Length - ($normalizedCandidate.Length - $normalizedPattern.Length)
    }

    $candidateTokens = @($normalizedCandidate -split '\s+' | Where-Object { $_ })
    $patternTokens = @($normalizedPattern -split '\s+' | Where-Object { $_ })
    $matchingTokens = @($candidateTokens | Where-Object { $patternTokens -contains $_ }).Count

    if ($matchingTokens -eq 0) {
        return -1
    }

    if ($matchingTokens -eq $candidateTokens.Count -or $matchingTokens -eq $patternTokens.Count) {
        return 1000 + ($matchingTokens * 10) - [Math]::Abs($candidateTokens.Count - $patternTokens.Count)
    }

    return -1
}

function Find-MatchedRequirement {
    param([string[]]$Candidates)

    $bestMatch = $null
    $bestScore = -1

    foreach ($candidate in $Candidates) {
        foreach ($entry in $MinFirmwareVersions.GetEnumerator()) {
            foreach ($alias in Get-DellModelAliases -Value $entry.Key) {
                $score = Get-ModelMatchScore -Candidate $candidate -Pattern $alias
                if ($score -gt $bestScore) {
                    $bestScore = $score
                    $bestMatch = [PSCustomObject]@{
                        Candidate = $candidate
                        Key       = $entry.Key
                        Alias     = $alias
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
    if ($cs.Manufacturer -notmatch 'Dell') {
        Write-Output "SKIP: Not a Dell device (Manufacturer: $($cs.Manufacturer))"
        exit 0
    }

    $csp = Get-CimInstance -ClassName Win32_ComputerSystemProduct -ErrorAction SilentlyContinue
    $biosWmi = Get-CimInstance -ClassName Win32_BIOS -ErrorAction Stop

    $modelCandidates = Get-ModelCandidates -ComputerSystem $cs -ComputerSystemProduct $csp
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
        Write-Output "$baseInfo | Status: NON-COMPLIANT | Reason: UEFI CA 2023 error (code: $uefiError) - BIOS or deployment remediation required"
        exit 1
    }

    $matchedRequirement = Find-MatchedRequirement -Candidates $modelCandidates
    if ($matchedRequirement) {
        if (Compare-FirmwareVersion -Current $biosVersion -Minimum $matchedRequirement.Minimum) {
            Write-Output "$baseInfo | Status: COMPLIANT | Reason: BIOS meets Dell minimum $($matchedRequirement.Minimum) for $($matchedRequirement.Key)"
            exit 0
        }

        Write-Output "$baseInfo | Status: NON-COMPLIANT | Reason: BIOS is below Dell minimum $($matchedRequirement.Minimum) for $($matchedRequirement.Key)"
        exit 1
    }

    if ($biosDate -ne [DateTime]::MinValue) {
        if ($biosDate -ge $FallbackMinBiosDate) {
            Write-Output "$baseInfo | Status: COMPLIANT | Reason: BIOS date $biosDateStr is on/after $($FallbackMinBiosDate.ToString('yyyy-MM-dd')) for an unmapped Dell model"
            exit 0
        }

        Write-Output "$baseInfo | Status: NON-COMPLIANT | Reason: Unmapped Dell model with BIOS date $biosDateStr before $($FallbackMinBiosDate.ToString('yyyy-MM-dd'))"
        exit 1
    }

    Write-Output "$baseInfo | Status: NON-COMPLIANT | Reason: Dell model not in version table and BIOS date unavailable - verify manually"
    exit 1
}
catch {
    Write-Output "ERROR: Detection script failed - $($_.Exception.Message)"
    exit 1
}
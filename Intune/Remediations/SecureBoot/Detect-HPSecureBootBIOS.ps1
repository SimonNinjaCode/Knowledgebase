#Requires -Version 5.1
<#
.SYNOPSIS
    Intune Proactive Remediation — Detection Script
    HP BIOS Firmware Readiness for 2026 Secure Boot Certificate Update

.DESCRIPTION
    Checks whether an HP device has a BIOS version that meets the minimum requirement
    before applying Microsoft's 2026 Secure Boot certificate update.

    Between June–October 2026, the 2011 Microsoft Secure Boot certificates expire.
    HP requires platform-specific BIOS updates before the new certs can be applied.

    Detection logic (in priority order):
      1. Non-HP device         → Exit 0, no action needed
      2. UEFICA2023Status=Updated → Certs already deployed → Exit 0 (Compliant)
      3. UEFICA2023Error set   → Error state            → Exit 1 (Non-Compliant)
      4. Model in version table → Version comparison      → Exit per result
      5. Fallback: BIOS date   → Date vs threshold check → Exit per result

    IMPORTANT: The $MinFirmwareVersions table must be populated/validated against
    HP's official minimum BIOS version list before deployment:
    https://support.hp.com/us-en/document/ish_13070381-13192099-16

.OUTPUTS
    Returns a single line to stdout visible in Intune portal:
    "Model: <model> | BIOS: <version> | Date: <YYYY-MM-DD> | Status: COMPLIANT/NON-COMPLIANT | Reason: <text>"

.EXITCODES
    0 = Compliant  (BIOS ready, or certs already updated, or device not HP)
    1 = Non-Compliant (BIOS update required before Secure Boot cert deployment)

.NOTES
    Sources:
    - HP: https://support.hp.com/us-en/document/ish_13070381-13192099-16
    - MS: https://techcommunity.microsoft.com/blog/windows-itpro-blog/secure-boot-playbook-for-certificates-expiring-in-2026/4469235
    - MS: https://support.microsoft.com/en-us/topic/secure-boot-certificate-updates-guidance-for-it-professionals-and-organizations-e2b43f9f-b424-42df-bc6a-8476db65ab2f
    Revision: 1.0 — 2026-03-11
#>

# =============================================================================
# CONFIGURATION — Validate versions against HP's published list before deploying
# https://support.hp.com/us-en/document/ish_13070381-13192099-16
# Key  = Substring of Win32_ComputerSystem.Model (case-insensitive match)
# Value = Minimum required BIOS version string (dot-separated, e.g. "01.12.00")
# =============================================================================
$MinFirmwareVersions = [ordered]@{
    # ===================================================================================
    # HP BUSINESS NOTEBOOK PCS — Secure Boot BIOS Minimum Versions
    # Source: https://support.hp.com/us-en/document/ish_13070381-13192099-16
    # Last Updated: 2026-03-11
    # ===================================================================================

    # --- Dragonfly Series ---
    "Dragonfly 13.5 inch G4"                = "01.10.00"
    "Dragonfly Folio 13.5 inch G3"          = "01.16.00"
    "Elite Dragonfly"                       = "01.34.00"
    "Elite Dragonfly 13.5 inch G3"          = "01.16.00"
    "Elite Dragonfly G2"                    = "01.22.00"
    "Elite Dragonfly Max"                   = "01.22.00"
    
    # --- Elite Tablet / 2-in-1 ---
    "Elite X2 G4"                           = "01.33.00"
    # Elite X2 G8 — TBD (falls back to date check)
    
    # --- Elite x360 Convertible ---
    "Elite x360 1040 14 inch G10"           = "01.10.00"
    "Elite x360 1040 14 inch G9"            = "01.16.01"
    "Elite x360 830 13 inch G10"            = "01.10.00"
    "Elite x360 830 13 inch G9"             = "01.16.01"
    
    # --- EliteBook 1000-series (14") ---
    "EliteBook 1040 14 inch G10"            = "01.10.00"
    "EliteBook 1040 14 inch G9"             = "01.16.01"
    
    # --- EliteBook 600-series ---
    "EliteBook 630 13 inch G9"              = "01.16.00"
    "EliteBook 630 13.3 inch G10"           = "01.10.00"
    
    # --- EliteBook 640/645 ---
    "EliteBook 640 14 inch G10"             = "01.10.00"
    "EliteBook 640 14 inch G9"              = "01.16.00"
    "EliteBook 645 14 inch G10"             = "01.11.01"
    "EliteBook 645 14 inch G9"              = "01.20.00"
    
    # --- EliteBook 650/655 ---
    "EliteBook 650 15.6 inch G10"           = "01.10.00"
    "EliteBook 650 15.6 inch G9"            = "01.16.00"
    "EliteBook 655 14 inch G9"              = "01.20.00"
    "EliteBook 655 15.6 inch G10"           = "01.11.01"
    
    # --- EliteBook 700-series (older, pre-2021) ---
    "EliteBook 735 G6"                      = "01.32.00"
    "EliteBook 745 G6"                      = "01.32.00"
    
    # --- EliteBook 830/835 ---
    "EliteBook 830 13 inch G10"             = "01.10.00"
    "EliteBook 830 13 inch G9"              = "01.16.01"
    "EliteBook 830 G6"                      = "01.33.00"
    "EliteBook 830 G7"                      = "01.22.00"
    "EliteBook 830 G8"                      = "01.22.00"
    "EliteBook 835 13 inch G10"             = "01.10.03"
    "EliteBook 835 13 inch G9"              = "01.14.00"
    "EliteBook 835 G7"                      = "01.22.00"
    "EliteBook 835 G8"                      = "01.22.00"
    
    # --- EliteBook 840/845 ---
    "EliteBook 840 14 inch G10"             = "01.10.00"
    "EliteBook 840 14 inch G9"              = "01.16.01"
    "EliteBook 840 Aero G8"                 = "01.22.00"
    "EliteBook 840 G6"                      = "01.33.00"
    "EliteBook 840 G6 Healthcare Edition"   = "01.33.00"
    "EliteBook 840 G7"                      = "01.22.00"
    "EliteBook 840 G8"                      = "01.22.00"
    "EliteBook 845 14 G10"                  = "01.10.03"
    "EliteBook 845 14 inch G9"              = "01.14.00"
    "EliteBook 845 G7"                      = "01.22.00"
    "EliteBook 845 G8"                      = "01.22.00"
    
    # --- EliteBook 846/850/855 ---
    "EliteBook 846 G6"                      = "01.33.00"
    "EliteBook 846 G6 Healthcare Edition"   = "01.33.00"
    "EliteBook 850 G6"                      = "01.33.00"
    "EliteBook 850 G7"                      = "01.22.00"
    "EliteBook 850 G8"                      = "01.22.00"
    "EliteBook 855 16 inch G9"              = "01.14.00"
    "EliteBook 855 G7"                      = "01.22.00"
    "EliteBook 855 G8"                      = "01.22.00"
    
    # --- EliteBook 860/865 ---
    "EliteBook 860 16 inch G10"             = "01.10.00"
    "EliteBook 860 16 inch G9"              = "01.16.01"
    "EliteBook 865 14 G10"                  = "01.10.03"
    
    # --- EliteBook x360 (Convertible 1030/1040/830) ---
    "EliteBook x360 1030 G7"                = "01.22.00"
    "EliteBook x360 1030 G8"                = "01.22.00"
    "EliteBook x360 1040 G6"                = "01.33.00"
    "EliteBook x360 1040 G7"                = "01.22.00"
    "EliteBook x360 1040 G8"                = "01.22.00"
    "EliteBook x360 830 G7"                 = "01.22.00"
    "EliteBook x360 830 G8"                 = "01.22.00"
    
    # --- Pro x360 (Convertible, Consumer/SMB) ---
    "Pro x360 435 13.3 inch G10"            = "01.11.01"
    "Pro x360 435 G9"                       = "01.20.00"
    "Pro x360 Fortis 11 inch G10"           = "01.15.01"
    "Pro x360 Fortis 11 inch G11"           = "01.12.00"
    "Pro x360 Fortis 11 inch G9"            = "01.15.00"
    
    # --- ProBook 430/440 ---
    "ProBook 430 G7"                        = "01.26.00"
    "ProBook 430 G8"                        = "01.22.00"
    "ProBook 430 G9"                        = "01.16.00"
    "ProBook 440 14 inch G10"               = "01.10.00"
    "ProBook 440 G7"                        = "01.26.00"
    "ProBook 440 G8"                        = "01.22.00"
    "ProBook 440 G9"                        = "01.16.00"
    
    # --- ProBook 445 ---
    "ProBook 445 14 inch G10"               = "01.11.01"
    "ProBook 445 14 inch G9"                = "01.20.00"
    "ProBook 445 G7"                        = "01.22.00"
    "ProBook 445 G8"                        = "01.22.00"
    
    # --- ProBook 450 ---
    "ProBook 450 15.6 inch G10"             = "01.10.00"
    "ProBook 450 G7"                        = "01.26.00"
    "ProBook 450 G8"                        = "01.22.00"
    "ProBook 450 G9"                        = "01.16.00"
    
    # --- ProBook 455 ---
    "ProBook 455 14 inch G9"                = "01.20.00"
    "ProBook 455 15.6 inch G10"             = "01.11.01"
    "ProBook 455 G7"                        = "01.22.00"
    "ProBook 455 G8"                        = "01.22.00"
    
    # --- ProBook 630/640/650 ---
    "ProBook 630 G8"                        = "01.22.00"
    "ProBook 635 Aero G7"                   = "01.22.00"
    "ProBook 635 Aero G8"                   = "01.22.00"
    "ProBook 640 G5"                        = "01.33.00"
    "ProBook 640 G7"                        = "01.22.00"
    "ProBook 640 G8"                        = "01.22.00"
    "ProBook 650 G5"                        = "01.33.00"
    "ProBook 650 G7"                        = "01.22.00"
    "ProBook 650 G8"                        = "01.22.00"
    
    # --- ProBook Fortis ---
    "ProBook Fortis 14 inch G10"            = "01.15.01"
    "ProBook Fortis 14 inch G9"             = "01.15.00"
    
    # --- ProBook x360 (Convertible) ---
    "ProBook x360 11 G5 EE"                 = "01.22.00"
    "ProBook x360 11 G6 EE"                 = "01.23.00"
    "ProBook x360 11 G7 EE"                 = "01.22.00"
    "ProBook x360 435 G7"                   = "01.22.00"
    "ProBook x360 435 G8"                   = "01.22.00"
    
    # --- ZBook Firefly ---
    "ZBook Firefly 15 G7"                   = "01.22.00"
    
    # --- Zhan 66 Pro (China market) ---
    "Zhan 66 Pro 14 G4"                     = "01.22.00"
    "Zhan 66 Pro 14 inch G5"                = "01.16.00"
    "Zhan 66 Pro A 14 G3"                   = "01.22.00"
    "Zhan 66 Pro A 14 G4"                   = "01.22.00"
    "Zhan 66 Pro A 14 inch G5"              = "01.20.00"
}

# Models observed in the environment that are not present in HP's published
# minimum-version table. These still use the BIOS date fallback path below.
$TrackedDateFallbackModels = @(
    'HP Spectre x360 Convertible 13-aw0xxx',
    'HP EliteBook 665 16 inch G11 Notebook PC',
    'HP EliteBook 645 14 inch G11 Notebook PC'
)

# Fallback: BIOS release date threshold used for models NOT in the table above.
# HP shipped Secure Boot-compatible firmware broadly from July 2025 onward.
# Devices with a BIOS dated before this are flagged as potentially needing an update.
# Set to $null to disable the date fallback and report unknown models as COMPLIANT.
[DateTime]$FallbackMinBiosDate = "2025-07-08"

# Registry paths from Microsoft's Secure Boot guidance
$SbBasePath     = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot"
$SbServicingPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing"

# =============================================================================
# HELPER FUNCTIONS
# =============================================================================

function Compare-HpBiosVersion {
    <#
    .SYNOPSIS Compares two HP BIOS version strings. Returns $true if $Current >= $Minimum. #>
    param (
        [string]$Current,
        [string]$Minimum
    )
    try {
        $curr = [Version]$Current
        $min  = [Version]$Minimum
        return ($curr -ge $min)
    }
    catch {
        # Fallback: string comparison (less reliable)
        return ($Current -ge $Minimum)
    }
}

function Get-HpBiosVersionNumber {
    <#
    .SYNOPSIS
        Extracts the version number from an HP BIOS version string.
        Handles formats:
          "S70 Ver. 02.38.00 01/22/2026" → "02.38.00"
          "N86 Ver. 01.23.02"             → "01.23.02"
          "F.80"                           → "F.80" (older consumer format)
    #>
    param ([string]$RawVersion)
    if ($RawVersion -match 'Ver\.\s*(\d+\.\d+\.\d+)') {
        return $Matches[1]
    }
    # Older format: F.XX
    if ($RawVersion -match '^([A-Z]\.\d+)') {
        return $Matches[1]
    }
    # Return raw if no pattern matched
    return $RawVersion.Trim()
}

# =============================================================================
# MAIN DETECTION LOGIC
# =============================================================================

try {
    # 1. Manufacturer check — skip non-HP devices
    $cs = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction Stop
    if ($cs.Manufacturer -notmatch "HP|Hewlett-Packard|Hewlett Packard") {
        Write-Output "SKIP: Not an HP device (Manufacturer: $($cs.Manufacturer))"
        exit 0
    }

    $model = $cs.Model.Trim()

    # 2. BIOS information
    $biosWmi     = Get-CimInstance -ClassName Win32_BIOS -ErrorAction Stop
    $rawVersion  = $biosWmi.SMBIOSBIOSVersion
    $biosVersion = Get-HpBiosVersionNumber -RawVersion $rawVersion

    # BIOS release date (from SMBIOS)
    $biosDateRaw = $biosWmi.ReleaseDate
    # ReleaseDate from CIM is already a [DateTime] object
    $biosDate    = if ($biosDateRaw -is [DateTime]) { $biosDateRaw } else { [DateTime]::MinValue }
    $biosDateStr = if ($biosDate -ne [DateTime]::MinValue) { $biosDate.ToString("yyyy-MM-dd") } else { "Unknown" }

    # 3. Check authoritative Microsoft registry key — UEFICA2023Status
    $uefiStatus = $null
    $uefiError  = $null
    if (Test-Path $SbServicingPath) {
        $uefiStatus = (Get-ItemProperty -Path $SbServicingPath -Name "UEFICA2023Status" -ErrorAction SilentlyContinue).UEFICA2023Status
        $uefiError  = (Get-ItemProperty -Path $SbServicingPath -Name "UEFICA2023Error"  -ErrorAction SilentlyContinue).UEFICA2023Error
    }

    # Helper to emit result and exit
    $baseInfo = "Model: $model | BIOS: $biosVersion | Date: $biosDateStr"

    # 3a. Already updated — certs are deployed, nothing to do
    if ($uefiStatus -eq "Updated") {
        Write-Output "$baseInfo | Status: COMPLIANT | Reason: Secure Boot CA 2023 certificates already deployed"
        exit 0
    }

    # 3b. Error state — definite non-compliance
    if ($null -ne $uefiError -and $uefiError -ne 0) {
        Write-Output "$baseInfo | Status: NON-COMPLIANT | Reason: UEFI CA 2023 error (code: $uefiError) - BIOS update required"
        exit 1
    }

    # 4. Version table lookup — match by model substring (longest match wins)
    $matchedKey     = $null
    $matchedMinVer  = $null
    $longestMatch   = 0

    foreach ($entry in $MinFirmwareVersions.GetEnumerator()) {
        if ($model -match [regex]::Escape($entry.Key) -and $entry.Key.Length -gt $longestMatch) {
            $matchedKey    = $entry.Key
            $matchedMinVer = $entry.Value
            $longestMatch  = $entry.Key.Length
        }
    }

    if ($matchedKey) {
        $isReady = Compare-HpBiosVersion -Current $biosVersion -Minimum $matchedMinVer
        if ($isReady) {
            Write-Output "$baseInfo | Status: COMPLIANT | Reason: BIOS $biosVersion meets minimum required $matchedMinVer for $matchedKey"
            exit 0
        }
        else {
            Write-Output "$baseInfo | Status: NON-COMPLIANT | Reason: BIOS $biosVersion is below minimum required $matchedMinVer for $matchedKey - update BIOS from HP"
            exit 1
        }
    }

    $isTrackedDateFallbackModel = $false
    foreach ($trackedModel in $TrackedDateFallbackModels) {
        if ($model -match [regex]::Escape($trackedModel)) {
            $isTrackedDateFallbackModel = $true
            break
        }
    }

    # 5. Fallback: BIOS date check for models not in the version table
    if ($null -ne $FallbackMinBiosDate -and $biosDate -ne [DateTime]::MinValue) {
        if ($biosDate -ge $FallbackMinBiosDate) {
            if ($isTrackedDateFallbackModel) {
                Write-Output "$baseInfo | Status: COMPLIANT | Reason: BIOS date $biosDateStr is on/after $($FallbackMinBiosDate.ToString('yyyy-MM-dd')) (tracked model, no HP minimum version published in table)"
            }
            else {
                Write-Output "$baseInfo | Status: COMPLIANT | Reason: BIOS date $biosDateStr is on/after $($FallbackMinBiosDate.ToString('yyyy-MM-dd')) (model not in version table)"
            }
            exit 0
        }
        else {
            if ($isTrackedDateFallbackModel) {
                Write-Output "$baseInfo | Status: NON-COMPLIANT | Reason: BIOS date $biosDateStr is before $($FallbackMinBiosDate.ToString('yyyy-MM-dd')) - tracked model is not in HP's published minimum version table"
            }
            else {
                Write-Output "$baseInfo | Status: NON-COMPLIANT | Reason: BIOS date $biosDateStr is before $($FallbackMinBiosDate.ToString('yyyy-MM-dd')) - check HP firmware list for minimum version (model not in table)"
            }
            exit 1
        }
    }

    # 6. Unknown — model not in table, BIOS date unavailable, no definitive registry state
    Write-Output "$baseInfo | Status: NON-COMPLIANT | Reason: Cannot determine readiness (model not in version table, BIOS date unavailable) - verify manually"
    exit 1
}
catch {
    Write-Output "ERROR: Detection script failed - $($_.Exception.Message)"
    exit 1
}

#Requires -Version 5.1
<#
.SYNOPSIS
    Intune Proactive Remediation — Remediation Script
    HP BIOS Firmware Readiness for 2026 Secure Boot Certificate Update

.DESCRIPTION
    Companion to Detect-HPSecureBootBIOS.ps1.

    This script runs ONLY on devices where the detection script exited 1
    (Non-Compliant). It performs NO automated BIOS update — HP firmware updates
    must not be silently deployed without administrator approval.

    What this script does:
      - Re-collects device info (model, BIOS version, BIOS date)
      - Checks the Secure Boot registry status keys
      - Writes a detailed diagnostic output visible in Intune portal
      - Exits 0 to signal remediation "completed" (action logged, no error)

    Required follow-up action (by IT Administrator):
      1. Review the device output in Intune (Devices → Remediations → Device status)
      2. Look up the minimum required BIOS version for the reported model at:
         https://support.hp.com/us-en/document/ish_13070381-13192099-16
      3. Deploy the BIOS update via HP SoftPaq / HPIA / MECM / Intune Win32 app
         to the flagged devices before applying Microsoft's Secure Boot cert update.

.NOTES
    This script intentionally does NOT modify BIOS firmware.
    Automated BIOS updates carry risk of data loss if interrupted; always
    deploy firmware updates through an approved, tested delivery mechanism.

    Sources:
    - HP:  https://support.hp.com/us-en/document/ish_13070381-13192099-16
    - MS:  https://aka.ms/GetSecureBoot
    Revision: 1.0 — 2026-03-11
#>

$SbBasePath      = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot"
$SbServicingPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing"

function Get-HpBiosVersionNumber {
    param ([string]$RawVersion)
    if ($RawVersion -match 'Ver\.\s*(\d+\.\d+\.\d+)') { return $Matches[1] }
    if ($RawVersion -match '^([A-Z]\.\d+)')            { return $Matches[1] }
    return $RawVersion.Trim()
}

try {
    # --- Collect device info ---
    $cs          = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction Stop
    $biosWmi     = Get-CimInstance -ClassName Win32_BIOS           -ErrorAction Stop
    $os          = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop

    $manufacturer = $cs.Manufacturer
    $model        = $cs.Model.Trim()
    $rawVersion   = $biosWmi.SMBIOSBIOSVersion
    $biosVersion  = Get-HpBiosVersionNumber -RawVersion $rawVersion
    $biosDateRaw  = $biosWmi.ReleaseDate
    $biosDate     = if ($biosDateRaw -is [DateTime]) { $biosDateRaw.ToString("yyyy-MM-dd") } else { "Unknown" }
    $osCaption    = $os.Caption
    $osBuild      = $os.BuildNumber
    $pcName       = $env:COMPUTERNAME

    # --- Secure Boot registry state ---
    $uefiStatus       = $null
    $uefiError        = $null
    $availableUpdates = $null
    if (Test-Path $SbServicingPath) {
        $uefiStatus = (Get-ItemProperty -Path $SbServicingPath -Name "UEFICA2023Status" -ErrorAction SilentlyContinue).UEFICA2023Status
        $uefiError  = (Get-ItemProperty -Path $SbServicingPath -Name "UEFICA2023Error"  -ErrorAction SilentlyContinue).UEFICA2023Error
    }
    if (Test-Path $SbBasePath) {
        $availableUpdates = (Get-ItemProperty -Path $SbBasePath -Name "AvailableUpdates" -ErrorAction SilentlyContinue).AvailableUpdates
    }

    # --- Secure Boot enabled check ---
    $sbEnabled = $false
    try {
        $sbEnabled = Confirm-SecureBootUEFI -ErrorAction SilentlyContinue
    }
    catch { $sbEnabled = $false }

    # --- Format output ---
    $lines = @(
        "=== HP Secure Boot BIOS Readiness — Diagnostic Report ==="
        "Timestamp        : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss UTC' -AsUTC)"
        "Computer Name    : $pcName"
        "Manufacturer     : $manufacturer"
        "Model            : $model"
        "BIOS Version     : $biosVersion  (raw: $rawVersion)"
        "BIOS Date        : $biosDate"
        "OS               : $osCaption (Build $osBuild)"
        "Secure Boot ON   : $sbEnabled"
        "---"
        "UEFICA2023Status : $(if ($null -eq $uefiStatus) { '(key not present)' } else { $uefiStatus })"
        "UEFICA2023Error  : $(if ($null -eq $uefiError)  { '(no error)' }        else { $uefiError })"
        "AvailableUpdates : $(if ($null -eq $availableUpdates) { '(key not present)' } else { '0x{0:X4}' -f $availableUpdates })"
        "---"
        "ACTION REQUIRED  : Review model $model against HP's minimum BIOS version list:"
        "                 : https://support.hp.com/us-en/document/ish_13070381-13192099-16"
        "                 : Deploy the relevant HP BIOS update before applying Secure Boot cert update."
    )

    $report = $lines -join "`n"
    Write-Output $report

    # Exit 0 — remediation script has logged the issue; actual BIOS update is manual
    exit 0
}
catch {
    Write-Output "ERROR: Remediation diagnostic failed - $($_.Exception.Message)"
    exit 1
}

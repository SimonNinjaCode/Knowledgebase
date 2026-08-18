# Secure Boot Certificate Update Guide 2026

## Intune-Focused Operations Guide for IT Administrators

**Last Updated:** 2026-02-16
**Status:** Actionable - Deployment required before June 2026
**Primary Tool:** Microsoft Intune (Settings Catalog)

---

## Executive Summary

Microsoft's original Secure Boot certificates, issued in 2011, are reaching end-of-life and will begin expiring in **June 2026**. These certificates form the root of trust for the Secure Boot process on virtually every Windows device manufactured since 2012. They protect devices from bootkits and other boot-level malware by validating the integrity of firmware and operating system boot components.

Four certificates must be replaced with their 2023 counterparts. The Key Exchange Key (KEK) and two UEFI CA certificates expire in **June 2026**, while the Windows Production PCA expires in **October 2026**. If devices are not updated before these deadlines, they will continue to function but enter a **degraded security state** where they can no longer receive boot-level security protections, Windows Boot Manager updates, Secure Boot database revocations, or mitigations for newly discovered boot vulnerabilities. Over time this will also lead to compatibility issues with newer operating systems, firmware, and hardware.

**Action required:** Organizations managing Windows devices through Intune must complete a phased deployment of 2023 Secure Boot certificates. This involves (1) inventorying your fleet, (2) applying OEM firmware updates first, (3) deploying certificate updates via Intune Settings Catalog, and (4) monitoring deployment progress through registry keys and event logs. The deployment process requires approximately 48 hours and multiple restarts per device.

---

## Certificate Expiration Reference

| Expiring Certificate | Expires | Replacement Certificate | Storage | Purpose |
|---|---|---|---|---|
| Microsoft Corporation KEK CA 2011 | **June 2026** | Microsoft Corporation KEK 2K CA 2023 | KEK | Signs DB/DBX updates |
| Microsoft Windows Production PCA 2011 | **October 2026** | Windows UEFI CA 2023 | DB | Signs Windows boot loader |
| Microsoft Corporation UEFI CA 2011 | **June 2026** | Microsoft UEFI CA 2023 | DB | Signs third-party boot loaders |
| Microsoft Corporation UEFI CA 2011 (Option ROM) | **June 2026** | Microsoft Option ROM UEFI CA 2023 | DB | Signs Option ROM components |

---

## Phase 1: Inventory and Preparation

### 1.1 Verify Secure Boot Status

Run on target devices to confirm Secure Boot is enabled:

```powershell
Confirm-SecureBootUEFI
```

Returns `True` if Secure Boot is enabled. Devices returning `False` or `$null` do not need certificate updates (but should be evaluated for why Secure Boot is disabled).

This can be used as an Intune custom compliance script to identify non-compliant devices fleet-wide.

### 1.2 Collect Device Inventory

Gather the following attributes for each device to categorize your fleet:

- OEM manufacturer and model
- Firmware version and date
- Baseboard product identifier
- Current `UEFICA2023Status` registry value

**Registry location for status:**

```
HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing
```

Key values:
| Registry Value | Description |
|---|---|
| `UEFICA2023Status` | `NotStarted`, `InProgress`, or `Updated` |
| `WindowsUEFICA2023Capable` | Device capability indicator |
| `UEFICA2023Error` | Error details if deployment fails |

### 1.3 Use Windows Autopatch Reporting

Windows Autopatch includes a **Secure Boot status report** that provides fleet-wide visibility into certificate deployment status. Use this to identify devices that have not yet started the update process.

### 1.4 Plan Pilot Groups

- Test on at least **4 representative devices per unique hardware category** (manufacturer/model/firmware combination)
- Focus pilot testing on **less common device models** first, as these are more likely to encounter issues
- Include devices from each OEM vendor in your fleet

---

## Phase 2: OEM Firmware Updates (Do This First)

**OEM BIOS/UEFI firmware must be updated BEFORE deploying Windows certificate updates.** OEM firmware updates include updated certificate stores and compatibility fixes required for the Windows-side deployment to succeed.

See the [Vendor-Specific Guidance](#vendor-specific-guidance) section below for timelines and tools per manufacturer.

General guidance:
1. Check your OEM support page for the latest BIOS/UEFI update for each device model
2. Deploy firmware updates through your existing BIOS management tools (Dell Command Update, HP MIK/SCCM, Lenovo System Update, etc.) or via Intune driver update policies where supported
3. Validate firmware updates are applied before proceeding to Phase 3

---

## Phase 3: Intune Deployment (Primary Method)

### 3.1 Create Intune Configuration Policy

1. Navigate to **Microsoft Intune admin center** > **Devices** > **Manage devices** > **Configuration**
2. Select **Create** > **New Policy**
3. Platform: **Windows 10 and later**
4. Profile type: **Settings Catalog**
5. Name the profile (e.g., `Secure Boot Certificate Update 2023`)

### 3.2 Configure Settings

Under **Configuration settings**, select **Add settings** and search for **"Secure Boot"**. Configure the three available settings:

| Setting | Recommended Value | Description |
|---|---|---|
| **Enable Secureboot Certificate Updates** | **Enabled** | Initiates the certificate deployment servicing flow. The scheduled task processes this every 12 hours. |
| **Configure Microsoft Update Managed Opt In** | **Enabled** | Enrolls device in Microsoft's Controlled Feature Rollout (CFR). Requires diagnostic data set to "Required" or higher. |
| **Configure High Confidence Opt-Out** | **Disabled** | Allows automatic monthly update deployment on devices Microsoft has validated as capable. Set to Enabled only if you want to block auto-deployment. |

### 3.3 Registry Key Equivalents

For reference and validation, the Intune settings map to these registry values under `HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot`:

| Intune Setting | Registry Value | Data |
|---|---|---|
| Enable Secureboot Certificate Updates | `AvailableUpdates` | `0x5944` (DWORD) |
| Configure Microsoft Update Managed Opt In | `MicrosoftUpdateManagedOptIn` | `1` (DWORD) |
| Configure High Confidence Opt-Out | `HighConfidenceOptOut` | `0` (DWORD) |

### 3.4 Assign and Deploy

1. Assign the policy to a **pilot device group** first
2. Monitor results for 48+ hours (see Phase 4)
3. Expand to broader device groups in waves
4. Assign to all managed devices once confident

### 3.5 Prerequisites and Constraints

- Devices must be **enrolled in Intune MDM**
- Diagnostic data must be set to **Required** or higher for the Managed Opt In setting to function
- **Windows Pro editions**: A licensing service update on January 27, 2026 resolved an issue (error 65000) blocking deployment on Pro editions. Licenses auto-renew monthly, so all devices should be resolved by February 27, 2026
- **Do NOT mix deployment methods** (Intune, GPO, Registry, WinCS) on the same device

### 3.6 Known Issue: Error 65000 on Windows Pro

If Windows Pro devices show error code 65000, the Intune license needs renewal. To force resolution:

```cmd
ClipDLS.exe removesubscription
ClipRenew.exe
```

This issue was resolved server-side by Microsoft on January 27, 2026. All devices should auto-resolve by February 27, 2026.

---

## Phase 4: Monitoring and Validation

### 4.1 Registry Key Monitoring

Monitor `UEFICA2023Status` under `HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing`:

| Status Value | Meaning |
|---|---|
| `NotStarted` | Certificate deployment has not begun |
| `InProgress` | Deployment is processing (allow 48 hours) |
| `Updated` | All 2023 certificates successfully applied |

### 4.2 Event Log Monitoring

Check the Windows Event Log for these event IDs:

| Event ID | Type | Meaning |
|---|---|---|
| **1808** | Informational | 2023 certificates successfully applied |
| **1801** | Error | Certificate deployment failed; includes device attributes for correlation |
| **1795** | Error | Firmware returned an error during DB/KEK update (contact OEM for firmware fix) |
| **1796** | Error | KEK update failure |

### 4.3 AvailableUpdates Progression

The `AvailableUpdates` registry value decrements as each certificate component is applied. The scheduled task processes bits in order every 12 hours:

| AvailableUpdates Value | Status |
|---|---|
| `0x5944` | Starting state - all updates pending |
| `0x5904` | Windows UEFI CA 2023 added to DB |
| `0x5104` | Option ROM UEFI CA 2023 applied |
| `0x4104` | UEFI CA 2023 applied |
| `0x4100` | KEK 2K CA 2023 applied |
| `0x4000` | New boot manager applied - **deployment complete** |

### 4.4 AvailableUpdates Bit Reference

| Bit | Action |
|---|---|
| `0x0040` | Add Windows UEFI CA 2023 to DB |
| `0x0800` | Apply Microsoft Option ROM UEFI CA 2023 to DB |
| `0x1000` | Apply Microsoft UEFI CA 2023 to DB |
| `0x4000` | Conditional flag (apply 0x0800/0x1000 only if UEFI CA 2011 exists) |
| `0x0004` | Apply Microsoft Corporation KEK 2K CA 2023 (OEM-signed) |
| `0x0100` | Apply Windows UEFI CA 2023-signed boot manager |

---

## Phase 5: Remediation and Troubleshooting

### 5.1 Common Issues

| Issue | Symptom | Resolution |
|---|---|---|
| KEK deployment failure | Error `800703e6`; AvailableUpdates stuck at `0x4104` | OEM has not signed new Microsoft KEK with device's Platform Key. Contact OEM for updated firmware. |
| Firmware handoff error | Event ID 1795 | Firmware is returning errors when applying DB/KEK updates. Apply latest OEM firmware update. |
| Licensing error (Pro) | Error code 65000 | Run `ClipDLS.exe removesubscription` then `ClipRenew.exe`. Auto-resolves by Feb 27, 2026. |
| Hyper-V VM KEK failure | "Media is write protected" on VMs | Fix planned in **March 2026** Windows update and Azure release. |
| VMware ESXi | KEK update limitations | Check VMware support for compatibility guidance. |

### 5.2 Microsoft Confidence Levels

Microsoft classifies device models based on diagnostic data telemetry:

| Confidence Level | Meaning | Action |
|---|---|---|
| **High Confidence** | Microsoft has validated this device class | Safe to deploy |
| **Under Observation** | Microsoft is still collecting data | Wait for classification update |
| **No Data Observed** | Insufficient telemetry data | Enterprise must test independently |
| **Temporarily Paused** | Known issue identified | Check OEM for BIOS updates |
| **Not Supported** | Device cannot be updated | Document as exception; consider hardware replacement |

---

## Alternative Deployment Methods

While Intune is the recommended approach for managed environments, these alternatives are available:

### Group Policy (GPO)

Navigate to: **Computer Configuration** > **Administrative Templates** > **Windows Components** > **Secure Boot**

Set **"Enable Secure Boot certificate deployment"** to **Enabled**.

Reference: KB 5068198

### Registry Keys (Direct)

Set the following under `HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot`:

```reg
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecureBoot]
"AvailableUpdates"=dword:00005944
```

Reference: KB 5068202

### Windows Configuration System (WinCS)

Available for Windows 11 (25H2, 24H2, 23H2) domain-joined clients:

- Feature name: `Feature_AllKeysAndBootMgrByWinCS`
- WinCS key value: `F33E0C8E002`

Reference: KB 5068197

---

## PowerShell Monitoring Script

Use this script to collect Secure Boot status across your fleet. Deploy via Intune Proactive Remediation or run manually:

```powershell
# Secure Boot Certificate Status Collection
$sbPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot"
$svcPath = "$sbPath\Servicing"
$attrPath = "$svcPath\DeviceAttributes"

$result = [PSCustomObject]@{
    Hostname              = $env:COMPUTERNAME
    CollectionTime        = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    SecureBootEnabled     = (Confirm-SecureBootUEFI)
    AvailableUpdates      = (Get-ItemProperty -Path $sbPath -Name "AvailableUpdates" -ErrorAction SilentlyContinue).AvailableUpdates
    HighConfidenceOptOut  = (Get-ItemProperty -Path $sbPath -Name "HighConfidenceOptOut" -ErrorAction SilentlyContinue).HighConfidenceOptOut
    UEFICA2023Status      = (Get-ItemProperty -Path $svcPath -Name "UEFICA2023Status" -ErrorAction SilentlyContinue).UEFICA2023Status
    UEFICA2023Error       = (Get-ItemProperty -Path $svcPath -Name "UEFICA2023Error" -ErrorAction SilentlyContinue).UEFICA2023Error
    Capable               = (Get-ItemProperty -Path $svcPath -Name "WindowsUEFICA2023Capable" -ErrorAction SilentlyContinue).WindowsUEFICA2023Capable
    Manufacturer          = (Get-ItemProperty -Path $attrPath -Name "Manufacturer" -ErrorAction SilentlyContinue).Manufacturer
    Model                 = (Get-ItemProperty -Path $attrPath -Name "Model" -ErrorAction SilentlyContinue).Model
    FirmwareVersion       = (Get-ItemProperty -Path $attrPath -Name "FirmwareVersion" -ErrorAction SilentlyContinue).FirmwareVersion
}

$result | Format-List
```

---

## Vendor-Specific Guidance

### Dell

| Item | Detail |
|---|---|
| **BIOS Timeline** | All Dell BIOSes released after **January 1, 2026** include 2023 Secure Boot certificates. Dell began adding 2023 certs to eligible platforms throughout 2024-2025. |
| **Recommendation** | Keep device BIOS updated to the latest version. Apply BIOS updates before Windows certificate deployment. |
| **Deployment Tools** | Dell Command Update, Dell BIOS Connect, Dell Command | Configure |
| **PowerEdge Servers** | Separate guidance available - see KB 000362511 |
| **Out-of-Scope Platforms** | Older platforms that will NOT receive BIOS updates are documented in KB 000378734 |
| **Intune Integration** | Dell firmware updates can be deployed via Intune Windows driver update policies for supported models |

**Dell Reference Articles:**

| KB | Description |
|---|---|
| [000347876](https://www.dell.com/support/kbdoc/en-us/000347876/microsoft-2011-secure-boot-certificate-expiration) | Main certificate expiration guidance |
| [000390990](https://www.dell.com/support/kbdoc/en-us/000390990/secure-boot-transition-faq) | Secure Boot Transition FAQ |
| [000362511](https://www.dell.com/support/kbdoc/en-us/000362511/microsoft-secure-boot-2011-certificate-expiration-impact-on-dell-poweredge-servers) | PowerEdge Server impact |
| [000378734](https://www.dell.com/support/kbdoc/en-us/000378734/microsoft-2011-secure-boot-certificates-expiration-for-out-of-scope-platforms-for-bios-updates) | Out-of-scope platforms (no BIOS update) |
| [000412391](https://www.dell.com/support/kbdoc/en-us/000412391/dsn-2026-001-dell-proactive-messaging-regarding-upcoming-microsoft-secure-boot-certificate-expiration) | DSN-2026-001 Proactive notification |

---

### HP

| Item | Detail |
|---|---|
| **2024 and newer PCs** | Already shipped with 2023 Secure Boot certificates. No firmware action needed. |
| **2022-2023 PCs** | BIOS updates targeted by **September 30, 2025** |
| **2018-2021 PCs** | BIOS updates targeted by **December 31, 2025** |
| **Pre-2017 PCs** | **Will NOT receive BIOS updates.** These devices cannot complete the certificate transition. |
| **Deployment Tools** | HP MIK, HP Client Management Script Library, HP BIOS Configuration Utility (BCU), SCCM/Intune driver packages |
| **Known Issue** | Some August 2025 BIOS updates did not contain updated KEK and DB certificates (still dated 2011). Check HP support for revised updates. |

**HP Reference Articles:**

| Document | Description |
|---|---|
| [ish_13070381-13192099-16](https://support.hp.com/se-sv/document/ish_13070381-13192099-16) | HP Secure Boot certificate update guidance |
| [ish_13070353-13070429-16](https://support.hp.com/us-en/document/ish_13070353-13070429-16) | HP PCs - Prepare for new Windows Secure Boot certificates |

---

### Lenovo

| Item | Detail |
|---|---|
| **Scope** | Commercial PCs (ThinkPad, ThinkCentre, ThinkStation) |
| **Recommendation** | Check Lenovo Support for model-specific BIOS updates containing 2023 certificates |
| **Deployment Tools** | Lenovo System Update, Lenovo Vantage, Lenovo BIOS Update Utility, Lenovo Thin Installer |
| **Intune Integration** | Lenovo provides Intune-compatible driver/firmware update packages via Lenovo Commercial Deployment Readiness resources |
| **Reference** | [HT518129](https://support.lenovo.com/us/en/solutions/HT518129) - 2011 Microsoft Secure Boot Certificate Expiration for Lenovo Commercial PCs |

---

### Microsoft Surface

| Item | Detail |
|---|---|
| **2024+ Models (No action needed)** | Surface Laptop 13", Pro 12", Laptop 5G for Business, Laptop 7th Edition (Intel & Snapdragon), Pro 11th Edition (Intel, 5G, Snapdragon), Laptop 6 for Business, Pro 10 with 5G, Pro 10 for Business, Hub 3 |
| **Older Models (UEFI update required)** | Surface Go 4, Laptop Go 3, Laptop Studio 2, Laptop 5, Pro 9 / Pro 9 with 5G, Windows Dev Kit 2023, Studio 2+, Laptop Go 2, Laptop SE, Pro X WiFi, Go 3, Pro 8, Laptop Studio, Laptop 4 (Intel/AMD), Pro 7+, Pro 7, Book 3 |
| **Update Delivery** | Microsoft delivers Surface firmware updates directly via Windows Update. UEFI Secure Boot Signature Database updates with "Windows UEFI CA 2023" began in 2023. |
| **Recovery Images** | Being updated for all supported models. Surface Hub 3 recovery images available from January 2026. |
| **Intune Integration** | Surface firmware updates deploy through Windows Update for Business / Intune driver update policies. No separate OEM tool needed. |
| **Reference** | [Surface Secure Boot certificates](https://support.microsoft.com/en-gb/surface/surface-secure-boot-certificates-532abf3b-bafe-420f-b615-bf174105549e) |

---

## Key Constraints and Warnings

- **Do NOT mix deployment methods** on the same device (choose one: Intune, GPO, Registry, or WinCS)
- **VMware ESXi** environments may have KEK update limitations - verify with VMware support
- **Diagnostic data** must be set to Required or higher for CFR/Managed Opt-In to function
- The scheduled task runs **every 12 hours** - allow **48 hours and multiple restarts** for full completion
- **New devices (1-2 years old)** may already have 2023 certificates in DB but still need the Windows UEFI CA 2023-signed boot manager
- Avoid deploying certificate updates **before** OEM firmware updates are applied

---

## Microsoft KB Reference Index

| KB Article | Title / Description |
|---|---|
| [KB 5062710](https://support.microsoft.com/topic/5062710) | Certificate expiration overview |
| [KB 5062711](https://support.microsoft.com/topic/5062711) | Guidance for Microsoft-managed home/school devices |
| [KB 5062713](https://support.microsoft.com/en-us/topic/secure-boot-certificate-updates-guidance-for-it-professionals-and-organizations-e2b43f9f-b424-42df-bc6a-8476db65ab2f) | IT professional and organization guidance (main reference) |
| [KB 5068008](https://support.microsoft.com/topic/5068008) | Secure Boot FAQ |
| [KB 5068197](https://support.microsoft.com/topic/5068197) | WinCS deployment method |
| [KB 5068198](https://support.microsoft.com/topic/5068198) | Group Policy deployment method |
| [KB 5068202](https://support.microsoft.com/topic/5068202) | Registry key deployment method |
| [KB 5073196](https://support.microsoft.com/en-us/topic/microsoft-intune-method-of-secure-boot-for-windows-devices-with-it-managed-updates-1c4cf9a3-8983-40c8-924f-44d9c959889d) | Microsoft Intune deployment method |
| [KB 5079373](https://support.microsoft.com/topic/5079373) | Certificate expiration timing details |
| [KB 5066426](https://support.microsoft.com/topic/5066426) | Key creation and management guidance (for OEMs) |
| [KB 5067177](https://support.microsoft.com/topic/5067177) | OEM-specific support pages |

---

## Source References

### Microsoft Core Sources
1. [Refreshing the Root of Trust: Industry Collaboration on Secure Boot Certificate Updates](https://blogs.windows.com/windowsexperience/2026/02/10/refreshing-the-root-of-trust-industry-collaboration-on-secure-boot-certificate-updates/) - Windows Experience Blog
2. [Secure Boot Playbook for Certificates Expiring in 2026](https://techcommunity.microsoft.com/blog/windows-itpro-blog/secure-boot-playbook-for-certificates-expiring-in-2026/4469235) - Windows IT Pro Blog
3. [Windows Secure Boot Certificate Expiration and CA Updates](https://support.microsoft.com/en-gb/topic/windows-secure-boot-certificate-expiration-and-ca-updates-7ff40d33-95dc-4c3c-8725-a9b95457578e) - Microsoft Support
4. [Surface Secure Boot Certificates](https://support.microsoft.com/en-gb/surface/surface-secure-boot-certificates-532abf3b-bafe-420f-b615-bf174105549e) - Microsoft Surface Support
5. [Intune Method for Secure Boot Certificate Updates](https://support.microsoft.com/en-us/topic/microsoft-intune-method-of-secure-boot-for-windows-devices-with-it-managed-updates-1c4cf9a3-8983-40c8-924f-44d9c959889d) - Microsoft Support
6. [IT Professional Guidance for Secure Boot Certificate Updates](https://support.microsoft.com/en-us/topic/secure-boot-certificate-updates-guidance-for-it-professionals-and-organizations-e2b43f9f-b424-42df-bc6a-8476db65ab2f) - Microsoft Support
7. https://support.microsoft.com/en-us/topic/how-to-manage-the-windows-boot-manager-revocations-for-secure-boot-changes-associated-with-cve-2023-24932-41a975df-beb2-40c1-99a3-b3ff139f832d#bkmk_enforce
8. https://support.microsoft.com/en-us/topic/enterprise-deployment-guidance-for-cve-2023-24932-88b8f034-20b7-4a45-80cb-c6049b0f9967#id0ebbf=apply&id0ebbl=what_to_apply&id0ebbj=apply




### Vendor Sources
7. [Dell - Microsoft 2011 Secure Boot Certificate Expiration](https://www.dell.com/support/kbdoc/en-us/000347876/microsoft-2011-secure-boot-certificate-expiration) - Dell Support
8. [HP - Prepare for New Windows Secure Boot Certificates](https://support.hp.com/se-sv/document/ish_13070381-13192099-16) - HP Support
9. [Lenovo - 2011 Microsoft Secure Boot Certificate Expiration](https://support.lenovo.com/us/en/solutions/HT518129) - Lenovo Support

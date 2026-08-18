# Attack Surface Reduction

<!-- TOC tocDepth:2..3 chapterDepth:2..6 -->

- [Supported Platforms](#supported-platforms)
- [Requirements - Licensing](#requirements---licensing)
- [Requirements - Technical](#requirements---technical)
- [Rule Types](#rule-types)
- [Rule Names & GUIDS](#rule-names-guids)
- [Defender XDR - Attack Surface Reduction Detections](#defender-xdr---attack-surface-reduction-detections)
- [Get started with Advanced Hunting](#get-started-with-advanced-hunting)
- [KQL Queries for ASR Rules](#kql-queries-for-asr-rules)
- [Event Logs (Local)](#event-logs-local)
    - [Security Logs](#security-logs)
    - [Microsoft/Windows/Windows Defender/Operational](#microsoftwindowswindows-defenderoperational)
- [Detections (E5)](#detections-e5)
- [Configurations (E5)](#configurations-e5)
- [ASR Licensing Requirements](#asr-licensing-requirements)
- [Human Operated Ransomware](#human-operated-ransomware)
- [PPTX Human Operated Ransomware](#pptx-human-operated-ransomware)

<!-- /TOC -->

## Supported Platforms
- Windows Pro/Enterprise
- Windows Server 2019+

## Requirements - Licensing
- Minimum - Windows 10/11 Enterprise (E3)
- Recommended - Windows 10/11 Enterprise (E5) - Adds additional reporting/hunting capabilities (Defender)

## Requirements - Technical
- Microsoft Defender Antivirus as primary AV (real-time protection on)
- Minimum platform release requirement: 4.18.2008.9
- Minimum engine release requirement: 1.1.17400.5

# Attack Surface Reduction Rules

## Rule Types

| Polymorphic threats | Lateral movement & credential theft | Productivity apps rules | Email rules | Script rules | Misc rules |
|---------------------|-------------------------------------|-------------------------|-------------|-------------|------------|
| Block executable files from running unless they meet a prevalence (1000 machines), age (24 hrs), or trusted list criteria | Block process creations originating from PSExec and WMI commands | Block Office apps from creating executable content | Block executable content from email client and webmail | Block obfuscated JS/VBS/PS/macro code | Block abuse of exploited vulnerable signed drivers |
| Block untrusted and unsigned processes that run from USB | Block credential stealing from the Windows local security authority subsystem (lsass.exe) | Block Office apps from creating child processes | Block only Office communication applications from creating child processes | Block JS/VBS from launching downloaded executable content | |
| Use advanced protection against ransomware | Block persistence through WMI event subscription | Block Office apps from injecting code into other processes + Block Adobe Reader from creating child processes | Block Office communication apps from creating child processes | | |

## Rule Names & GUIDS

| Rule name | GUID | File & folder exclusions |
|-----------|------|--------------------------|
| Block executable content from email client and webmail | BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550 | Supported |
| Block all Office applications from creating child processes | D4F940AB-401B-4EFC-AADC-AD5F3C50688A | Supported |
| Block Office applications from creating executable content | 3B576869-A4EC-4529-8536-B80A7769E899 | Supported |
| Block Office applications from injecting code into other processes | 75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84 | Supported |
| Block JavaScript or VBScript from launching downloaded executable content | D3E037E1-3EB8-44C8-A917-57927947596D | Supported |
| Block execution of potentially obfuscated scripts | 5BEB7EFE-FD9A-4556-801D-275E5FFC04CC | Supported |
| Block Win32 API calls from Office macros | 92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B | Supported |
| Block executable files from running unless they meet a prevalence, age, or trusted list criterion | 01443614-cd74-433a-b99e-2ecdc07bfc25 | Supported |
| Use advanced protection against ransomware | c1db55ab-c21a-4637-bb3f-a12568109d35 | Supported |
| Block credential stealing from the Windows local security authority subsystem (lsass.exe) | 9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2 | Supported |
| Block process creations originating from PSExec and WMI commands | d1e49aac-8f56-4280-b9ba-993a6d77406c | Supported |
| Block untrusted and unsigned processes that run from USB | b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4 | Supported |
| Block Office communication application from creating child processes | 26190899-1602-49e8-8b27-eb1d0a1ce869 | Supported |
| Block Adobe Reader from creating child processes | 7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c | Supported |
| Block persistence through WMI event subscription | e6db77e5-3df2-4cf1-b95a-636979351e5b | Not supported |
| Block abuse of exploited vulnerable signed drivers | 56a863a9-875e-4185-98a7-b882c64b5ce5 | Not supported |
| Block use of copied or impersonated system tools | c0033c00-d16d-4114-a5a0-dc9b3a7d2ceb | Supported |
| Block rebooting machine in Safe Mode | 33ddedf1-c6e0-47cb-833e-de6133960387 | Supported |

# Configuration & Hunting

## Defender XDR - Attack Surface Reduction Detections

User Impact from Security Recommendations (per ASR-rule) - Security Recommendations

## Get started with Advanced Hunting

```kql
// Agregate Attack Surface Reduction rules events in M365 Defender Advanced Hunting, in 1h time chunks to display in time line chart.
DeviceEvents
| where ActionType startswith "Asr"
| summarize count() by ActionType, bin(Timestamp, 1h)
| render timechart

// Count Attack Surface Reduction rules events.
DeviceEvents
| where ActionType startswith "Asr"
| summarize count() by ActionType
| order by count_ desc

// Get latest events for a specific Attack Surface Reduction rule.
DeviceEvents
|where ActionType == "AsrOfficeCommAppChildProcessAudited"

// Get stats on ASR audit events - count events and machines per rule
DeviceEvents
| where ActionType startswith "Asr" and ActionType endswith "Audited"
| summarize EventCount=count(), MachinesCount=dcount(DeviceId) by ActionType

// Get stats on ASR blocks - count events and machines per rule
DeviceEvents
| where ActionType startswith "Asr" and ActionType endswith "Blocked"
| summarize EventCount=count(), MachinesCount=dcount(DeviceId) by ActionType

// View ASR audit events - but remove repeating events (e.g. multiple events with same machine, rule, file and process)
DeviceEvents
| where ActionType startswith "ASR" and ActionType endswith "Audited"
| summarize Timestamp =max(Timestamp) by DeviceName, ActionType,FileName, FolderPath, InitiatingProcessCommandLine, InitiatingProcessFileName, InitiatingProcessFolderPath, InitiatingProcessId, SHA1

// View executed ASR events, include folder path and initiating process path
DeviceEvents
| where (ActionType startswith "AsrOfficeMacro")
| extend RuleId=extractjson("$Ruleid", AdditionalFields, typeof(string))
| project DeviceName, FileName, FolderPath, ProcessCommandLine, InitiatingProcessFileName, InitiatingProcessCommandLine
```

## KQL Queries for ASR Rules

| Attack Surface Reduction Rule | KQL Audit | KQL Block |
|-------------------------------|-----------|-----------|
| Block executable content from email client and webmail | AsrExecutableEmailContentAudited | AsrExecutableEmailContentBlocked |
| Block all Office applications from creating child processes | AsrOfficeChildProcessAudited | AsrOfficeChildProcessBlocked |
| Block Office applications from creating executable content | AsrExecutableOfficeContentAudited | AsrExecutableOfficeContentBlocked |
| Block Office applications from injecting code into other processes | AsrOfficeProcessInjectionAudited | AsrOfficeProcessInjectionBlocked |
| Block JavaScript or VBScript from launching downloaded executable content | AsrScriptExecutableDownloadAudited | AsrScriptExecutableDownloadBlocked |
| Block execution of potentially obfuscated scripts | AsrObfuscatedScriptAudited | AsrObfuscatedScriptBlocked |
| Block Win32 API calls from Office macros | AsrOfficeMacroWin32ApiCallsAudited | AsrOfficeMacroWin32ApiCallsBlocked |
| Block executable files from running unless they meet a prevalence, age, or trusted list criterion | AsrUntrustedExecutableAudited | AsrUntrustedExecutableBlocked |
| Use advanced protection against ransomware | AsrRansomwareAudited | AsrRansomwareBlocked |
| Block credential stealing from the Windows local security authority subsystem (lsass.exe) | AsrLsassCredentialTheftAudited | AsrLsassCredentialTheftBlocked |
| Block process creations originating from PSExec and WMI commands | AsrPsexecWmiChildProcessAudited | AsrPsexecWmiChildProcessBlocked |
| Block untrusted and unsigned processes that run from USB | AsrUntrustedUsbProcessAudited | AsrUntrustedUsbProcessBlocked |
| Block Office communication application from creating child processes | AsrOfficeCommAppChildProcessAudited | AsrOfficeCommAppChildProcessBlocked |
| Block Adobe Reader from creating child processes | AsrAdobeReaderChildProcessAudited | AsrAdobeReaderChildProcessBlocked |
| Block persistence through WMI event subscription | AsrPersistenceThroughWmiAudited | AsrPersistenceThroughWmiBlocked |
| Block abuse of exploited vulnerable signed drivers | AsrVulnerableSignedDriverAudited | AsrVulnerableSignedDriverBlocked |
| Block use of copied or impersonated system tools | AsrAbusedSystemToolAudited | AsrAbusedSystemToolBlocked |
| Block rebooting machine in Safe Mode | AsrSafeModeRebootedAudited | AsrSafeModeRebootBlocked |

## Event Logs (Local)

### Security Logs

| ID | Description |
|----|-------------|
| 5007 | Event when settings are changed |

### Microsoft/Windows/Windows Defender/Operational
| ID | Description |
|----|-------------|
| 1122 | Event when rule fires in Audit-mode |
| 1121 | Event when rule fires in Block-mode |

# Links

## Detections (E5)
https://security.microsoft.com/asr?viewid=detections

## Configurations (E5)
https://security.microsoft.com/asr?viewid=configuration

## ASR Licensing Requirements
[Enable attack surface reduction rules | Microsoft Docs](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/enable-attack-surface-reduction)

## Human Operated Ransomware
[Human-operated ransomware attacks: A preventable disaster - Microsoft Security](https://www.microsoft.com/security/blog/2020/03/05/human-operated-ransomware-attacks-a-preventable-disaster/)

## PPTX Human Operated Ransomware
[Human Operated Ransomware | Microsoft Docs](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/human-operated-ransomware)

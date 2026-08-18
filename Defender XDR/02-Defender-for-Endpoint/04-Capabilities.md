# Microsoft Defender for Endpoint - Capabilities

## Document Information

| Item | Details |
|------|---------|
| **Product** | Microsoft Defender for Endpoint |
| **Document Type** | Capabilities |
| **Last Updated** | YYYY-MM-DD |
| **Author** | [Author Name] |
| **Version** | 1.0 |

---

## Purpose

This document provides a comprehensive list of Microsoft Defender for Endpoint capabilities, features, and links to related operational processes.

## Capabilities Matrix

### Next-Generation Protection

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Real-time Protection | Continuous monitoring and blocking of threats | [Malware Response](../Processes/Malware-Response.md) |
| Cloud-Delivered Protection | Cloud-based threat analysis and blocking | [Malware Response](../Processes/Malware-Response.md) |
| Behavior Monitoring | Detection of suspicious behaviors | [Alert Triage](../Processes/Alert-Triage.md) |
| Heuristic Analysis | Detection of unknown threats | [Alert Triage](../Processes/Alert-Triage.md) |
| Machine Learning | AI-based threat detection | [Alert Triage](../Processes/Alert-Triage.md) |
| Potentially Unwanted App (PUA) Protection | Block unwanted applications | [Application Control](../Processes/Application-Control.md) |
| Tamper Protection | Prevent disabling of security features | [Security Baseline](../Processes/Security-Baseline.md) |

### Attack Surface Reduction

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| ASR Rules | Block common attack techniques | [Attack Surface Reduction](../Processes/Attack-Surface-Reduction.md) |
| Controlled Folder Access | Ransomware protection | [Ransomware Protection](../Processes/Ransomware-Protection.md) |
| Exploit Protection | Mitigate exploitation techniques | [Vulnerability Management](../Processes/Vulnerability-Management.md) |
| Network Protection | Block malicious network connections | [Network Protection](../Processes/Network-Protection.md) |
| Web Protection | Block malicious websites | [Web Filtering](../Processes/Web-Filtering.md) |
| Application Control | Control allowed applications | [Application Control](../Processes/Application-Control.md) |
| Device Control | Control USB and removable media | [Device Control](../Processes/Device-Control.md) |
| Firewall Management | Manage Windows Firewall | [Firewall Management](../Processes/Firewall-Management.md) |

### Endpoint Detection and Response (EDR)

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Alert Detection | Behavioral and signature-based detection | [Alert Triage](../Processes/Alert-Triage.md) |
| Alert Investigation | Detailed alert investigation tools | [Incident Response](../Processes/Incident-Response.md) |
| Timeline View | Chronological view of device activity | [Digital Forensics](../Processes/Digital-Forensics.md) |
| Process Tree | Visualize process relationships | [Incident Response](../Processes/Incident-Response.md) |
| Live Response | Remote shell for investigation | [Live Response](../Processes/Live-Response.md) |
| File Analysis | Deep analysis of suspicious files | [Malware Analysis](../Processes/Malware-Analysis.md) |
| Network Connections | View network activity | [Incident Response](../Processes/Incident-Response.md) |

### Automated Investigation and Response

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Automated Investigation | AI-driven alert investigation | [Incident Response](../Processes/Incident-Response.md) |
| Auto-Remediation | Automatic threat remediation | [Incident Response](../Processes/Incident-Response.md) |
| Pending Actions | Review pending remediation | [Incident Response](../Processes/Incident-Response.md) |
| Investigation Package | Collect forensic data | [Digital Forensics](../Processes/Digital-Forensics.md) |

### Response Actions

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Isolate Device | Network isolation of device | [Incident Response](../Processes/Incident-Response.md) |
| Restrict App Execution | Block non-Microsoft apps | [Incident Response](../Processes/Incident-Response.md) |
| Run Antivirus Scan | Trigger full/quick scan | [Malware Response](../Processes/Malware-Response.md) |
| Collect Investigation Package | Gather forensic artifacts | [Digital Forensics](../Processes/Digital-Forensics.md) |
| Stop and Quarantine File | Block and quarantine malware | [Malware Response](../Processes/Malware-Response.md) |
| Block File | Block file organization-wide | [Indicator Management](../Processes/Indicator-Management.md) |

### Threat & Vulnerability Management

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Vulnerability Discovery | Continuous vulnerability scanning | [Vulnerability Management](../Processes/Vulnerability-Management.md) |
| Security Recommendations | Prioritized remediation guidance | [Vulnerability Management](../Processes/Vulnerability-Management.md) |
| Exposure Score | Organization-wide risk score | [Risk Management](../Processes/Risk-Management.md) |
| Secure Score for Devices | Device security posture | [Security Posture Management](../Processes/Security-Posture-Management.md) |
| Software Inventory | Installed software tracking | [Asset Management](../Processes/Asset-Management.md) |
| Security Baselines | Configuration compliance | [Security Baseline](../Processes/Security-Baseline.md) |
| Browser Extensions | Monitor browser extensions | [Application Control](../Processes/Application-Control.md) |
| Certificate Inventory | Track installed certificates | [Certificate Management](../Processes/Certificate-Management.md) |

### Advanced Hunting

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| KQL Queries | Query endpoint telemetry | [Threat Hunting](../Processes/Threat-Hunting.md) |
| Custom Detections | Create custom detection rules | [Detection Engineering](../Processes/Detection-Engineering.md) |
| Shared Queries | Use community queries | [Threat Hunting](../Processes/Threat-Hunting.md) |
| Query Scheduling | Schedule automated queries | [Detection Engineering](../Processes/Detection-Engineering.md) |

### Device Management

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Device Inventory | View all onboarded devices | [Asset Management](../Processes/Asset-Management.md) |
| Device Groups | Organize devices for management | [Asset Management](../Processes/Asset-Management.md) |
| Device Tags | Tag devices for organization | [Asset Management](../Processes/Asset-Management.md) |
| Device Health | Monitor device health status | [Device Health Monitoring](../Processes/Device-Health-Monitoring.md) |
| Onboarding Status | Track device onboarding | [Device Onboarding](../Processes/Device-Onboarding.md) |

### Indicators of Compromise

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| File Indicators | Block/allow by file hash | [Indicator Management](../Processes/Indicator-Management.md) |
| IP Indicators | Block/allow IP addresses | [Indicator Management](../Processes/Indicator-Management.md) |
| URL/Domain Indicators | Block/allow URLs/domains | [Indicator Management](../Processes/Indicator-Management.md) |
| Certificate Indicators | Block/allow certificates | [Indicator Management](../Processes/Indicator-Management.md) |

### Reporting and Analytics

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Threat Protection Report | Overview of threats blocked | [Security Reporting](../Processes/Security-Reporting.md) |
| Device Health Report | Device compliance status | [Security Reporting](../Processes/Security-Reporting.md) |
| Vulnerable Devices Report | Devices with vulnerabilities | [Vulnerability Management](../Processes/Vulnerability-Management.md) |
| Web Protection Report | Blocked web threats | [Security Reporting](../Processes/Security-Reporting.md) |
| Firewall Report | Firewall activity | [Security Reporting](../Processes/Security-Reporting.md) |

### Integration Capabilities

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Microsoft Intune | Policy deployment | [Policy Management](../Processes/Policy-Management.md) |
| Microsoft Sentinel | SIEM integration | [SIEM Integration](../Processes/SIEM-Integration.md) |
| Defender XDR | Cross-product correlation | [Incident Response](../Processes/Incident-Response.md) |
| Entra ID | Identity integration | [Identity Integration](../Processes/Identity-Integration.md) |
| Power Automate | Workflow automation | [Security Automation](../Processes/Security-Automation.md) |
| APIs | Programmatic access | [Security Automation](../Processes/Security-Automation.md) |

## Feature Availability by Plan

| Capability | Plan 1 | Plan 2 |
|------------|:------:|:------:|
| Next-Generation Protection | ✅ | ✅ |
| Attack Surface Reduction | ✅ | ✅ |
| Device Control | ✅ | ✅ |
| Web Protection | ✅ | ✅ |
| Firewall Management | ✅ | ✅ |
| Endpoint Detection & Response | ❌ | ✅ |
| Live Response | ❌ | ✅ |
| Automated Investigation | ❌ | ✅ |
| Threat & Vulnerability Management | ❌ | ✅ |
| Advanced Hunting | ❌ | ✅ |
| Custom Detections | ❌ | ✅ |
| Microsoft Threat Experts | ❌ | ✅ (add-on) |

## Platform Support Matrix

| Capability | Windows | macOS | Linux | iOS | Android |
|------------|:-------:|:-----:|:-----:|:---:|:-------:|
| Real-time Protection | ✅ | ✅ | ✅ | ✅ | ✅ |
| EDR | ✅ | ✅ | ✅ | ✅ | ✅ |
| ASR Rules | ✅ | ❌ | ❌ | ❌ | ❌ |
| Controlled Folder Access | ✅ | ❌ | ❌ | ❌ | ❌ |
| Web Protection | ✅ | ✅ | ❌ | ✅ | ✅ |
| Network Protection | ✅ | ✅ | ❌ | ❌ | ❌ |
| Device Control | ✅ | ✅ | ❌ | ❌ | ❌ |
| Live Response | ✅ | ✅ | ✅ | ❌ | ❌ |
| TVM | ✅ | ✅ | ✅ | ❌ | ❌ |

## Related Documentation

- [Overview](01-Overview.md)
- [High-Level Design](02-High-Level-Design.md)
- [Low-Level Design](03-Low-Level-Design.md)

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | YYYY-MM-DD | [Author] | Initial creation |

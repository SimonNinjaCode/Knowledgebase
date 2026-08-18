# Microsoft Defender XDR - Capabilities

## Document Information

| Item | Details |
|------|---------|
| **Product** | Microsoft Defender XDR |
| **Document Type** | Capabilities |
| **Last Updated** | YYYY-MM-DD |
| **Author** | [Author Name] |
| **Version** | 1.0 |

---

## Purpose

This document provides a comprehensive list of Microsoft Defender XDR capabilities, features, and links to related operational processes.

## Capabilities Matrix

### Incident Management

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Unified Incident Queue | Consolidated view of all security incidents across products | [Incident Response](../Processes/Incident-Response.md) |
| Incident Correlation | Automatic grouping of related alerts into single incidents | [Alert Triage](../Processes/Alert-Triage.md) |
| Incident Assignment | Manual and automatic assignment of incidents to analysts | [Incident Response](../Processes/Incident-Response.md) |
| Incident Classification | Categorize incidents as True Positive, False Positive, etc. | [Alert Triage](../Processes/Alert-Triage.md) |
| Incident Comments | Add investigation notes and collaboration comments | [Incident Response](../Processes/Incident-Response.md) |
| Incident Linking | Link related incidents together | [Incident Response](../Processes/Incident-Response.md) |

### Alert Management

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Unified Alert Queue | View alerts from all Defender products | [Alert Triage](../Processes/Alert-Triage.md) |
| Alert Suppression | Suppress known false positives | [Alert Tuning](../Processes/Alert-Tuning.md) |
| Alert Classification | Classify alerts with determination | [Alert Triage](../Processes/Alert-Triage.md) |
| Custom Alerts | Create custom alerts from hunting queries | [Threat Hunting](../Processes/Threat-Hunting.md) |

### Automated Investigation and Response

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Automated Investigation | AI-powered investigation of alerts | [Incident Response](../Processes/Incident-Response.md) |
| Auto-remediation | Automatic remediation of confirmed threats | [Incident Response](../Processes/Incident-Response.md) |
| Pending Actions | Review and approve pending remediation actions | [Incident Response](../Processes/Incident-Response.md) |
| Investigation Graph | Visual representation of attack chain | [Incident Response](../Processes/Incident-Response.md) |
| Evidence Collection | Automatic collection of forensic evidence | [Digital Forensics](../Processes/Digital-Forensics.md) |
| Automatic Attack Disruption | Real-time attack containment via signal correlation | [Incident Response](../Processes/Incident-Response.md) |
| Device Containment | Automatic network isolation of compromised devices | [Incident Response](../Processes/Incident-Response.md) |
| Account Disabling | Automatic compromise remediation for identities | [Incident Response](../Processes/Incident-Response.md) |

### Advanced Hunting

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Cross-product Hunting | Query across all Defender data sources | [Threat Hunting](../Processes/Threat-Hunting.md) |
| KQL Query Editor | Write and execute Kusto queries | [Threat Hunting](../Processes/Threat-Hunting.md) |
| Query Scheduling | Schedule queries to run automatically | [Threat Hunting](../Processes/Threat-Hunting.md) |
| Custom Detection Rules | Create detection rules from hunting queries | [Detection Engineering](../Processes/Detection-Engineering.md) |
| Shared Queries | Share and use community queries | [Threat Hunting](../Processes/Threat-Hunting.md) |
| Query Results Export | Export query results for analysis | [Threat Hunting](../Processes/Threat-Hunting.md) |

### Threat Intelligence & Analysis

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Threat Analytics | Curated threat intelligence reports | [Threat Intelligence](../Processes/Threat-Intelligence.md) |
| Exposure Tracking | Track organizational exposure to threats | [Vulnerability Management](../Processes/Vulnerability-Management.md) |
| Mitigation Guidance | Get remediation recommendations | [Vulnerability Management](../Processes/Vulnerability-Management.md) |
| Campaign Tracking | Track active threat campaigns | [Threat Intelligence](../Processes/Threat-Intelligence.md) |
| Vulnerability Management | Asset discovery, vulnerability assessment, risk prioritization | [Vulnerability Management](../Processes/Vulnerability-Management.md) |
| Insider Risk Detection | User-centric threat detection and investigation | [Incident Response](../Processes/Incident-Response.md) |
| DLP Integration | Data exfiltration incident correlation | [Incident Response](../Processes/Incident-Response.md) |

### Response Actions

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Device Isolation | Isolate compromised devices | [Incident Response](../Processes/Incident-Response.md) |
| Account Disable | Disable compromised user accounts | [Incident Response](../Processes/Incident-Response.md) |
| Email Purge | Remove malicious emails from mailboxes | [Incident Response](../Processes/Incident-Response.md) |
| App Suspension | Suspend user access to cloud apps | [Incident Response](../Processes/Incident-Response.md) |
| Block Indicators | Block malicious IPs, URLs, files | [Indicator Management](../Processes/Indicator-Management.md) |

### Secure Score

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Security Posture Score | Measure overall security configuration | [Security Posture Management](../Processes/Security-Posture-Management.md) |
| Improvement Actions | Get actionable recommendations | [Security Posture Management](../Processes/Security-Posture-Management.md) |
| Score History | Track score changes over time | [Security Posture Management](../Processes/Security-Posture-Management.md) |
| Comparison | Compare score against similar organizations | [Security Posture Management](../Processes/Security-Posture-Management.md) |

### Reporting and Dashboards

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Security Dashboard | Overview of security status | [Security Reporting](../Processes/Security-Reporting.md) |
| Incident Reports | Generate incident reports | [Incident Response](../Processes/Incident-Response.md) |
| Threat Reports | Export threat analytics reports | [Threat Intelligence](../Processes/Threat-Intelligence.md) |
| Custom Reports | Create custom reports | [Security Reporting](../Processes/Security-Reporting.md) |

### Integration Capabilities

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| API Access | REST API for automation | [Security Automation](../Processes/Security-Automation.md) |
| Microsoft Sentinel | SIEM integration | [SIEM Integration](../Processes/SIEM-Integration.md) |
| Power Automate | Workflow automation | [Security Automation](../Processes/Security-Automation.md) |
| Event Hub Streaming | Stream events to external systems | [SIEM Integration](../Processes/SIEM-Integration.md) |
| SIEM Connectors | Third-party SIEM integration | [SIEM Integration](../Processes/SIEM-Integration.md) |

### AI-Powered Response & Guidance

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Copilot Guided Response | AI-powered incident response recommendations | [Incident Response](../Processes/Incident-Response.md) |
| Ask Defender Experts | On-demand expert threat analysis (w/ credits) | [Incident Response](../Processes/Incident-Response.md) |
| Action Rationale | AI explanation for recommended remediation | [Incident Response](../Processes/Incident-Response.md) |
| Risk Scoring | AI assessment of action impact and risk | [Incident Response](../Processes/Incident-Response.md) |
| Entity Targeting | Intelligent identification of affected users/devices | [Incident Response](../Processes/Incident-Response.md) |
| Batch Operations | Group related actions for mass remediation | [Incident Response](../Processes/Incident-Response.md) |

### Administration

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| RBAC | Role-based access control | [Access Management](../Processes/Access-Management.md) |
| Audit Logs | Track administrative actions | [Audit and Compliance](../Processes/Audit-Compliance.md) |
| Settings Management | Configure product settings | [Change Management](../Processes/Change-Management.md) |
| Device Groups | Organize devices for management | [Asset Management](../Processes/Asset-Management.md) |
| Automation Tuning | Configure AAD automation levels per device group | [Change Management](../Processes/Change-Management.md) |

## Feature Availability by License

### Defender for Endpoint (MDE) - P1 vs P2 Comparison

| Feature Category | MDE P1 | MDE P2 |
|------------------|:------:|:------:|
| **Prevention & Protection** | | |
| Unified Security tools and centralized management | ✅ | ✅ |
| Next-Generation Antimalware | ✅ | ✅ |
| Attack Surface Reduction (ASR) Rules | ✅ | ✅ |
| Device Control (USB, Storage) | ✅ | ✅ |
| Endpoint Firewall | ✅ | ✅ |
| Network Protection | ✅ | ✅ |
| Web Content Filtering | ✅ | ✅ |
| Application Control | ✅ | ✅ |
| Controlled Folder Access | ✅ | ✅ |
| Tamper Protection | ✅ | ✅ |
| Block at First Sight | ✅ | ✅ |
| **Detection & Response** | | |
| Endpoint Detection & Response (EDR) | ❌ | ✅ |
| EDR in Block Mode | ❌ | ✅ |
| Live Response | ❌ | ✅ |
| Automated Investigation & Response (AIR) | ❌ | ✅ |
| **Threat & Vulnerability Management** | | |
| Threat & Vulnerability Management (TVM) | ❌ | ✅ |
| Threat & Vulnerability Management Dashboard | ❌ | ✅ |
| **Hunting & Intelligence** | | |
| Advanced Hunting | ❌ | ✅ |
| Threat Intelligence (Threat Analytics) | ❌ | ✅ |
| Sandbox (Deep Analysis) | ❌ | ✅ |
| **Integration & Management** | | |
| Defender for Cloud Apps Integration | ❌ | ✅ |
| Defender for Identity Integration | ❌ | ✅ |
| Device Discovery | ❌ | ✅ |
| Microsoft Secure Score for Devices | ❌ | ✅ |
| API Access, SIEM Connector, Custom TI | ✅ | ✅ |
| **Expert Services** | | |
| Microsoft Threat Experts | ❌ | ✅ |
| Device-based Conditional Access | ✅ | ✅ |
| Scoped Device Groups | ✅ | ✅ |
| Custom Network Indicators | ✅ | ✅ |

### Defender Vulnerability Management (DVM) - Licensing Tiers

| Capability | Core | Premium | Standalone |
|------------|:----:|:--------:|:----------:|
| **Core Features** | | | |
| Device discovery | ✅ | ✅ | ✅ |
| Device inventory | ✅ | ✅ | ✅ |
| Vulnerability assessment | ✅ | ✅ | ✅ |
| Configuration assessment | ✅ | ✅ | ✅ |
| Risk-based prioritization | ✅ | ✅ | ✅ |
| Remediation tracking | ✅ | ✅ | ✅ |
| Continuous monitoring | ✅ | ✅ | ✅ |
| Software inventory | ✅ | ✅ | ✅ |
| Software usage insights | ✅ | ✅ | ✅ |
| **Premium Features** | | | |
| Security baselines assessment | ❌ | ✅ | ✅ |
| Block vulnerable applications | ❌ | ✅ | ✅ |
| Browser extensions assessment | ❌ | ✅ | ✅ |
| Digital certificate assessment | ❌ | ✅ | ✅ |
| Network share analysis | ❌ | ✅ | ✅ |
| Hardware and firmware assessment | ❌ | ✅ | ✅ |
| Authenticated scan for Windows (via gMSA/WMI/DCOM) | ❌ | ✅ | ✅ |

**Note:** Core DVM is included with MDE P2; Premium add-on available; Standalone available for organizations using non-Microsoft EDR solutions.

### Core Defender XDR Features

| Capability | E3 | E5 | E5 Security | Business Premium | Defender for Business |
|------------|:---:|:---:|:-----------:|:---:|:---:|
| Unified Incidents | ❌ | ✅ | ✅ | ✅ | ✅ |
| Automated Investigation | ❌ | ✅ | ✅ | ✅ | ✅ |
| Advanced Hunting | ❌ | ✅ | ✅ | ❌ | ❌ |
| Threat Analytics | ❌ | ✅ | ✅ | ❌ | ❌ |
| Custom Detection Rules | ❌ | ✅ | ✅ | ❌ | ❌ |
| Cross-product Response | ❌ | ✅ | ✅ | ✅ | ✅ |

### Extended Component Availability

| Component | E3 | E5 | E5 Security | Standalone |
|-----------|:---:|:---:|:-----------:|:---:|
| **Defender Vulnerability Management** | Core in MDE P2 | ✅ | ✅ | ✅ (Add-on) |
| **Automatic Attack Disruption** | Requires MDE P2 | Requires MDE P2 | Requires MDE P2 | ✅ (MDE P2 req'd) |
| **Defender for Cloud** | Via add-on | ✅ | ✅ | ✅ |
| **Defender for IoT (Enterprise)** | ❌ | ✅ | ✅ | ✅ |
| **Entra ID Protection** | Separate (Entra P2) | Included | ✅ | Separate (Entra P2) |
| **DLP Integration** | Via add-on | ✅ | ✅ | Via add-on |
| **Insider Risk Management** | Via add-on | ✅ | ✅ | Via add-on |
| **App Governance** | Via Cloud Apps add-on | ✅ | ✅ | Via add-on |
| **Copilot Guided Response** | ✅ | ✅ | ✅ | ✅ |
| **Ask Defender Experts** | With DEx service | With DEx service | With DEx service | With DEx service |

## MITRE ATT&CK Coverage

Microsoft Defender XDR achieved nearly **100% coverage across attack chain stages** in the 2022 MITRE Engenuity ATT&CK Evaluations:

### Coverage by Tactic

| Tactic | Coverage | Key Capabilities | MITRE Score |
|--------|----------|------------------|-------------|
| Initial Access | Very High | Email protection, endpoint detection | 99% |
| Execution | Very High | Behavioral detection, script monitoring | 98% |
| Persistence | High | Registry monitoring, scheduled task detection | 95% |
| Privilege Escalation | Very High | Identity protection, credential theft detection | 99% |
| Defense Evasion | High | Behavioral analysis, ML detection | 94% |
| Credential Access | Very High | Identity threat detection, phishing detection | 99% |
| Discovery | High | Endpoint telemetry, host discovery | 96% |
| Lateral Movement | Very High | Cross-domain correlation, network analysis | 99% |
| Collection | High | DLP integration, endpoint monitoring | 93% |
| Exfiltration | High | Cloud app monitoring, network detection | 92% |
| Impact | High | Ransomware protection, file blocking | 91% |

## Related Documentation

- [Overview](01-Overview.md)
- [High-Level Design](02-High-Level-Design.md)
- [Low-Level Design](03-Low-Level-Design.md)

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | YYYY-MM-DD | [Author] | Initial creation |

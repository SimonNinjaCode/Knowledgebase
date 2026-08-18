# Microsoft Defender for Office 365 - Capabilities

## Document Information

| Item | Details |
|------|---------|
| **Product** | Microsoft Defender for Office 365 |
| **Document Type** | Capabilities |
| **Last Updated** | YYYY-MM-DD |
| **Author** | [Author Name] |
| **Version** | 1.0 |

---

## Purpose

This document provides a comprehensive list of Microsoft Defender for Office 365 capabilities, features, and links to related operational processes.

## Capabilities Matrix

### Email Protection

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Anti-malware Scanning | Detect known malware in attachments | [Malware Response](../Processes/Malware-Response.md) |
| Anti-spam Filtering | Filter spam and bulk email | [Spam Management](../Processes/Spam-Management.md) |
| Connection Filtering | Block known malicious IPs | [Email Security](../Processes/Email-Security.md) |
| Outbound Spam Filtering | Prevent compromised account spam | [Account Compromise](../Processes/Account-Compromise.md) |
| Quarantine Management | Manage quarantined messages | [Quarantine Management](../Processes/Quarantine-Management.md) |

### Safe Attachments

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Attachment Detonation | Sandbox analysis of attachments | [Malware Analysis](../Processes/Malware-Analysis.md) |
| Dynamic Delivery | Deliver email while scanning | [Email Security](../Processes/Email-Security.md) |
| Block Mode | Block malicious attachments | [Malware Response](../Processes/Malware-Response.md) |
| Replace Mode | Replace with warning notification | [Malware Response](../Processes/Malware-Response.md) |
| Monitor Mode | Log only, no blocking | [Security Monitoring](../Processes/Security-Monitoring.md) |
| SharePoint/OneDrive Protection | Protect uploaded files | [File Security](../Processes/File-Security.md) |
| Teams Protection | Protect files shared in Teams | [Collaboration Security](../Processes/Collaboration-Security.md) |

### Safe Links

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| URL Rewriting | Rewrite URLs for protection | [Email Security](../Processes/Email-Security.md) |
| Time-of-Click Verification | Check URLs when clicked | [Phishing Response](../Processes/Phishing-Response.md) |
| URL Detonation | Sandbox analysis of URLs | [Malware Analysis](../Processes/Malware-Analysis.md) |
| Warning Pages | Block pages for malicious URLs | [Phishing Response](../Processes/Phishing-Response.md) |
| Click Tracking | Track URL clicks for analysis | [Threat Hunting](../Processes/Threat-Hunting.md) |
| Teams Link Protection | Protect links in Teams | [Collaboration Security](../Processes/Collaboration-Security.md) |
| Office Document Links | Protect links in Office docs | [Document Security](../Processes/Document-Security.md) |

### Anti-Phishing

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| User Impersonation Protection | Detect spoofed internal users | [Phishing Response](../Processes/Phishing-Response.md) |
| Domain Impersonation Protection | Detect spoofed domains | [Phishing Response](../Processes/Phishing-Response.md) |
| Mailbox Intelligence | Learn communication patterns | [User Behavior Analytics](../Processes/User-Behavior-Analytics.md) |
| Spoof Intelligence | Detect spoofed senders | [Phishing Response](../Processes/Phishing-Response.md) |
| First Contact Safety Tips | Warn on new senders | [User Awareness](../Processes/User-Awareness.md) |
| Unauthenticated Sender Indicators | Show sender verification status | [Email Security](../Processes/Email-Security.md) |
| Phishing Threshold | Adjust detection sensitivity | [Alert Tuning](../Processes/Alert-Tuning.md) |

### Threat Investigation (Plan 2)

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Threat Explorer | Real-time threat investigation | [Threat Hunting](../Processes/Threat-Hunting.md) |
| Real-time Detections | View real-time threat data | [Security Monitoring](../Processes/Security-Monitoring.md) |
| Campaign Views | Analyze attack campaigns | [Threat Intelligence](../Processes/Threat-Intelligence.md) |
| Threat Trackers | Track emerging threats | [Threat Intelligence](../Processes/Threat-Intelligence.md) |
| Email Entity Page | Detailed email analysis | [Incident Response](../Processes/Incident-Response.md) |
| URL Trace | Track URL reputation | [Threat Hunting](../Processes/Threat-Hunting.md) |

### Automated Investigation & Response (Plan 2)

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Automated Investigation | AI-driven threat investigation | [Incident Response](../Processes/Incident-Response.md) |
| Soft Delete Emails | Remove malicious emails | [Email Remediation](../Processes/Email-Remediation.md) |
| Hard Delete Emails | Permanently remove threats | [Email Remediation](../Processes/Email-Remediation.md) |
| Block Sender | Block malicious senders | [Indicator Management](../Processes/Indicator-Management.md) |
| URL Block | Block malicious URLs | [Indicator Management](../Processes/Indicator-Management.md) |
| Playbooks | Pre-built investigation logic | [Security Automation](../Processes/Security-Automation.md) |
| Pending Actions | Review pending remediations | [Incident Response](../Processes/Incident-Response.md) |

### Attack Simulation Training (Plan 2)

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Phishing Simulations | Simulate phishing attacks | [Security Awareness](../Processes/Security-Awareness.md) |
| Credential Harvest Simulations | Test credential theft awareness | [Security Awareness](../Processes/Security-Awareness.md) |
| Malware Attachment Simulations | Test malware awareness | [Security Awareness](../Processes/Security-Awareness.md) |
| Link in Attachment Simulations | Test embedded link awareness | [Security Awareness](../Processes/Security-Awareness.md) |
| Training Campaigns | Assign security training | [Security Training](../Processes/Security-Training.md) |
| Training Modules | Built-in training content | [Security Training](../Processes/Security-Training.md) |
| Reporting & Analytics | Measure training effectiveness | [Security Reporting](../Processes/Security-Reporting.md) |
| Repeat Offender Tracking | Track users who fail multiple times | [User Behavior Analytics](../Processes/User-Behavior-Analytics.md) |

### User Submissions

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Report Message Add-in | User phishing reporting | [Phishing Response](../Processes/Phishing-Response.md) |
| User Submissions Portal | Review user reports | [Alert Triage](../Processes/Alert-Triage.md) |
| Admin Submissions | Submit to Microsoft for analysis | [Threat Intelligence](../Processes/Threat-Intelligence.md) |
| Result Emails | Feedback to users | [User Communication](../Processes/User-Communication.md) |

### Tenant Allow/Block Lists

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| URL Allow/Block | Manage URL exceptions | [Indicator Management](../Processes/Indicator-Management.md) |
| File Allow/Block | Manage file hash exceptions | [Indicator Management](../Processes/Indicator-Management.md) |
| Sender Allow/Block | Manage sender exceptions | [Indicator Management](../Processes/Indicator-Management.md) |
| Spoof Allow/Block | Manage spoof exceptions | [Email Security](../Processes/Email-Security.md) |

### Reporting and Analytics

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Threat Protection Status | Overview of threats blocked | [Security Reporting](../Processes/Security-Reporting.md) |
| Mail Flow Report | Email volume and filtering stats | [Security Reporting](../Processes/Security-Reporting.md) |
| Top Malware Report | Most detected malware | [Threat Intelligence](../Processes/Threat-Intelligence.md) |
| Spoof Detections Report | Spoofing attempt statistics | [Security Reporting](../Processes/Security-Reporting.md) |
| URL Threat Report | Blocked URL statistics | [Security Reporting](../Processes/Security-Reporting.md) |
| Compromised User Report | Potentially compromised accounts | [Account Compromise](../Processes/Account-Compromise.md) |

### Integration Capabilities

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Microsoft Defender XDR | Unified incident management | [Incident Response](../Processes/Incident-Response.md) |
| Microsoft Sentinel | SIEM integration | [SIEM Integration](../Processes/SIEM-Integration.md) |
| Microsoft Graph API | Programmatic access | [Security Automation](../Processes/Security-Automation.md) |
| Power Automate | Workflow automation | [Security Automation](../Processes/Security-Automation.md) |
| Third-party SIEM | Log export | [SIEM Integration](../Processes/SIEM-Integration.md) |

### Administration

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Preset Security Policies | Standard/Strict templates | [Policy Management](../Processes/Policy-Management.md) |
| Custom Policies | Granular policy control | [Policy Management](../Processes/Policy-Management.md) |
| Configuration Analyzer | Policy recommendations | [Security Posture Management](../Processes/Security-Posture-Management.md) |
| RBAC | Role-based access control | [Access Management](../Processes/Access-Management.md) |
| Audit Logging | Admin action logging | [Audit and Compliance](../Processes/Audit-Compliance.md) |

## Feature Availability by Plan

| Capability | EOP | Plan 1 | Plan 2 |
|------------|:---:|:------:|:------:|
| Anti-malware | ✅ | ✅ | ✅ |
| Anti-spam | ✅ | ✅ | ✅ |
| Anti-phishing (basic) | ✅ | ✅ | ✅ |
| Safe Attachments | ❌ | ✅ | ✅ |
| Safe Links | ❌ | ✅ | ✅ |
| Anti-phishing (advanced) | ❌ | ✅ | ✅ |
| Real-time Detections | ❌ | ✅ | ✅ |
| Threat Explorer | ❌ | ❌ | ✅ |
| Automated Investigation | ❌ | ❌ | ✅ |
| Attack Simulation | ❌ | ❌ | ✅ |
| Campaign Views | ❌ | ❌ | ✅ |
| Threat Trackers | ❌ | ❌ | ✅ |

## MITRE ATT&CK Coverage

| Tactic | Coverage | Key Detections |
|--------|----------|----------------|
| Initial Access | High | Phishing, malicious attachments |
| Execution | Medium | Macro blocking, Safe Attachments |
| Persistence | Low | Email rule detection |
| Defense Evasion | Medium | URL detonation |
| Credential Access | High | Credential harvest detection |
| Discovery | Low | N/A |
| Lateral Movement | Low | N/A |
| Collection | Medium | Suspicious forwarding rules |
| Exfiltration | Low | N/A |

## Related Documentation

- [Overview](01-Overview.md)
- [High-Level Design](02-High-Level-Design.md)
- [Low-Level Design](03-Low-Level-Design.md)

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | YYYY-MM-DD | [Author] | Initial creation |

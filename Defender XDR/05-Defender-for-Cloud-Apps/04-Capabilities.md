# Microsoft Defender for Cloud Apps - Capabilities

## Document Information

| Item | Details |
|------|---------|
| **Product** | Microsoft Defender for Cloud Apps |
| **Document Type** | Capabilities |
| **Last Updated** | YYYY-MM-DD |
| **Author** | [Author Name] |
| **Version** | 1.0 |

---

## Purpose

This document provides a comprehensive list of Microsoft Defender for Cloud Apps capabilities, features, and links to related operational processes.

## Capabilities Matrix

### Cloud Discovery

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Shadow IT Discovery | Discover cloud apps in use | [Shadow IT Management](../Processes/Shadow-IT-Management.md) |
| Cloud App Catalog | Database of 31,000+ apps | [App Risk Assessment](../Processes/App-Risk-Assessment.md) |
| Risk Scoring | Score apps on 90+ risk factors | [App Risk Assessment](../Processes/App-Risk-Assessment.md) |
| App Tagging | Tag apps as sanctioned/unsanctioned | [App Governance](../Processes/App-Governance.md) |
| Discovery Reports | Usage and trend reports | [Security Reporting](../Processes/Security-Reporting.md) |
| Log Collection | Collect firewall/proxy logs | [Data Collection](../Processes/Data-Collection.md) |
| Endpoint Discovery | Discover via Defender for Endpoint | [Shadow IT Management](../Processes/Shadow-IT-Management.md) |
| Discovery Policies | Alert on new apps | [Alert Management](../Processes/Alert-Management.md) |

### App Connectors

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| API Integration | Deep app integration | [App Integration](../Processes/App-Integration.md) |
| Activity Monitoring | Track user activities | [Activity Monitoring](../Processes/Activity-Monitoring.md) |
| File Scanning | Inspect files in cloud apps | [Data Protection](../Processes/Data-Protection.md) |
| User Monitoring | Track user behavior | [User Behavior Analytics](../Processes/User-Behavior-Analytics.md) |
| Configuration Audit | Audit app configurations | [Configuration Management](../Processes/Configuration-Management.md) |
| Governance Actions | Apply remediation actions | [Governance Actions](../Processes/Governance-Actions.md) |

### Information Protection

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Content Inspection | Scan files for sensitive data | [Data Loss Prevention](../Processes/Data-Loss-Prevention.md) |
| Sensitivity Labels | Apply classification labels | [Data Classification](../Processes/Data-Classification.md) |
| File Policies | Protect files based on content | [Data Protection](../Processes/Data-Protection.md) |
| External Sharing Control | Control external access | [Sharing Management](../Processes/Sharing-Management.md) |
| File Quarantine | Quarantine sensitive files | [Data Protection](../Processes/Data-Protection.md) |
| Rights Management | Apply encryption | [Encryption Management](../Processes/Encryption-Management.md) |
| DLP Integration | Microsoft Purview DLP | [Data Loss Prevention](../Processes/Data-Loss-Prevention.md) |

### Threat Protection

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Anomaly Detection | Detect unusual behavior | [Threat Detection](../Processes/Threat-Detection.md) |
| Impossible Travel | Detect geographically impossible logins | [Account Compromise](../Processes/Account-Compromise.md) |
| Risky Sign-in Detection | Detect suspicious sign-ins | [Account Compromise](../Processes/Account-Compromise.md) |
| Mass Download Detection | Detect bulk downloads | [Data Exfiltration](../Processes/Data-Exfiltration.md) |
| Mass Delete Detection | Detect bulk deletions | [Incident Response](../Processes/Incident-Response.md) |
| Ransomware Detection | Detect ransomware activity | [Ransomware Protection](../Processes/Ransomware-Protection.md) |
| Malware Detection | Detect malicious files | [Malware Response](../Processes/Malware-Response.md) |
| Activity from Suspicious IPs | Detect risky IP access | [Threat Detection](../Processes/Threat-Detection.md) |

### Conditional Access App Control

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Session Monitoring | Monitor user sessions | [Session Management](../Processes/Session-Management.md) |
| Download Control | Block/protect downloads | [Data Protection](../Processes/Data-Protection.md) |
| Upload Control | Block/monitor uploads | [Data Protection](../Processes/Data-Protection.md) |
| Copy/Paste Control | Prevent data copy | [Data Loss Prevention](../Processes/Data-Loss-Prevention.md) |
| Print Control | Control printing | [Data Loss Prevention](../Processes/Data-Loss-Prevention.md) |
| Access Policies | Block app access | [Access Management](../Processes/Access-Management.md) |
| Custom Apps | Onboard any SAML/OIDC app | [App Onboarding](../Processes/App-Onboarding.md) |

### App Governance

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| OAuth App Discovery | Discover OAuth apps | [OAuth Management](../Processes/OAuth-Management.md) |
| Permission Analysis | Analyze app permissions | [Permission Management](../Processes/Permission-Management.md) |
| App Certification | Track app certifications | [App Risk Assessment](../Processes/App-Risk-Assessment.md) |
| App Policies | Control OAuth apps | [App Governance](../Processes/App-Governance.md) |
| Ban Apps | Block risky apps | [App Governance](../Processes/App-Governance.md) |
| Revoke Permissions | Remove app access | [Permission Management](../Processes/Permission-Management.md) |
| Unused App Detection | Find stale apps | [App Lifecycle](../Processes/App-Lifecycle.md) |

### SaaS Security Posture Management (SSPM)

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Security Recommendations | App-specific recommendations | [Security Posture Management](../Processes/Security-Posture-Management.md) |
| Configuration Assessment | Assess app configurations | [Configuration Management](../Processes/Configuration-Management.md) |
| Benchmark Compliance | Compare to best practices | [Compliance Management](../Processes/Compliance-Management.md) |
| Remediation Guidance | Fix configuration issues | [Remediation](../Processes/Remediation.md) |

### Governance Actions

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Suspend User | Suspend cloud app access | [Account Management](../Processes/Account-Management.md) |
| Revoke Sessions | Force re-authentication | [Session Management](../Processes/Session-Management.md) |
| Remove Sharing | Remove external access | [Sharing Management](../Processes/Sharing-Management.md) |
| Apply Label | Classify files | [Data Classification](../Processes/Data-Classification.md) |
| Quarantine File | Move to quarantine | [Data Protection](../Processes/Data-Protection.md) |
| Notify User | Send user notification | [User Communication](../Processes/User-Communication.md) |
| Notify Admin | Alert administrator | [Alert Management](../Processes/Alert-Management.md) |

### Investigation and Hunting

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Activity Log | Search all activities | [Threat Hunting](../Processes/Threat-Hunting.md) |
| File Log | Search all files | [Data Investigation](../Processes/Data-Investigation.md) |
| User Investigation | Investigate user activities | [User Investigation](../Processes/User-Investigation.md) |
| App Investigation | Investigate app usage | [App Investigation](../Processes/App-Investigation.md) |
| Advanced Filters | Complex query filters | [Threat Hunting](../Processes/Threat-Hunting.md) |
| Export Data | Export investigation results | [Evidence Collection](../Processes/Evidence-Collection.md) |

### Reporting and Analytics

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Executive Reports | Summary dashboards | [Security Reporting](../Processes/Security-Reporting.md) |
| Discovery Dashboard | Shadow IT overview | [Shadow IT Management](../Processes/Shadow-IT-Management.md) |
| Alerts Dashboard | Alert trends | [Alert Management](../Processes/Alert-Management.md) |
| Governance Logs | Action audit trail | [Audit and Compliance](../Processes/Audit-Compliance.md) |
| Usage Reports | App usage analytics | [Usage Analytics](../Processes/Usage-Analytics.md) |

### Integration Capabilities

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Microsoft Defender XDR | Unified incidents | [Incident Response](../Processes/Incident-Response.md) |
| Defender for Endpoint | Endpoint discovery | [Endpoint Integration](../Processes/Endpoint-Integration.md) |
| Microsoft Sentinel | SIEM integration | [SIEM Integration](../Processes/SIEM-Integration.md) |
| Entra ID | Identity integration | [Identity Integration](../Processes/Identity-Integration.md) |
| Microsoft Purview | DLP and labels | [Data Protection](../Processes/Data-Protection.md) |
| Power Automate | Workflow automation | [Security Automation](../Processes/Security-Automation.md) |
| APIs | Programmatic access | [API Integration](../Processes/API-Integration.md) |

### Administration

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| RBAC | Role-based access | [Access Management](../Processes/Access-Management.md) |
| Scoped Deployment | Limit visibility to groups | [Scoped Deployment](../Processes/Scoped-Deployment.md) |
| Admin Audit Log | Track admin actions | [Audit and Compliance](../Processes/Audit-Compliance.md) |
| IP Ranges | Define corporate IPs | [Network Configuration](../Processes/Network-Configuration.md) |
| User Groups | Import Entra ID groups | [Group Management](../Processes/Group-Management.md) |

## Feature Availability by License

| Capability | Discovery Only | Full License | App Gov Add-on |
|------------|:--------------:|:------------:|:--------------:|
| Cloud Discovery | ✅ | ✅ | ✅ |
| App Connectors | ❌ | ✅ | ✅ |
| Conditional Access App Control | ❌ | ✅ | ✅ |
| Information Protection | ❌ | ✅ | ✅ |
| Threat Protection | ❌ | ✅ | ✅ |
| SSPM | ❌ | ✅ | ✅ |
| Advanced App Governance | ❌ | ❌ | ✅ |

## MITRE ATT&CK Coverage

| Tactic | Coverage | Key Detections |
|--------|----------|----------------|
| Initial Access | Medium | OAuth abuse, phishing |
| Execution | Low | N/A |
| Persistence | Medium | OAuth app installation |
| Privilege Escalation | Medium | Permission changes |
| Defense Evasion | Low | N/A |
| Credential Access | High | Token theft, session hijack |
| Discovery | Medium | Account enumeration |
| Lateral Movement | Low | N/A |
| Collection | High | Bulk download, data access |
| Exfiltration | High | External sharing, mass download |

## Related Documentation

- [Overview](01-Overview.md)
- [High-Level Design](02-High-Level-Design.md)
- [Low-Level Design](03-Low-Level-Design.md)

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | YYYY-MM-DD | [Author] | Initial creation |

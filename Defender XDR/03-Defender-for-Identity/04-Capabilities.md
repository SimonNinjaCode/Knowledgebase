# Microsoft Defender for Identity - Capabilities

## Document Information

| Item | Details |
|------|---------|
| **Product** | Microsoft Defender for Identity |
| **Document Type** | Capabilities |
| **Last Updated** | YYYY-MM-DD |
| **Author** | [Author Name] |
| **Version** | 1.0 |

---

## Purpose

This document provides a comprehensive list of Microsoft Defender for Identity capabilities, features, and links to related operational processes.

## Capabilities Matrix

### Reconnaissance Detection

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Account Enumeration Detection | Detect attackers enumerating domain accounts | [Alert Triage](../Processes/Alert-Triage.md) |
| Net Session Enumeration | Detect enumeration of active sessions | [Incident Response](../Processes/Incident-Response.md) |
| DNS Reconnaissance | Detect DNS zone transfer attempts | [Alert Triage](../Processes/Alert-Triage.md) |
| Security Principal Reconnaissance | Detect LDAP reconnaissance queries | [Threat Hunting](../Processes/Threat-Hunting.md) |
| User and Group Membership Reconnaissance | Detect queries for group memberships | [Alert Triage](../Processes/Alert-Triage.md) |
| Network Mapping Reconnaissance | Detect network discovery attempts | [Alert Triage](../Processes/Alert-Triage.md) |

### Credential Theft Detection

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Brute Force Attack Detection | Detect password guessing attempts | [Incident Response](../Processes/Incident-Response.md) |
| Password Spray Detection | Detect password spray attacks | [Incident Response](../Processes/Incident-Response.md) |
| Kerberoasting Detection | Detect Kerberos service ticket abuse | [Incident Response](../Processes/Incident-Response.md) |
| AS-REP Roasting Detection | Detect accounts without pre-auth | [Incident Response](../Processes/Incident-Response.md) |
| NTLM Relay Detection | Detect NTLM credential relay | [Incident Response](../Processes/Incident-Response.md) |
| Suspicious Service Creation | Detect malicious service installations | [Incident Response](../Processes/Incident-Response.md) |
| Honeytoken Activity | Alert on decoy account usage | [Incident Response](../Processes/Incident-Response.md) |

### Lateral Movement Detection

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Pass-the-Hash Detection | Detect hash-based authentication | [Incident Response](../Processes/Incident-Response.md) |
| Pass-the-Ticket Detection | Detect ticket reuse attacks | [Incident Response](../Processes/Incident-Response.md) |
| Overpass-the-Hash Detection | Detect NTLM to Kerberos attacks | [Incident Response](../Processes/Incident-Response.md) |
| Remote Code Execution | Detect remote execution attempts | [Incident Response](../Processes/Incident-Response.md) |
| Suspicious SMB Session | Detect unusual SMB activity | [Alert Triage](../Processes/Alert-Triage.md) |
| Lateral Movement Path Detection | Identify potential attack paths | [Threat Hunting](../Processes/Threat-Hunting.md) |
| Suspicious Certificate Usage | Detect certificate-based attacks | [Incident Response](../Processes/Incident-Response.md) |

### Domain Dominance Detection

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| DCSync Attack Detection | Detect replication-based attacks | [Incident Response](../Processes/Incident-Response.md) |
| DCShadow Attack Detection | Detect rogue DC registration | [Incident Response](../Processes/Incident-Response.md) |
| Golden Ticket Detection | Detect forged Kerberos tickets | [Incident Response](../Processes/Incident-Response.md) |
| Silver Ticket Detection | Detect forged service tickets | [Incident Response](../Processes/Incident-Response.md) |
| Skeleton Key Detection | Detect master password backdoors | [Incident Response](../Processes/Incident-Response.md) |
| Malicious Domain Controller Promotion | Detect rogue DC promotions | [Incident Response](../Processes/Incident-Response.md) |
| SID History Injection | Detect privilege escalation via SID | [Incident Response](../Processes/Incident-Response.md) |

### Exfiltration Detection

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Data Exfiltration over DNS | Detect DNS tunneling | [Incident Response](../Processes/Incident-Response.md) |
| Suspicious SMB Data Transfer | Detect unusual data movement | [Data Loss Prevention](../Processes/Data-Loss-Prevention.md) |
| Private Data Collection | Detect bulk data gathering | [Data Loss Prevention](../Processes/Data-Loss-Prevention.md) |

### User & Entity Behavior Analytics (UEBA)

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Anomalous Logon Detection | Detect unusual authentication | [Alert Triage](../Processes/Alert-Triage.md) |
| Abnormal Resource Access | Detect unusual resource access | [Threat Hunting](../Processes/Threat-Hunting.md) |
| Unusual Admin Activity | Detect anomalous admin behavior | [Alert Triage](../Processes/Alert-Triage.md) |
| Peer Group Analysis | Compare user to peer behavior | [User Behavior Analytics](../Processes/User-Behavior-Analytics.md) |
| Dormant Account Activity | Detect activity on inactive accounts | [Alert Triage](../Processes/Alert-Triage.md) |
| First Time User Activity | Detect new behavior patterns | [Alert Triage](../Processes/Alert-Triage.md) |

### Identity Security Posture

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Unsecure Account Attributes | Identify weak account settings | [Identity Hardening](../Processes/Identity-Hardening.md) |
| Unsecure Kerberos Delegation | Identify risky delegation | [Identity Hardening](../Processes/Identity-Hardening.md) |
| Weak Cipher Usage | Detect legacy encryption | [Identity Hardening](../Processes/Identity-Hardening.md) |
| Dormant Accounts | Identify inactive accounts | [Identity Lifecycle](../Processes/Identity-Lifecycle.md) |
| Clear Text Password Exposure | Detect reversible encryption | [Identity Hardening](../Processes/Identity-Hardening.md) |
| LDAP Authentication Weaknesses | Identify LDAP vulnerabilities | [Identity Hardening](../Processes/Identity-Hardening.md) |
| Print Spooler Service Risks | Identify PrintNightmare risks | [Vulnerability Management](../Processes/Vulnerability-Management.md) |

### Investigation Capabilities

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| User Timeline | Chronological user activity view | [Digital Forensics](../Processes/Digital-Forensics.md) |
| Entity Profiles | Detailed user/computer profiles | [Incident Response](../Processes/Incident-Response.md) |
| Alert Investigation | Detailed alert context | [Alert Triage](../Processes/Alert-Triage.md) |
| Lateral Movement Graph | Visual attack path display | [Incident Response](../Processes/Incident-Response.md) |
| Entity Tags | Custom entity classification | [Asset Management](../Processes/Asset-Management.md) |
| Evidence Collection | Automatic evidence gathering | [Digital Forensics](../Processes/Digital-Forensics.md) |

### Response Actions

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Disable User in AD | Immediate account disable | [Incident Response](../Processes/Incident-Response.md) |
| Force Password Reset | Require password change | [Incident Response](../Processes/Incident-Response.md) |
| Enable User in AD | Re-enable after investigation | [Incident Response](../Processes/Incident-Response.md) |
| Confirm User Compromised | Mark as confirmed threat | [Incident Response](../Processes/Incident-Response.md) |
| Dismiss as False Positive | Close benign alerts | [Alert Triage](../Processes/Alert-Triage.md) |

### Reporting and Analytics

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Security Assessment Report | Identity security posture | [Security Reporting](../Processes/Security-Reporting.md) |
| Sensitive Groups Report | Privileged account monitoring | [Privileged Access Management](../Processes/Privileged-Access-Management.md) |
| Lateral Movement Path Report | Attack path analysis | [Security Reporting](../Processes/Security-Reporting.md) |
| Passwords Exposed in Clear Text | Password security report | [Security Reporting](../Processes/Security-Reporting.md) |
| Health Monitoring Dashboard | Sensor and service health | [Operations Monitoring](../Processes/Operations-Monitoring.md) |

### Integration Capabilities

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Microsoft Defender XDR | Unified incident management | [Incident Response](../Processes/Incident-Response.md) |
| Microsoft Sentinel | SIEM integration | [SIEM Integration](../Processes/SIEM-Integration.md) |
| Syslog Export | Third-party SIEM integration | [SIEM Integration](../Processes/SIEM-Integration.md) |
| Microsoft Graph API | Programmatic access | [Security Automation](../Processes/Security-Automation.md) |
| VPN Integration | VPN authentication monitoring | [Network Security](../Processes/Network-Security.md) |

### Administration

| Capability | Description | Related Processes |
|------------|-------------|-------------------|
| Role-Based Access Control | Manage portal access | [Access Management](../Processes/Access-Management.md) |
| Sensor Management | Deploy and manage sensors | [Sensor Management](../Processes/Sensor-Management.md) |
| Entity Exclusions | Tune detection sensitivity | [Alert Tuning](../Processes/Alert-Tuning.md) |
| Notification Settings | Configure alerting | [Alert Management](../Processes/Alert-Management.md) |
| Data Retention | Configure retention periods | [Data Management](../Processes/Data-Management.md) |

## RBAC Permissions Matrix

| Access Level | M365 Unified RBAC Permissions |
|--------------|------------------------------|
| Administrators | Authorization and settings/Security settings/Read, Authorization and settings/Security settings/All permissions, Authorization and settings/System settings/Read, Authorization and settings/System settings/All permissions, Security operations/Security data/Alerts (manage), Security operations/Security data/Security data basics (Read), Authorization and settings/Authorization/All permissions, Authorization and settings/Authorization/Read |
| Users | Security operations/Security data/Security data basics (Read), Authorization and settings/System settings/Read, Authorization and settings/Security settings/Read, Security operations/Security data/Alerts (manage), microsoft.xdr/configuration/security/manage |
| Viewers | Security operations/Security data/Security data basics (Read), Authorization and settings/System settings (Read and manage), Authorization and settings/Security setting (All permissions) |

## Built-in Reports

| Report | Description |
|--------|-------------|
| Summary | A summary of alerts and health issues |
| Modifications to sensitive groups | Every modification to sensitive groups in Active Directory, including modifications with generated alerts |
| Password exposed in clear text | All LDAP authentications which exposed user password in clear text |
| Lateral movement paths to sensitive accounts | Sensitive accounts at risk of being compromised through lateral movement techniques |

## Security Posture Recommendations

The following security recommendations are built in and presented as actionable insights:

- Lateral movement paths to sensitive accounts
- Stale accounts with high privileges
- Modifications to sensitive groups
- Password exposed in clear text
- Accounts with non-expiring passwords
- Over-permissive certificate templates
- Trust relationships on ADFS
- Insecure Configuration in:
  - Local AD
  - Entra Connect
  - AD CA (PKI)
  - ADFS

## Remediation Actions

| Action | Method | Description |
|--------|--------|-------------|
| Enriches Alerts & Incidents | Automatic | Adds context to Defender XDR incidents |
| Disable user account | Automatic (gMSA) | If configured, automatically disables compromised user accounts |
| Reset password | Automatic (gMSA) | If configured, automatically resets password of compromised user |

## Detection Coverage by Attack Stage

| MITRE ATT&CK Tactic | Coverage | Key Detections |
|--------------------|----------|----------------|
| Reconnaissance | High | Account enumeration, DNS reconnaissance |
| Initial Access | Medium | Suspicious authentication patterns |
| Execution | Low | Remote code execution detection |
| Persistence | Medium | Malicious service creation |
| Privilege Escalation | High | DCSync, Golden Ticket |
| Defense Evasion | Medium | DCShadow, SID history injection |
| Credential Access | High | Kerberoasting, brute force |
| Discovery | High | LDAP reconnaissance |
| Lateral Movement | High | Pass-the-Hash, Pass-the-Ticket |
| Collection | Low | Bulk data queries |
| Exfiltration | Medium | DNS exfiltration |

## Related Documentation

- [Overview](01-Overview.md)
- [High-Level Design](02-High-Level-Design.md)
- [Low-Level Design](03-Low-Level-Design.md)

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | YYYY-MM-DD | [Author] | Initial creation |

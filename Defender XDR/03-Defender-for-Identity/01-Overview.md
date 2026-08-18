# Microsoft Defender for Identity - Overview

## Document Information

| Item | Details |
|------|---------|
| **Product** | Microsoft Defender for Identity |
| **Document Type** | Overview |
| **Last Updated** | YYYY-MM-DD |
| **Author** | [Author Name] |
| **Version** | 1.0 |

---

## Executive Summary

Microsoft Defender for Identity (MDI) is a cloud-based security solution that leverages your on-premises Active Directory signals to identify, detect, and investigate advanced threats, compromised identities, and malicious insider actions directed at your organization.

## Purpose

This document provides a high-level overview of Microsoft Defender for Identity, including:

- Product capabilities and value proposition
- Architecture requirements
- Licensing requirements
- Key use cases

## Scope

### In Scope

- Identity threat detection and investigation
- Active Directory monitoring
- Lateral movement detection
- Credential theft detection
- Integration with Microsoft security stack

### Out of Scope

- Detailed configuration procedures (see [Low-Level Design](03-Low-Level-Design.md))
- Entra ID Protection (separate product)
- Privileged Identity Management (PIM)

## Product Description

### What is Defender for Identity?

Microsoft Defender for Identity is designed to:

1. **Monitor Users and Activities** - Profile user behavior and activities
2. **Protect Identities** - Detect compromised identities and credentials
3. **Identify Suspicious Activities** - Detect advanced attacks in real-time
4. **Investigate Alerts** - Provide clear incident information and investigation tools

### Key Value Propositions

| Value | Description |
|-------|-------------|
| **On-Premises Visibility** | Deep insight into Active Directory activities |
| **Attack Detection** | Detect known and unknown identity-based attacks |
| **Behavioral Analytics** | ML-based user and entity behavior analytics |
| **Incident Timeline** | Clear attack timeline and investigation tools |

## Core Capabilities

```
┌─────────────────────────────────────────────────────────────────┐
│                Microsoft Defender for Identity                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐   │
│  │  Threat          │  │  User & Entity   │  │  Identity    │   │
│  │  Detection       │  │  Behavior        │  │  Security    │   │
│  │                  │  │  Analytics       │  │  Posture     │   │
│  └──────────────────┘  └──────────────────┘  └──────────────┘   │
│                                                                  │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐   │
│  │  Lateral         │  │  Compromised     │  │  Attack      │   │
│  │  Movement        │  │  Credential      │  │  Path        │   │
│  │  Detection       │  │  Detection       │  │  Analysis    │   │
│  └──────────────────┘  └──────────────────┘  └──────────────┘   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Capability Descriptions

| Capability | Description |
|------------|-------------|
| **Reconnaissance Detection** | Detect attackers gathering information about your environment |
| **Compromised Credential Detection** | Identify use of stolen or compromised credentials |
| **Lateral Movement Detection** | Detect attackers moving through your network |
| **Domain Dominance Detection** | Identify attempts to take control of the domain |
| **Exfiltration Detection** | Detect data exfiltration attempts |
| **Security Posture Assessment** | Identify security weaknesses in Active Directory |

## Attack Detection Types

### Reconnaissance

- Account enumeration
- Network mapping
- Security principal reconnaissance
- Active Directory attributes queries

### Credential Theft

- Brute force attacks
- Kerberoasting
- NTLM relay attacks
- Suspicious authentication patterns

### Lateral Movement

- Pass-the-Hash
- Pass-the-Ticket
- Overpass-the-Hash
- Remote code execution
- Suspicious service creation

### Domain Dominance

- DCSync attacks
- DCShadow attacks
- Golden Ticket
- Skeleton Key
- Malicious replication

## Architecture Requirements

### Sensor Deployment

```
┌─────────────────────────────────────────────────────────────────┐
│                    Microsoft Cloud                               │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              Defender for Identity Cloud Service           │  │
│  └───────────────────────────────────────────────────────────┘  │
└────────────────────────────────┬────────────────────────────────┘
                                 │ HTTPS (443)
                                 │
┌────────────────────────────────┼────────────────────────────────┐
│              Customer Network  │                                 │
│                                │                                 │
│  ┌─────────────────────────────┼─────────────────────────────┐  │
│  │                Domain Controllers                          │  │
│  │  ┌───────────┐  ┌───────────┐  ┌───────────┐              │  │
│  │  │    DC1    │  │    DC2    │  │    DC3    │              │  │
│  │  │  + MDI    │  │  + MDI    │  │  + MDI    │              │  │
│  │  │  Sensor   │  │  Sensor   │  │  Sensor   │              │  │
│  │  └───────────┘  └───────────┘  └───────────┘              │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                    AD FS Servers (Optional)                │  │
│  │  ┌───────────┐  ┌───────────┐                             │  │
│  │  │  ADFS1    │  │  ADFS2    │                             │  │
│  │  │  + MDI    │  │  + MDI    │                             │  │
│  │  │  Sensor   │  │  Sensor   │                             │  │
│  │  └───────────┘  └───────────┘                             │  │
│  └───────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

## Licensing Requirements

### Required Licenses

| License | Includes MDI |
|---------|:------------:|
| Microsoft 365 E5 | ✅ |
| Microsoft 365 E5 Security | ✅ |
| Enterprise Mobility + Security E5 (EMS E5) | ✅ |
| Microsoft Defender for Identity (standalone) | ✅ |

### Capacity Planning

| Environment Size | Sensors Needed |
|-----------------|----------------|
| Small (1-10 DCs) | 1 sensor per DC |
| Medium (10-50 DCs) | 1 sensor per DC |
| Large (50+ DCs) | 1 sensor per DC + standalone for high traffic |

## Key Use Cases

1. **Credential Theft Detection**
   - Detect Kerberoasting attacks
   - Identify password spray attacks
   - Alert on suspicious authentication

2. **Lateral Movement Detection**
   - Detect Pass-the-Hash attacks
   - Identify Pass-the-Ticket attacks
   - Track suspicious remote execution

3. **Privilege Escalation Detection**
   - Detect DCSync attacks
   - Identify Golden Ticket attacks
   - Alert on suspicious admin activities

4. **Security Posture Assessment**
   - Identify weak configurations
   - Detect unsecured accounts
   - Find legacy protocols in use

5. **Insider Threat Detection**
   - Unusual user behavior
   - Anomalous access patterns
   - Suspicious data access

## Integration Points

| Integration | Purpose |
|-------------|---------|
| Microsoft Defender XDR | Unified incident management |
| Microsoft Defender for Endpoint | Device and identity correlation |
| Microsoft Defender for Cloud Apps | Cloud identity correlation |
| Microsoft Sentinel | SIEM integration |
| Active Directory | Data source |

## Related Documentation

- [High-Level Design](02-High-Level-Design.md)
- [Low-Level Design](03-Low-Level-Design.md)
- [Capabilities](04-Capabilities.md)
- [Incident Response Process](../Processes/Incident-Response.md)

## References

- [Microsoft Defender for Identity Documentation](https://learn.microsoft.com/en-us/defender-for-identity/)
- [What is Microsoft Defender for Identity?](https://learn.microsoft.com/en-us/defender-for-identity/what-is)

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | YYYY-MM-DD | [Author] | Initial creation |

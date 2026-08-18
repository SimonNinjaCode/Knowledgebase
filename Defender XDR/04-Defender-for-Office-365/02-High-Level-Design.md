# Microsoft Defender for Office 365 - High-Level Design

## Document Information

| Item | Details |
|------|---------|
| **Product** | Microsoft Defender for Office 365 |
| **Document Type** | High-Level Design |
| **Last Updated** | YYYY-MM-DD |
| **Author** | [Author Name] |
| **Version** | 1.0 |

---

## Purpose

This document describes the high-level architecture and design of Microsoft Defender for Office 365, including major components, data flows, and integration points.

## Architecture Overview

### Conceptual Architecture

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                         Microsoft 365 Cloud                                   │
│                                                                               │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │                Microsoft Defender for Office 365                         │ │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────────┐   │ │
│  │  │ Safe        │ │ Safe        │ │ Anti-       │ │ Threat          │   │ │
│  │  │ Attachments │ │ Links       │ │ Phishing    │ │ Intelligence    │   │ │
│  │  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────────┘   │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
│                                     │                                         │
│     ┌───────────────────────────────┼───────────────────────────────┐        │
│     │                               │                               │        │
│     ▼                               ▼                               ▼        │
│  ┌────────────┐              ┌────────────┐              ┌────────────┐      │
│  │ Exchange   │              │ Microsoft  │              │ SharePoint │      │
│  │ Online     │              │ Teams      │              │ OneDrive   │      │
│  └────────────┘              └────────────┘              └────────────┘      │
└──────────────────────────────────────────────────────────────────────────────┘
                                      ▲
                                      │ SMTP/HTTPS
                                      │
┌─────────────────────────────────────┼─────────────────────────────────────────┐
│                               External Sources                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐       │
│  │ External    │  │ Partner     │  │ Customer    │  │ Attackers       │       │
│  │ Senders     │  │ Emails      │  │ Emails      │  │ (Threats)       │       │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────────┘       │
└───────────────────────────────────────────────────────────────────────────────┘
```

### Email Processing Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        Email Processing Pipeline                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Inbound Email                                                               │
│       │                                                                      │
│       ▼                                                                      │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                    Exchange Online Protection (EOP)                   │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐               │   │
│  │  │ Connection   │─▶│ Anti-Malware │─▶│ Anti-Spam    │               │   │
│  │  │ Filtering    │  │              │  │              │               │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘               │   │
│  └─────────────────────────────────────────┬────────────────────────────┘   │
│                                            │                                 │
│                                            ▼                                 │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                    Defender for Office 365                            │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐               │   │
│  │  │ Safe         │─▶│ Safe         │─▶│ Anti-        │               │   │
│  │  │ Attachments  │  │ Links        │  │ Phishing     │               │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘               │   │
│  └─────────────────────────────────────────┬────────────────────────────┘   │
│                                            │                                 │
│                                            ▼                                 │
│                                     ┌──────────────┐                        │
│                                     │   Mailbox    │                        │
│                                     │   Delivery   │                        │
│                                     └──────────────┘                        │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Data Flow Architecture

### Safe Attachments Flow

```
┌───────────────┐     ┌──────────────┐     ┌───────────────┐     ┌──────────────┐
│  Email with   │────▶│   Extract    │────▶│    Sandbox    │────▶│   Verdict    │
│  Attachment   │     │   Attachment │     │   Detonation  │     │   Decision   │
└───────────────┘     └──────────────┘     └───────────────┘     └──────────────┘
                                                                        │
                                           ┌────────────────────────────┤
                                           │                            │
                                           ▼                            ▼
                                    ┌──────────────┐            ┌──────────────┐
                                    │   CLEAN      │            │   MALICIOUS  │
                                    │   (Deliver)  │            │   (Block)    │
                                    └──────────────┘            └──────────────┘
```

### Safe Links Flow

```
┌───────────────┐     ┌──────────────┐     ┌───────────────┐
│  Email with   │────▶│   Rewrite    │────▶│   Deliver     │
│  URLs         │     │   URLs       │     │   Email       │
└───────────────┘     └──────────────┘     └───────────────┘
                                                  │
                                                  ▼
                                           User Clicks URL
                                                  │
                                                  ▼
                                    ┌──────────────────────┐
                                    │   Safe Links Check   │
                                    │   (Time-of-Click)    │
                                    └──────────────────────┘
                                                  │
                              ┌───────────────────┼───────────────────┐
                              │                   │                   │
                              ▼                   ▼                   ▼
                       ┌───────────┐       ┌───────────┐       ┌───────────┐
                       │   SAFE    │       │  SCANNING │       │  BLOCKED  │
                       │ (Proceed) │       │ (Detonate)│       │  (Block)  │
                       └───────────┘       └───────────┘       └───────────┘
```

## Major Components

### 1. Safe Attachments

| Component | Description |
|-----------|-------------|
| File Analysis | Extract and analyze attachments |
| Sandbox Detonation | Execute files in isolated environment |
| Dynamic Delivery | Deliver email while scanning |
| Verdict Engine | Determine malicious/clean status |

### Safe Attachments Modes

| Mode | Description | User Experience |
|------|-------------|-----------------|
| Block | Block malicious attachments | Attachment removed |
| Replace | Replace with notification | Placeholder in email |
| Dynamic Delivery | Deliver email, scan attachment | Email delivered, attachment delayed |
| Monitor | Log only, no action | Normal delivery |

### 2. Safe Links

| Component | Description |
|-----------|-------------|
| URL Rewriting | Rewrite URLs to proxy through Microsoft |
| Time-of-Click Verification | Check URL reputation at click time |
| URL Detonation | Sandbox analysis of suspicious URLs |
| Warning Pages | Block pages for malicious URLs |

### 3. Anti-Phishing

| Feature | Description |
|---------|-------------|
| Impersonation Protection | Detect spoofed senders |
| Mailbox Intelligence | Learn user communication patterns |
| Spoof Intelligence | Detect domain spoofing |
| First Contact Safety Tips | Warn on new external senders |

### 4. Threat Explorer (Plan 2)

| Feature | Description |
|---------|-------------|
| Email Search | Search and analyze email threats |
| Campaign Views | View related threat campaigns |
| Threat Hunting | Proactive threat investigation |
| Remediation Actions | Take action on threats |

## Integration Design

### Microsoft 365 Integration

```
┌──────────────────────────────────────────────────────────────────────────┐
│                        Microsoft Defender XDR                             │
│                                                                           │
│  ┌─────────────────────────────────────────────────────────────────────┐ │
│  │                    Unified Incident Management                       │ │
│  └───────────────────────────────┬─────────────────────────────────────┘ │
│                                  │                                        │
│      ┌────────────────┬──────────┴──────────┬────────────────┐           │
│      │                │                     │                │           │
│      ▼                ▼                     ▼                ▼           │
│  ┌────────┐    ┌────────────┐    ┌──────────────┐    ┌──────────────┐   │
│  │  MDE   │◀──▶│    MDI     │◀──▶│     MDO      │◀──▶│   MCAS       │   │
│  │Endpoint│    │  Identity  │    │  Office 365  │    │  Cloud Apps  │   │
│  └────────┘    └────────────┘    └──────────────┘    └──────────────┘   │
│                                                                           │
└──────────────────────────────────────────────────────────────────────────┘
```

### Protected Applications

| Application | Protection Type |
|-------------|----------------|
| Exchange Online | Email protection |
| Microsoft Teams | Chat and file protection |
| SharePoint Online | Document protection |
| OneDrive for Business | File protection |
| Office Apps | Safe Documents |

## Network Architecture

### MX Record Configuration

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        Email Routing Options                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Option 1: Direct to Microsoft (Recommended)                                │
│                                                                              │
│  Internet ──▶ MX: contoso-com.mail.protection.outlook.com ──▶ Exchange     │
│                                                                              │
│  Option 2: Third-Party Gateway                                              │
│                                                                              │
│  Internet ──▶ Third-Party SEG ──▶ Microsoft 365 ──▶ Exchange               │
│               (via connector)                                                │
│                                                                              │
│  Option 3: Hybrid with On-Premises                                          │
│                                                                              │
│  Internet ──▶ Microsoft 365 ◀──▶ On-Premises Exchange                       │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Security Considerations

### Data Protection

| Aspect | Implementation |
|--------|----------------|
| Data in Transit | TLS 1.2+ encryption |
| Data at Rest | Azure encryption |
| Attachment Sandbox | Isolated detonation environment |
| URL Inspection | Privacy-preserving scanning |

### Access Control

| Control | Implementation |
|---------|----------------|
| Admin Access | RBAC with role groups |
| Audit Logging | Full action logging |
| Quarantine Access | User and admin controls |
| Report Access | Role-based reporting |

## Dependencies

### Service Dependencies

| Dependency | Impact if Unavailable |
|------------|----------------------|
| Exchange Online | No email protection |
| Entra ID | No authentication |
| Microsoft Graph | Limited API access |
| Threat Intelligence | Reduced detection capability |

### Third-Party Considerations

| Scenario | Consideration |
|----------|---------------|
| Third-party SEG | Configure enhanced filtering |
| Third-party Archive | Ensure protection ordering |
| SIEM Integration | Use APIs or connectors |

## Related Documentation

- [Overview](01-Overview.md)
- [Low-Level Design](03-Low-Level-Design.md)
- [Capabilities](04-Capabilities.md)

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | YYYY-MM-DD | [Author] | Initial creation |

# Microsoft Defender for Cloud Apps - High-Level Design

## Document Information

| Item | Details |
|------|---------|
| **Product** | Microsoft Defender for Cloud Apps |
| **Document Type** | High-Level Design |
| **Last Updated** | YYYY-MM-DD |
| **Author** | [Author Name] |
| **Version** | 1.0 |

---

## Purpose

This document describes the high-level architecture and design of Microsoft Defender for Cloud Apps, including major components, data flows, and integration points.

## Architecture Overview

### Conceptual Architecture

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                         Microsoft Cloud                                       │
│                                                                               │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │                Microsoft Defender for Cloud Apps                         │ │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────────┐   │ │
│  │  │ Discovery   │ │ App         │ │ Policy      │ │ Analytics       │   │ │
│  │  │ Engine      │ │ Connectors  │ │ Engine      │ │ Engine          │   │ │
│  │  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────────┘   │ │
│  │                                                                          │ │
│  │  ┌─────────────────────────────────────────────────────────────────┐    │ │
│  │  │           Conditional Access App Control (Reverse Proxy)        │    │ │
│  │  └─────────────────────────────────────────────────────────────────┘    │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
│                                     │                                         │
│           ┌─────────────────────────┼─────────────────────────┐              │
│           │                         │                         │              │
│           ▼                         ▼                         ▼              │
│  ┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐      │
│  │   Microsoft 365 │      │   Salesforce    │      │    Box/         │      │
│  │   (O365, Azure) │      │                 │      │    Dropbox      │      │
│  └─────────────────┘      └─────────────────┘      └─────────────────┘      │
│                                                                               │
└──────────────────────────────────────────────────────────────────────────────┘
                                      ▲
                                      │
┌─────────────────────────────────────┼─────────────────────────────────────────┐
│                      Customer Environment                                      │
│                                     │                                          │
│  ┌───────────────────────────────────────────────────────────────────────┐    │
│  │                      Data Sources for Discovery                        │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐   │    │
│  │  │  Firewall   │  │   Proxy     │  │  Defender   │  │    SIEM     │   │    │
│  │  │   Logs      │  │   Logs      │  │ for Endpoint│  │    Logs     │   │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘   │    │
│  └───────────────────────────────────────────────────────────────────────┘    │
│                                                                                │
└────────────────────────────────────────────────────────────────────────────────┘
```

### Component Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                  Defender for Cloud Apps Components                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                         DISCOVERY                                       │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                 │ │
│  │  │   Log        │  │   Cloud      │  │   Risk       │                 │ │
│  │  │   Collector  │  │   App        │  │   Scoring    │                 │ │
│  │  │              │  │   Catalog    │  │              │                 │ │
│  │  └──────────────┘  └──────────────┘  └──────────────┘                 │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                      APP CONNECTORS                                     │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                 │ │
│  │  │   API        │  │   Activity   │  │   File       │                 │ │
│  │  │   Integration│  │   Monitoring │  │   Scanning   │                 │ │
│  │  └──────────────┘  └──────────────┘  └──────────────┘                 │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │              CONDITIONAL ACCESS APP CONTROL                             │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                 │ │
│  │  │   Reverse    │  │   Session    │  │   Real-time  │                 │ │
│  │  │   Proxy      │  │   Policies   │  │   Controls   │                 │ │
│  │  └──────────────┘  └──────────────┘  └──────────────┘                 │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Data Flow Architecture

### Cloud Discovery Flow

```
┌───────────────────────────────────────────────────────────────────────────┐
│                      Cloud Discovery Data Flow                             │
├───────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  Option 1: Log Collector                                                   │
│  ┌─────────┐     ┌──────────────┐     ┌───────────────┐     ┌──────────┐ │
│  │ Firewall│────▶│    Log       │────▶│    Cloud      │────▶│ Discovery│ │
│  │ /Proxy  │     │  Collector   │     │   Upload      │     │  Engine  │ │
│  └─────────┘     │  (Docker/VM) │     │               │     │          │ │
│                  └──────────────┘     └───────────────┘     └──────────┘ │
│                                                                            │
│  Option 2: Defender for Endpoint                                          │
│  ┌─────────┐     ┌──────────────┐     ┌───────────────┐     ┌──────────┐ │
│  │ Endpoint│────▶│    MDE       │────▶│    Direct     │────▶│ Discovery│ │
│  │         │     │   Agent      │     │   Integration │     │  Engine  │ │
│  └─────────┘     └──────────────┘     └───────────────┘     └──────────┘ │
│                                                                            │
│  Option 3: API Upload                                                      │
│  ┌─────────┐     ┌──────────────┐                           ┌──────────┐ │
│  │ SIEM/   │────▶│    API       │─────────────────────────▶│ Discovery│ │
│  │ Proxy   │     │   Upload     │                           │  Engine  │ │
│  └─────────┘     └──────────────┘                           └──────────┘ │
│                                                                            │
└───────────────────────────────────────────────────────────────────────────┘
```

### App Connector Flow

```
┌───────────────┐     ┌──────────────┐     ┌───────────────┐     ┌──────────────┐
│  Cloud App    │────▶│   API        │────▶│    Data       │────▶│   Policy     │
│  (SaaS)       │     │   Connection │     │   Ingestion   │     │   Engine     │
└───────────────┘     └──────────────┘     └───────────────┘     └──────────────┘
                                                                        │
                                            ┌───────────────────────────┤
                                            │                           │
                                            ▼                           ▼
                                    ┌──────────────┐            ┌──────────────┐
                                    │   Activity   │            │   Alert      │
                                    │   Logs       │            │   Generation │
                                    └──────────────┘            └──────────────┘
```

### Conditional Access App Control Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                   Conditional Access App Control Flow                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  1. User accesses app ──▶ Entra ID authentication                           │
│                                     │                                        │
│                                     ▼                                        │
│  2. Conditional Access Policy triggers MCAS session control                 │
│                                     │                                        │
│                                     ▼                                        │
│  3. Session proxied through MDCA   ┌─────────────────────────────────┐      │
│                                    │     Defender for Cloud Apps      │      │
│                                    │       (Reverse Proxy)            │      │
│                                    │  ┌─────────────────────────────┐ │      │
│                                    │  │  Session Monitoring         │ │      │
│                                    │  │  • Activity logging         │ │      │
│                                    │  │  • Download control         │ │      │
│                                    │  │  • Upload control           │ │      │
│                                    │  │  • Copy/paste control       │ │      │
│                                    │  │  • Print control            │ │      │
│                                    │  └─────────────────────────────┘ │      │
│                                    └─────────────────────────────────┘      │
│                                     │                                        │
│                                     ▼                                        │
│  4. User accesses cloud app with controls applied                           │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Major Components

### 1. Cloud Discovery

| Component | Purpose |
|-----------|---------|
| Log Collector | Collect firewall/proxy logs |
| Cloud App Catalog | Database of 31,000+ apps |
| Risk Assessment | Score apps based on 90+ factors |
| Discovery Dashboard | Visualize shadow IT |

### 2. App Connectors

| Component | Purpose |
|-----------|---------|
| API Connectors | Deep integration with apps |
| Activity Monitoring | Track user activities |
| File Scanning | Inspect files for sensitive data |
| Governance Actions | Apply remediation actions |

### 3. Conditional Access App Control

| Component | Purpose |
|-----------|---------|
| Reverse Proxy | Route traffic through MDCA |
| Session Policies | Control session activities |
| Access Policies | Block or allow access |
| Real-time Controls | Apply controls in real-time |

### 4. Policy Engine

| Policy Type | Purpose |
|-------------|---------|
| Activity Policies | Detect suspicious activities |
| File Policies | Protect sensitive files |
| Session Policies | Control session behavior |
| Access Policies | Control app access |
| App Discovery Policies | Alert on shadow IT |
| OAuth App Policies | Control OAuth permissions |

## Integration Design

### Defender XDR Integration

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
│  │  MDE   │◀──▶│    MDI     │◀──▶│     MDO      │◀──▶│    MDCA      │   │
│  │Endpoint│    │  Identity  │    │  Office 365  │    │  Cloud Apps  │   │
│  └────────┘    └────────────┘    └──────────────┘    └──────────────┘   │
│                                                                           │
└──────────────────────────────────────────────────────────────────────────┘
```

### Defender for Endpoint Integration

| Feature | Purpose |
|---------|---------|
| Cloud Discovery | Discover apps from endpoint telemetry |
| App Blocking | Block unsanctioned apps on endpoints |
| Unified Investigation | Correlate endpoint and cloud signals |

### Entra ID Integration

| Feature | Purpose |
|---------|---------|
| Conditional Access | Trigger session controls |
| App Registration | Manage OAuth apps |
| Identity Protection | Risk-based controls |

## Security Considerations

### Data Protection

| Aspect | Implementation |
|--------|----------------|
| Data in Transit | TLS 1.2+ encryption |
| Data at Rest | Azure encryption |
| Log Collector | Encrypted log transmission |
| Session Data | Proxied traffic encrypted |

### Privacy Considerations

| Setting | Options |
|---------|---------|
| User Anonymization | Enable/disable user identification |
| Data Residency | Regional data storage |
| Log Retention | Configurable retention |

## Dependencies

### Technical Dependencies

| Dependency | Requirement |
|------------|-------------|
| Entra ID | Required for authentication |
| Network | HTTPS to Microsoft cloud |
| Log Collector | Docker or VM |
| Defender for Endpoint | Optional for discovery |

### Service Dependencies

| Service | Impact if Unavailable |
|---------|----------------------|
| Entra ID | No authentication |
| App APIs | No app visibility |
| Reverse Proxy | No session control |

## Related Documentation

- [Overview](01-Overview.md)
- [Low-Level Design](03-Low-Level-Design.md)
- [Capabilities](04-Capabilities.md)

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | YYYY-MM-DD | [Author] | Initial creation |

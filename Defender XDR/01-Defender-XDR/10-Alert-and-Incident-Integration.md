# Alert & Incident Integration Architecture

## Document Information

| Item | Details |
|------|---------|
| **Product** | Microsoft Defender XDR |
| **Last Updated** | November 30, 2025 |
| **Author** | Security Architecture |
| **Version** | 1.0 |

---

## Purpose

This document covers the Alert and Incident Integration architecture that enables unified alert correlation, incident creation, and coordinated response across all Defender XDR components including extended components. It explains how individual product alerts are aggregated into unified incidents for holistic threat investigation and response.

## Overview

Microsoft Defender XDR's core value proposition is unified incident management - transforming individual product alerts into correlated incidents that tell a complete story of an attack. This document details how alerts from all extended components flow into the unified incident queue and how they're correlated for coordinated response.

```
┌──────────────────────────────────────────────────────────────┐
│            Alert & Incident Integration                       │
│          (Unified Security Incident Platform)                │
├──────────────────────────────────────────────────────────────┤
│ Alert Ingestion                                              │
│ ├─ Core Products: MDE, MDI, MDO, MDCA                       │
│ ├─ Extended Components: Cloud, IoT, DLP, IRM, etc.         │
│ └─ Third-party integrations: API connectors                 │
├──────────────────────────────────────────────────────────────┤
│ Alert Correlation Engine                                     │
│ ├─ Entity-based correlation (users, devices, IPs)          │
│ ├─ Timeline-based correlation (30-min default window)      │
│ ├─ Threat intelligence correlation                         │
│ └─ MITRE ATT&CK mapping                                    │
├──────────────────────────────────────────────────────────────┤
│ Incident Management                                          │
│ ├─ Incident creation and prioritization                    │
│ ├─ Investigation workflows                                  │
│ ├─ Automated actions and response                          │
│ └─ Status tracking and reporting                           │
└──────────────────────────────────────────────────────────────┘
```

---

## Core Capabilities

### 1. Alert Ingestion

| Capability | Description |
|------------|-------------|
| **Multi-Source Ingestion** | Collect alerts from all Defender products in real-time |
| **API Connectors** | Ingest alerts from third-party SIEM, EDR, and IAM solutions |
| **High-Fidelity Filtering** | Reduce noise by filtering low-confidence alerts |
| **Alert Enrichment** | Add context (threat intel, baseline data) to each alert |
| **Severity Calibration** | Normalize severity across products (Critical, High, Medium, Low) |
| **Deduplication** | Eliminate duplicate alerts from same source |

### 2. Alert Correlation Engine

| Capability | Description |
|------------|-------------|
| **Entity Correlation** | Group alerts by common entities (user, device, IP, domain) |
| **Timeline Correlation** | Link alerts within 30-minute window (configurable) |
| **Attack Pattern Recognition** | Match against known attack frameworks (MITRE ATT&CK) |
| **Threat Intelligence** | Correlate with known malware, C2, threat actors |
| **Behavioral Baseline** | Identify deviations from normal patterns |
| **Cross-Product Correlation** | Combine signals from multiple Defender products |

### 3. Incident Creation

| Capability | Description |
|------------|-------------|
| **Automatic Grouping** | Group related alerts into single incident |
| **Severity Escalation** | Increase incident severity when alerts correlate |
| **Risk Scoring** | Calculate incident risk based on alert patterns |
| **Assignment** | Route to appropriate security team member |
| **Notifications** | Alert SOC team to new critical incidents |
| **Tracking** | Track incident status from creation to resolution |

### 4. Investigation & Response

| Capability | Description |
|------------|-------------|
| **Unified Timeline** | See all relevant events in chronological order |
| **Evidence Gallery** | Review files, emails, processes involved |
| **Entity Explorer** | Deep-dive into user, device, or domain details |
| **Related Incidents** | Identify similar incidents in past |
| **Threat Intelligence** | Context on threat actors and campaigns |
| **Recommended Actions** | Automated guidance for response |

---

## Alert Flow Architecture

### End-to-End Alert Journey

```
┌────────────────────────────────────────────────────────────────┐
│ Stage 1: Detection (Individual Products)                      │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  Product Alert Examples:                                      │
│                                                                │
│  MDE: "Suspicious process                                     │
│        (calc.exe spawned from winword.exe)"                   │
│         Alert ID: MDE-2024-ABC123                             │
│         Severity: High                                        │
│                                                                │
│  MDI: "Kerberoasting attack                                   │
│        (account SPNs dumped)"                                 │
│        Alert ID: MDI-2024-DEF456                              │
│        Severity: Critical                                     │
│                                                                │
│  MDO: "Suspicious email rules                                 │
│        (forwarding created)"                                   │
│        Alert ID: MDO-2024-GHI789                              │
│        Severity: High                                         │
│                                                                │
└─────────────────────────────────────────────────────────────────┘
                            │
                            │ (Real-time delivery)
                            ▼
┌────────────────────────────────────────────────────────────────┐
│ Stage 2: Alert Ingestion                                       │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  Ingestion Pipeline:                                          │
│  ├─ Receive all 3 alerts                                     │
│  ├─ Enrich each alert with context                           │
│  │  ├─ Add threat intelligence data                          │
│  │  ├─ Add baseline information                              │
│  │  └─ Add asset details                                     │
│  ├─ Normalize severity (High=High=Medium for this flow)      │
│  └─ Prepare for correlation                                  │
│                                                                │
└─────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────────┐
│ Stage 3: Correlation Analysis                                  │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  Correlation Engine Analysis:                                 │
│                                                                │
│  ┌─ Entity Correlation ─────────────────────────┐           │
│  │ All 3 alerts involve: john.smith@contoso.com │           │
│  │ ├─ MDE: Process execution on John's laptop   │           │
│  │ ├─ MDI: Kerberoasting from John's account    │           │
│  │ └─ MDO: Email rule from John's mailbox       │           │
│  │ Result: STRONG correlation (same user)       │           │
│  └───────────────────────────────────────────────┘           │
│                                                                │
│  ┌─ Timeline Correlation ───────────────────────┐           │
│  │ All alerts within 5-minute window:           │           │
│  │ ├─ 14:22:30 - MDE alert (process)            │           │
│  │ ├─ 14:23:15 - MDI alert (Kerberoasting)     │           │
│  │ └─ 14:24:45 - MDO alert (email rule)        │           │
│  │ Result: VERY STRONG (coordinated attack)     │           │
│  └───────────────────────────────────────────────┘           │
│                                                                │
│  ┌─ Attack Pattern Correlation ─────────────────┐           │
│  │ Pattern: Establish persistence + gather creds│           │
│  │ ├─ Exploit: Malware (MDE) = initial access  │           │
│  │ ├─ Lateral: Kerberoasting (MDI) = priv esc  │           │
│  │ └─ Persist: Email forwarding (MDO) = persist │           │
│  │ Result: CRITICAL (multi-stage attack detected)           │
│  └───────────────────────────────────────────────┘           │
│                                                                │
│  ┌─ Threat Intel Correlation ───────────────────┐           │
│  │ Known Campaign: Emotet distribution + Mimikatz            │
│  │ Result: Attack matches known TTP pattern      │           │
│  └───────────────────────────────────────────────┘           │
│                                                                │
│  FINAL CORRELATION ASSESSMENT: HIGH CONFIDENCE               │
│  These 3 alerts represent coordinated attack by single actor │
│                                                                │
└─────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────────┐
│ Stage 4: Incident Creation                                     │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  XDR Incident Created:                                        │
│                                                                │
│  Incident ID: XDR-12345                                       │
│  Title: "Possible compromised user account with persistence  │
│          mechanism"                                            │
│  Severity: CRITICAL (escalated from High)                     │
│  Status: Active - Requires Investigation                      │
│                                                                │
│  Grouped Alerts:                                              │
│  ├─ MDE-2024-ABC123 (Malware execution)                      │
│  ├─ MDI-2024-DEF456 (Kerberoasting attack)                   │
│  └─ MDO-2024-GHI789 (Email forwarding rule)                  │
│                                                                │
│  Key Entities:                                                │
│  ├─ User: john.smith@contoso.com                            │
│  ├─ Device: LAPTOP-JS001                                     │
│  ├─ Mailbox: john.smith@contoso.com                          │
│  └─ Timeline: 14:22 - 14:24 UTC                              │
│                                                                │
│  Risk Assessment:                                             │
│  ├─ Likelihood: HIGH (confirmed attack indicators)            │
│  ├─ Impact: HIGH (account compromise + persistence)          │
│  ├─ Confidence: HIGH (strong correlation)                    │
│  └─ Overall Risk: CRITICAL                                   │
│                                                                │
│  Recommended Actions:                                         │
│  ├─ IMMEDIATE: Disable user account                          │
│  ├─ IMMEDIATE: Terminate all sessions                        │
│  ├─ Investigate: Review device for artifacts                 │
│  ├─ Investigate: Check mailbox for unauthorized access       │
│  └─ Respond: Remove email forwarding rules                   │
│                                                                │
└─────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────────┐
│ Stage 5: Investigation & Response                             │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  SOC Team Workflow:                                           │
│                                                                │
│  1. Triage:                                                   │
│     ├─ Review incident summary (automated)                   │
│     ├─ Check recommended actions (automated)                 │
│     └─ Decide: Critical? → Immediate action                  │
│                                                                │
│  2. Investigation:                                            │
│     ├─ Timeline review (all 3 alerts in sequence)            │
│     ├─ Evidence review (files, processes, emails)            │
│     ├─ User investigation (check other devices, access logs) │
│     └─ Context gathering (recent job changes, access history)│
│                                                                │
│  3. Containment:                                              │
│     ├─ Disable account (auto-implemented)                    │
│     ├─ Revoke sessions (auto-implemented)                    │
│     ├─ Remove email rules (auto-implemented)                 │
│     └─ Monitor for lateral movement                          │
│                                                                │
│  4. Eradication:                                              │
│     ├─ Clean malware from device (IT Team)                   │
│     ├─ Reset passwords (IT Team)                             │
│     ├─ Review permissions (Security Team)                    │
│     └─ Check other devices (IT Team)                         │
│                                                                │
│  5. Recovery & Verification:                                 │
│     ├─ Restore normal operations (IT Team)                   │
│     ├─ Verify containment (Security Team)                    │
│     ├─ Update SIEM/logs (SOC Team)                           │
│     └─ Create incident report (Security Team)                │
│                                                                │
└─────────────────────────────────────────────────────────────────┘
```

---

## Correlation Engine Details

### Correlation Methods

#### 1. Entity-Based Correlation

Groups alerts by common entities:

```
Entity Types:
├─ User: john.smith@contoso.com
├─ Device: LAPTOP-JS001 (Windows 10 device)
├─ IP Address: 203.0.113.45 (attacker's external IP)
└─ Domain: attacker.com (attacker infrastructure)

Example Correlation:
├─ Alert 1: MDE detects process on LAPTOP-JS001
├─ Alert 2: MDI detects logon from john.smith account
├─ Alert 3: MDO detects email forwarding from john.smith
├─ Common Entity: User john.smith + Device LAPTOP-JS001
└─ Result: High confidence these are related
```

#### 2. Timeline-Based Correlation

Links alerts occurring within configurable window:

```
Default Window: 30 minutes (configurable)

Example:
├─ 14:22:30 - Alert A (MDE: malware)
├─ 14:23:45 - Alert B (MDI: Kerberoasting)
├─ 14:24:15 - Alert C (MDO: email rule)
├─ Time gaps: 1m 15s, 30s (all within 30 min)
└─ Correlation: All alerts grouped (timeline match)

Non-Example:
├─ 14:22 - Alert A (MDE: malware)
├─ 16:15 - Alert B (MDI: Kerberoasting) [1h 53m gap]
└─ Correlation: May not group (time gap too large)
```

#### 3. Attack Pattern Correlation

Matches alerts against known MITRE ATT&CK techniques:

```
Alert Pattern Recognition:

Technique Sequence Detected:
├─ T1566.002: Phishing - Attachment (MDE: malware)
├─ T1110.004: Credential Access - Kerberoasting (MDI: attack)
├─ T1114.002: Email Collection - Rules (MDO: forwarding)
└─ T1547.001: Persistence - Boot (MDE: scheduled task)

Attack Pattern Analysis:
├─ Sequence matches: Known APT campaign
├─ TTP progression: Attack flowcharted
├─ Confidence level: 95% (exact match to campaign)
└─ Result: CRITICAL - Advanced adversary activity
```

#### 4. Severity Escalation

Initial alerts may be lower severity, but correlation elevates:

```
Incident Severity Escalation:

Individual Alerts:
├─ MDE: "Suspicious process" = HIGH severity
├─ MDI: "Kerberoasting attack" = CRITICAL
├─ MDO: "Suspicious email rule" = MEDIUM
└─ Incident Baseline: CRITICAL (from MDI)

Escalation Logic:
├─ Single alert: Use alert severity
├─ 2+ alerts: Use highest severity
├─ Multi-stage attack pattern: AUTO-ESCALATE
├─ Known campaign match: AUTO-ESCALATE
├─ External IP involved: AUTO-ESCALATE
└─ Result: Incident severity = CRITICAL
```

---

## App Governance Integration

While primarily part of Defender for Cloud Apps, App Governance contributes to incident correlation:

### App Governance Alerts

| Alert Type | Description | XDR Integration |
|-----------|-------------|-----------------|
| **Malicious App** | Detected suspicious OAuth app behavior | Create alert → Correlate with user activity |
| **Compromised App** | OAuth app credentials likely compromised | Link to account compromise incident |
| **Risky Permissions** | App requesting excessive permissions | Add context to incident involving that app |
| **Anomalous Usage** | App used in unusual ways | Correlate with other user anomalies |

### Example: Compromised App Scenario

```
Detection:

App Governance Alert:
├─ App: "Document Analyzer"
├─ Type: OAuth-connected SaaS
├─ Behavior: Accessing emails for all users
├─ Typical: Reads only specified documents
├─ Signal: Compromised app credentials
└─ Risk: HIGH
     │
     ▼
Correlation:

Email anomalies + App anomaly:
├─ Defenders for Office 365: "Unusual email access patterns"
├─ App Governance: "Compromised app accessing all emails"
├─ Identity: "Failed MFA attempts from app"
└─ Result: CRITICAL - Multi-vector attack
     │
     ▼
XDR Incident:

"Possible compromise of cloud application"
├─ Severity: CRITICAL
├─ Vectors: App + Email + Identity
├─ Recommendation: Revoke app consent
├─ Impact: Access restoration for users
└─ Timeline: Track app access to unauthorized data
```

---

## Incident Lifecycle

### Standard Incident States

```
┌──────────────────────────────────────────────────────────┐
│ Incident Lifecycle                                       │
├──────────────────────────────────────────────────────────┤
│                                                          │
│ 1. NEW (Initial Detection)                              │
│    ├─ Incident created                                  │
│    ├─ Alerts correlated                                │
│    ├─ Risk scored                                       │
│    └─ Status: Waiting for SOC assignment                │
│         │                                               │
│         ▼                                               │
│                                                          │
│ 2. IN_PROGRESS (Investigation)                          │
│    ├─ SOC team assigned                                 │
│    ├─ Investigation started                             │
│    ├─ Initial containment actions taken                 │
│    └─ Status: Actively investigating                    │
│         │                                               │
│         ▼                                               │
│                                                          │
│ 3. REMEDIATED (Containment Complete)                    │
│    ├─ Threat contained                                  │
│    ├─ Immediate actions completed                       │
│    ├─ Root cause identified                             │
│    └─ Status: Awaiting full resolution                  │
│         │                                               │
│         ▼                                               │
│                                                          │
│ 4. RESOLVED (Investigation Complete)                    │
│    ├─ All eradication completed                         │
│    ├─ Systems restored                                  │
│    ├─ Verification completed                            │
│    └─ Status: Incident closed                           │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

### Incident Workflow Example

```
Hour 0 (14:00 UTC) - Detection
├─ Alerts detected from 3 products
├─ Correlation engine identifies coordinated attack
├─ XDR incident created (severity: CRITICAL)
├─ Notification sent to SOC team
└─ Incident status: NEW → assigned to SOC analyst

Hour 0-1 (14:00-15:00) - Initial Investigation
├─ Analyst reviews incident summary
├─ Decision: Immediate action required
├─ Action 1: Disable user account (automated)
├─ Action 2: Terminate all sessions (automated)
├─ Incident status: NEW → IN_PROGRESS
└─ Investigation depth: Review timeline, evidence

Hour 1-2 (15:00-16:00) - Containment
├─ Verify user account disabled
├─ Confirm no other active sessions
├─ Remove email forwarding rules
├─ Check for lateral movement attempts
├─ Incident status: IN_PROGRESS → REMEDIATED
└─ Next step: Eradication (IT Team)

Hour 2-4 (16:00-18:00) - Eradication & Recovery
├─ IT: Clean malware from device
├─ IT: Reset user password
├─ Security: Audit account permissions
├─ Security: Check other devices from user
├─ Verification: Confirm clean state
└─ Incident status: REMEDIATED → RESOLVED

Hour 4+ (18:00+) - Post-Incident
├─ Create incident report
├─ Document lessons learned
├─ Update detection rules if needed
├─ Brief management on findings
└─ Archive incident for future reference
```

---

## Alert Deduplication & Noise Reduction

### Deduplication Strategy

```
Same Alert Recurring (Malware):

Raw Detections:
├─ 14:22:30 - Malware detected (MDE)
├─ 14:22:31 - Malware detected (MDE) - Duplicate
├─ 14:22:32 - Malware detected (MDE) - Duplicate
├─ 14:23:15 - Same malware detected (MDE)
└─ 14:23:16 - Same malware detected (MDE) - Duplicate

After Deduplication:
├─ 14:22:30 - Malware detected (MDE)
├─ 14:23:15 - Same malware (recurrence)
└─ Result: Grouped into single alert with count

Interpretation:
├─ Single detection: Isolated incident
├─ Recurring detections: Potential ongoing infection
└─ Timeline: Track infection duration
```

### Noise Reduction

```
Low-Confidence Alerts (Filtered):

Alerts Filtered Out (no incident creation):
├─ Confidence < 30%: Likely false positive
├─ Severity: Low + no correlation
├─ Status: Unknown (unproven threat)
├─ Reason: User behavior patterns indicate legitimate
└─ Status: Logged but not escalated

Alerts Kept (incident eligible):
├─ Confidence ≥ 50%: Medium to High confidence
├─ Severity: Medium or High
├─ Status: Known threat or correlation
├─ Reason: Genuine security concern
└─ Status: Available for incident correlation
```

---

## Recommended Actions

Automated recommendations provided to SOC team:

### Critical Incident Recommendations

```
Incident: Compromised User Account (CRITICAL)

IMMEDIATE ACTIONS (0-30 minutes):

1. Disable User Account
   ├─ Command: Azure AD / Entra ID disable
   ├─ Effect: User cannot sign in
   ├─ Reversible: Yes
   └─ Automated: Can be auto-implemented

2. Terminate Active Sessions
   ├─ Command: Revoke all refresh tokens
   ├─ Effect: All devices signed out
   ├─ Duration: Immediate
   └─ Recovery: Re-authentication required

3. Remove Email Forwarding Rules
   ├─ Command: Delete forwarding rules
   ├─ Effect: Stop email exfiltration
   ├─ Scope: All mailboxes of user
   └─ Verification: Check no new rules

INVESTIGATION (1-4 hours):

4. Device Investigation
   ├─ Process: Collect device forensics
   ├─ Scope: All devices used by user
   ├─ Timeline: Last 30 days minimum
   └─ Artifacts: Malware, logs, registry

5. Account Investigation
   ├─ Access logs: Review all sign-ins
   ├─ Calendar: Check shared calendars
   ├─ Email: Review sent items
   └─ Permissions: Check access changes

6. Organizational Impact
   ├─ Other users: Check similar alerts
   ├─ Shared resources: Review access
   ├─ Sensitive data: Check access patterns
   └─ Lateral movement: Search for pivots

RESPONSE (4+ hours):

7. Remediation & Recovery
   ├─ Password reset: Force new password
   ├─ Device clean: Rebuild if necessary
   ├─ MFA re-registration: Re-enroll
   └─ Verification: Confirm clean state

8. Prevention
   ├─ Monitor: Increased monitoring for user
   ├─ Policies: Strengthen access controls
   ├─ Training: User security awareness
   └─ Review: Access level appropriateness
```

---

## Automation & Orchestration

### Automated Response Actions

XDR can automatically implement certain response actions:

| Action | Product | Risk | Impact | Auto? |
|--------|---------|------|--------|-------|
| **Disable user** | Entra ID | Low | Blocks access | Yes |
| **Kill process** | MDE | Low | Stops execution | Yes |
| **Block IP** | Network | Medium | May block legitimate | Config |
| **Quarantine email** | MDO | Low | Prevents access | Yes |
| **Isolate device** | MDE | High | Takes device offline | Config |
| **Reset password** | Entra ID | High | User must reset | No |
| **Delete item** | MDO | Critical | Permanent action | No |

---

## Related Documentation

- [Defender XDR Overview](01-Overview.md)
- [High-Level Design](02-High-Level-Design.md)
- [Low-Level Design](03-Low-Level-Design.md)
- [Capabilities](04-Capabilities.md)
- [Security Exposure Management](05-Security-Exposure-Management.md)
- [Multi-Cloud Strategy](06-Multi-Cloud-Strategy.md)
- [IoT and OT Security](07-IoT-and-OT-Security.md)
- [Entra ID Protection](08-Entra-ID-Protection.md)
- [Data and Insider Security](09-Data-and-Insider-Security.md)

---

## References

- [Microsoft Defender XDR Incident Management](https://learn.microsoft.com/en-us/defender-xdr/incidents-overview)
- [Alert Correlation in Defender XDR](https://learn.microsoft.com/en-us/defender-xdr/advanced-hunting-query-language)
- [MITRE ATT&CK Framework](https://attack.mitre.org)
- [Automated Investigation & Response](https://learn.microsoft.com/en-us/defender-xdr/configure-automated-investigation-remediation)

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | November 30, 2025 | Security Architecture | Initial creation |

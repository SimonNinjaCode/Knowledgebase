# Microsoft Purview - Data & Insider Security

## Document Information

| Item | Details |
|------|---------|
| **Product** | Microsoft Purview Data Loss Prevention & Insider Risk Management |
| **Component** | Extended Component - Data Protection & User Risk |
| **Document Type** | Architecture & Capabilities Reference |
| **Last Updated** | November 30, 2025 |
| **Author** | Security Architecture |
| **Version** | 1.0 |

---

## Purpose

This document covers Microsoft Purview Data Loss Prevention (DLP) and Microsoft Purview Insider Risk Management, which together provide comprehensive protection against data exfiltration, insider threats, and compliance violations with integrated alerting to Microsoft Defender XDR.

## Overview

Microsoft Purview combines data loss prevention and insider risk management to protect sensitive information from both external threats and insider risks. DLP identifies and controls sensitive data across Microsoft 365, while Insider Risk Management detects user-centric threats including data theft, IP leakage, and policy violations.

```
┌──────────────────────────────────────────────────────────────┐
│       Microsoft Purview Security                              │
│  (Data Protection & Insider Threat Management)               │
├──────────────────────────────────────────────────────────────┤
│ Data Loss Prevention (DLP)                                   │
│ ├─ Content Discovery & Classification                       │
│ ├─ Policy Enforcement                                       │
│ ├─ Access Control & Remediation                             │
│ └─ Compliance Automation                                    │
├──────────────────────────────────────────────────────────────┤
│ Insider Risk Management (IRM)                                │
│ ├─ User Risk Scoring                                        │
│ ├─ Behavioral Anomaly Detection                             │
│ ├─ Policy-Based Detection                                   │
│ └─ Investigation & Remediation                              │
├──────────────────────────────────────────────────────────────┤
│ Integrated Threat Response                                   │
│ ├─ Alert Correlation                                        │
│ ├─ XDR Incident Integration                                 │
│ └─ Coordinated Remediation                                  │
└──────────────────────────────────────────────────────────────┘
```

---

## Core Capabilities

### Part 1: Data Loss Prevention (DLP)

#### Content Discovery & Classification

| Capability | Description |
|------------|-------------|
| **Sensitive Info Types** | Built-in detectors for PII, PHI, PCI-DSS, GDPR, custom patterns |
| **Exact Data Match** | Match specific data (customer databases, employee lists) |
| **Trainable Classifiers** | ML-based classification for custom business data |
| **Data Fingerprinting** | Document fingerprinting for precise matching |
| **Pattern Matching** | Regex and keyword-based detection |
| **Auto-Classification** | Automatic tagging of sensitive content |

#### Policy Enforcement

| Capability | Description |
|------------|-------------|
| **Content Monitoring** | Real-time monitoring across Microsoft 365 |
| **Location Scope** | Email, SharePoint, OneDrive, Teams, Power BI, Endpoints |
| **Action Enforcement** | Block, warn, allow with tracking, restrict sharing |
| **Incident Triggering** | Create XDR alerts for violations |
| **Notification** | Notify users of DLP violations |
| **Admin Actions** | Review and override policy actions |

#### Data Loss Prevention Actions

```
DLP Policy Detection Flow:

1. User Action (Send Email / Share File)
   ├─ Email: Contains credit card numbers
   ├─ Recipient: External user
   └─ Policy: Block external sharing of PCI data
        │
        ▼
2. Content Analysis
   ├─ Scan: Email body for sensitive data
   ├─ Match: 3 credit card numbers found
   ├─ Confidence: 95% (high)
   └─ Action: BLOCK
        │
        ▼
3. Policy Action
   ├─ Block: Email send denied
   ├─ Reason: "DLP policy blocked external sharing"
   ├─ User Notification: Email blocked, reason provided
   └─ Admin Notification: DLP policy match logged
        │
        ▼
4. Alternative Actions (Configurable)
   ├─ Warn: Show warning, allow user to override
   ├─ Inspect: Allow sharing with watermark
   ├─ Restrict: Allow only internal recipients
   └─ Redirect: Route to manager approval
```

### Part 2: Insider Risk Management (IRM)

#### Risk Detection

| Capability | Description |
|------------|-------------|
| **Data Theft Detection** | Unusual data downloads or bulk file copies |
| **IP Leakage Detection** | Sensitive documents shared externally |
| **Sabotage Detection** | Mass file deletions or system manipulation |
| **Policy Violation Detection** | User actions violating security policies |
| **Regulatory Violation Detection** | Actions violating compliance requirements |
| **Anomaly Detection** | Behavioral deviations from user baseline |
| **Risky User Activity** | High-risk actions correlated with user profiles |

#### User Risk Scoring

```
Insider Risk Scoring Model:

Input Signals (Weighted):

┌─────────────────────────────────┐
│ Data Access Patterns    (30%)   │
│ ├─ Unusual file access: +25    │
│ ├─ Off-hours access: +15       │
│ ├─ Large downloads: +20        │
│ └─ External sharing: +25       │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│ Communication Patterns  (20%)   │
│ ├─ Unusual recipients: +15     │
│ ├─ Policy violations: +20      │
│ └─ Risky communications: +15   │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│ Security Events         (25%)   │
│ ├─ Failed logins: +10          │
│ ├─ Admin actions: +20          │
│ └─ Device issues: +15          │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│ HR Events               (25%)   │
│ ├─ Termination notice: +30     │
│ ├─ Demotion/restructure: +15   │
│ ├─ Return of equipment: +10    │
│ └─ Disciplinary action: +15    │
└─────────────────────────────────┘

Result: User Risk Score (0-100)
├─ Low (0-33): Normal user
├─ Medium (34-66): Monitor closely
└─ High (67-100): Investigate immediately
```

#### Investigation Workflows

| Workflow | Purpose | Actions |
|----------|---------|---------|
| **Alert Review** | Evaluate alert accuracy | Review details, dismiss, or investigate |
| **User Investigation** | Examine user's full activity history | View timeline, files, communications |
| **Case Management** | Formal investigation process | Assign reviewers, document findings |
| **Remediation** | Take corrective actions | User restrictions, escalation, termination |

---

## Threat Scenarios

### Scenario 1: Data Theft - Sudden Exfiltration

```
Detection Timeline:

14:00 - Normal Baseline
├─ User: john.smith@contoso.com
├─ Activity: Typical daily work
└─ File access: ~10-20 files per hour

14:30 - Anomaly Alert Triggered
├─ Unusual activity detected
├─ Files downloaded: 500+ in 30 minutes
├─ Destination: USB drive (external)
├─ Timing: 2:30 PM (unusual)
└─ Risk: HIGH
     │
     ▼
14:32 - Insider Risk Detection
├─ Signal 1: Bulk file downloads (500+ files)
├─ Signal 2: Data marked as confidential
├─ Signal 3: External destination storage
├─ Signal 4: Attempted encryption of files
├─ Correlation: Data exfiltration attempt
└─ Action: Create insider threat alert
     │
     ▼
14:35 - DLP Alert (if enabled)
├─ Policy: "Block external data transfer"
├─ Match: Confidential files detected
├─ Action: Block transfer attempt
├─ Notification: User notified - transfer blocked
└─ Admin: DLP violation logged
     │
     ▼
14:40 - XDR Incident Created
├─ Source: Insider Risk Management
├─ Title: "Possible data theft by user"
├─ Evidence:
│  ├─ Bulk file downloads (500 files)
│  ├─ Confidential classification
│  ├─ External destination USB
│  └─ Failed encryption attempt
├─ Risk Level: CRITICAL
└─ Recommendation: Immediate investigation
     │
     ▼
Investigation Actions:
├─ Review: Files accessed (names, sizes, classification)
├─ Timeline: When were files accessed?
├─ Context: Is user leaving company? (check HR)
├─ Escalation: Notify security team immediately
└─ Containment: Restrict user's file access pending investigation
```

### Scenario 2: IP Leakage - Shared Confidential Document

```
Detection:

User Action:
├─ File: "Product-Roadmap-2026.docx" (Marked: Confidential)
├─ Action: Shared externally with supplier@external.com
├─ Reason: Claimed "accidental email"
└─ DLP Policy: "Block external sharing of confidential docs"
     │
     ▼
DLP Response:
├─ Detection: Confidential doc + external recipient
├─ Action: Block sharing
├─ User sees: "This document cannot be shared externally"
├─ Reason: "DLP policy: Confidential data protection"
└─ User option: "Request override from manager"
     │
     ▼
Insider Risk Context:
├─ Event: Suspicious sharing attempt (even though blocked)
├─ Risk factors:
│  ├─ Confidential document shared
│  ├─ External recipient (supplier)
│  ├─ User claims "accidental"
│  └─ Document contains product plans (high value)
├─ Assessment: LOW to MEDIUM risk
└─ Status: Monitor for future similar attempts

If Pattern Continues:
├─ 2nd attempt: 1 day later (another doc)
├─ 3rd attempt: 2 days later (different recipient)
├─ Risk elevation: MEDIUM to HIGH
├─ Insider threat alert: "Suspicious pattern"
└─ XDR escalation: Create investigation case
```

### Scenario 3: Sabotage - Mass File Deletion

```
Detection:

User Action:
├─ User: admin@contoso.com
├─ Action: Deletes 200+ files from shared SharePoint
├─ Timing: After-hours (11 PM)
├─ Scope: Financial records and project files
└─ Duration: 15-minute deletion spree
     │
     ▼
Immediate Detection (Real-time):
├─ SharePoint: Audit log captures deletions
├─ DLP: No match (not sensitive data from DLP perspective)
├─ IRM: Behavioral anomaly detected
│  ├─ Admin account used for after-hours access
│  ├─ Bulk deletion (unusual for normal admin work)
│  ├─ Scope: Cross-organizational files
│  └─ Timing: After-hours (anomalous)
└─ Risk Assessment: CRITICAL
     │
     ▼
Insider Risk Alert:
├─ Title: "Possible sabotage - mass file deletion"
├─ Evidence:
│  ├─ 200+ files deleted
│  ├─ Financial and operational records
│  ├─ Admin account used
│  └─ After-hours timing
├─ Suspected cause:
│  ├─ Disgruntled employee?
│  ├─ Compromised account?
│  └─ Authorized maintenance? (unlikely)
└─ Status: URGENT investigation required
     │
     ▼
XDR Incident:
├─ Severity: CRITICAL
├─ Evidence: Mass deletion + after-hours + admin account
├─ Correlation:
│  ├─ Check: Any Entra ID alerts on admin account?
│  ├─ Check: Any MDE alerts on admin's device?
│  ├─ Check: Recent password changes or anomalies?
│  └─ Finding: No other security signals (likely deliberate)
├─ Recommendation:
│  ├─ Immediate: Restore deleted files from backup
│  ├─ Immediate: Review file deletion permissions
│  ├─ Immediate: Interview affected teams
│  ├─ HR coordination: Check for disciplinary actions
│  └─ Legal: Document chain of custody
     │
     ▼
Recovery:
├─ IT: Restore 200 files from daily backup
├─ Timeline: Files restored within 2 hours
├─ Verification: Users confirm files restored
├─ Investigation: Admin account reviewed (compromised or intentional)
└─ Prevention: Tighten access controls for shared files
```

---

## DLP Policy Examples

### Policy 1: Block External Data Transfer

```
Policy Name: "Prevent External Sharing of Confidential Data"

Scope: All Microsoft 365 apps

Conditions:
├─ Content contains:
│  ├─ Sensitive info type: "Credit Card"
│  ├─ OR Sensitive info type: "US Social Security Number"
│  ├─ OR Sensitivity label: "Highly Confidential"
│  └─ Confidence: ≥ 80%
│
└─ Recipients:
   └─ External users (outside organization)

Actions:
├─ Block sharing
├─ Send notification to user
├─ Notification: "Cannot share sensitive data externally"
├─ Allow: User can request override from manager
└─ Audit: Log all attempts

Exceptions:
├─ None (strict enforcement)

Reports:
├─ Daily: Email to compliance team
├─ Show: Block actions and override requests
└─ Trending: Weekly report to leadership
```

### Policy 2: Warn on Large External Sharing

```
Policy Name: "Warn on Large External Document Sharing"

Conditions:
├─ Content size: > 5 MB
├─ Recipients: External (> 10 recipients)
└─ Content type: Any

Actions:
├─ Warn user: Show notification
├─ Message: "Sharing large files externally. Confirm intent."
├─ User options:
│  ├─ Confirm: Proceed with sharing
│  └─ Cancel: Stop sharing operation
├─ Audit: Log all sharing attempts
└─ Admin: Review for potential data leaks

Justification:
├─ Why warn?: Large external shares are often data theft
├─ Why not block?: Legitimate need to share large files with partners
└─ Risk assessment: User must consciously confirm
```

### Policy 3: Monitor and Inspect

```
Policy Name: "Monitor Financial Data Sharing"

Conditions:
├─ Content: Financial spreadsheets (keyword: "Budget", "Revenue", "P&L")
├─ Scope: Email only
└─ Recipients: External only

Actions:
├─ Allow: Permit sharing to continue
├─ Inspect: Add watermark to document
├─ Watermark text: "SHARED EXTERNALLY - [Date] [Time] [User]"
├─ Audit: Log all instances
├─ Alert: Notify data owner

Purpose:
├─ Why allow?: Financial sharing sometimes legitimate
├─ Why inspect?: Watermark creates audit trail
├─ Why alert?: Data owner notified for review
└─ Benefit: Detect patterns of financial data sharing
```

---

## Insider Risk Management Policies

### Policy 1: Departing Employees

```
Policy Name: "Risky Behavior - User Departing"

Trigger Events:
├─ HR signal: Employee termination date entered
├─ Timeline: 90 days before departure
├─ Apply to: All departing employees
└─ Status: Automatic activation

Risk Indicators (Monitored):
├─ Data access: Unusual files accessed
├─ Data downloads: Files copied to USB/personal storage
├─ External sharing: Documents shared with external users
├─ Email forwarding: New forwarding rules created
├─ Password changes: Recent password modifications
└─ Off-hours access: Access outside normal hours

Actions (Automatic):
├─ Daily: Monitor all above indicators
├─ Alert threshold: 3+ suspicious activities = alert
├─ Escalation: CRITICAL if downloading large volumes
└─ Investigation: Assign case to security team

Case Actions (Manual):
├─ Review: All monitored activities
├─ Communicate: Manager notification (optional)
├─ Restrict: Disable external sharing (if risky)
├─ Close case: After employee departure
└─ Retain: Evidence for 1 year post-departure
```

### Policy 2: Data Theft Detection

```
Policy Name: "Possible Data Theft"

Risk Indicators:
├─ Bulk file downloads (>100 files in 1 hour)
├─ File access to confidential data
├─ Download to external storage device
├─ Unusual off-hours timing
├─ Multiple failed print attempts
├─ Attempts to encrypt files
└─ Large email attachments sent externally

Correlation:
├─ Alert if: 2+ indicators within 30 minutes
├─ Escalate if: 4+ indicators
├─ CRITICAL if: Repeated patterns over days
└─ Include: Data classification context

Case Actions:
├─ Immediate: Review activity timeline
├─ Investigate: Check file contents and classification
├─ Correlate: Any other users involved?
├─ Escalate: If confirmed data theft attempt
├─ Contain: Restrict user's access if necessary
└─ Legal: Inform legal team if criminal activity suspected
```

### Policy 3: Security Policy Violation

```
Policy Name: "Violations of Security Policy"

Violations Monitored:
├─ Unsafe password practices (reuse, weak passwords)
├─ Unauthorized USB device usage
├─ Circumventing security controls
├─ Accessing resources without authorization
├─ Violating clean desk policy (physical docs)
├─ Sharing credentials with others
└─ Connecting personal devices to corporate network

Detection:
├─ Source: Security signals (MDE, log analysis)
├─ Frequency: Monitored continuously
├─ Threshold: Alert on first violation (if security critical)
└─ Escalation: Multiple violations trigger investigation

Case Actions:
├─ Training: First offense = security training
├─ Remediation: Fix security issue (e.g., enable MFA)
├─ Monitoring: Increased monitoring for 30 days
├─ Escalation: Multiple violations = formal investigation
└─ Discipline: Policy violation consequences per HR policy
```

---

## Architecture

### DLP Architecture

```
┌──────────────────────────────────────────────────────────────┐
│ Microsoft 365 Services                                       │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐    │
│  │  Email   │  │ SharePoint│  │ OneDrive │  │  Teams   │    │
│  │          │  │           │  │          │  │          │    │
│  └────┬─────┘  └────┬──────┘  └────┬─────┘  └────┬─────┘    │
│       │             │              │             │          │
│       └─────────────┼──────────────┼─────────────┘          │
│                     │              │                        │
│            ┌────────▼──────────────▼──────┐               │
│            │ DLP Policy Engine            │               │
│            │ (Real-time Analysis)         │               │
│            │                              │               │
│            │ • Content scanning           │               │
│            │ • Sensitive info matching    │               │
│            │ • Policy evaluation          │               │
│            └────────┬─────────────────────┘               │
│                     │                                     │
│      ┌──────────────┼──────────────┐                    │
│      ▼              ▼              ▼                    │
│   ┌────────┐  ┌──────────┐  ┌──────────┐             │
│   │ Block  │  │  Warn    │  │  Inspect │             │
│   │ Action │  │ + Allow  │  │+ Track   │             │
│   └────────┘  └──────────┘  └──────────┘             │
│                                                         │
│      ┌──────────────────────────────────┐            │
│      │ Logging & Alerting               │            │
│      │ ├─ Audit log                     │            │
│      │ ├─ DLP Reports                   │            │
│      │ └─ Alert to Security Team        │            │
│      └──────────────────────────────────┘            │
│                                                         │
└──────────────────────────────────────────────────────────┘
       │
       ▼
   [Defender XDR - Alert Integration]
```

### Insider Risk Management Architecture

```
┌──────────────────────────────────────────────────────────────┐
│ Data Sources                                                 │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ Audit Logs   │  │ HR Systems   │  │ Entra ID     │      │
│  │ (M365 apps)  │  │ (Termination)│  │ (Sign-ins)   │      │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘      │
│         │                 │                 │              │
│         │                 │                 │              │
│  ┌──────▼─────────────────▼─────────────────▼──────┐      │
│  │ IRM Processing Engine                           │      │
│  │ ├─ Signal correlation                          │      │
│  │ ├─ Behavior baseline comparison                │      │
│  │ ├─ User risk scoring                           │      │
│  │ └─ Policy evaluation                           │      │
│  └──────┬─────────────────────────────────────────┘      │
│         │                                                 │
│  ┌──────▼──────────────────────────────────┐             │
│  │ Alert Generation                         │             │
│  │ ├─ Insider threat alerts                │             │
│  │ ├─ Risk severity (Low/Med/High)         │             │
│  │ └─ Recommended investigations           │             │
│  └──────┬──────────────────────────────────┘             │
│         │                                                 │
│         ├──────────────────────┐                         │
│         ▼                      ▼                         │
│    ┌─────────┐         ┌──────────────┐               │
│    │ Portal  │         │ XDR Alert    │               │
│    │ Cases   │         │ (High Risk)  │               │
│    └─────────┘         └──────────────┘               │
│                                                        │
└──────────────────────────────────────────────────────────┘
```

---

## Integration with Defender XDR

### Alert Generation & Correlation

```
Insider Risk Detection
├─ Type: Data exfiltration attempt
├─ User: John Smith (john.smith@contoso.com)
├─ Activity: 500+ files downloaded to USB
├─ Classification: Confidential
├─ Timing: After-hours
└─ Risk: HIGH
     │
     ▼
IRM Alert Created
├─ Title: "Possible data theft"
├─ Severity: High
├─ Risk Indicators: 5 signals matched
└─ Timestamp: 2025-11-30 23:15 UTC
     │
     ▼
XDR Correlation Check
├─ User John Smith - check MDE alerts: NONE
├─ User John Smith - check MDI alerts: Unusual access pattern
├─ User John Smith - check MDO alerts: Large email forwarding
├─ User John Smith - check Entra ID alerts: Risky sign-in from VPN
└─ Result: 3 correlated signals found
     │
     ▼
XDR Incident Created
├─ Title: "Suspicious user activity - potential insider threat"
├─ Severity: CRITICAL (correlated from 4 products)
├─ Evidence:
│  ├─ IRM: 500 files downloaded, after-hours, USB destination
│  ├─ MDI: Unusual access pattern (lateral movement?)
│  ├─ MDO: Email forwarding to external account
│  └─ Entra ID: Risky sign-in from VPN
├─ Risk Assessment: CRITICAL - coordinated insider threat
└─ Timeline:
   ├─ 22:30 - Risky sign-in detected
   ├─ 22:35 - Unusual access patterns begin
   ├─ 22:45 - Email forwarding rule created
   ├─ 22:50 - Files downloaded to USB
   └─ 23:15 - IRM alert triggered, XDR incident created
```

### Incident Investigation

When investigating XDR incident involving insider threat:

```
Investigation Dashboard:

Timeline View:
├─ 22:30 - Entra ID: "Risky sign-in from VPN in Singapore"
├─ 22:32 - MDI: "Unusual Kerberos activity from workstation"
├─ 22:35 - MDO: "Email forwarding rule created (to external)"
├─ 22:45 - IRM: "Bulk file download detected (500+ files)"
└─ 22:50 - IRM: "Files copied to external USB drive"

Evidence Collection:
├─ Files accessed:
│  ├─ Customer database: 250 files
│  ├─ Product roadmap: 150 files
│  ├─ Financial projections: 100 files
│  └─ Classification: All marked "Confidential"
│
├─ User context:
│  ├─ Role: Senior analyst (has legitimate access)
│  ├─ Recent activity: Working late 3 of past 7 nights
│  ├─ Email: Forwarding created to personal email
│  └─ HR: No termination notice or disciplinary action
│
└─ Threat assessment:
   ├─ Intent: Appears deliberate (VPN to hide location)
   ├─ Target: High-value IP (customer, product, financial data)
   ├─ Method: Bulk exfiltration via USB
   └─ Scope: Coordinated across multiple systems

Risk Determination:
├─ Likelihood: HIGH (coordinated, deliberate activity)
├─ Impact: CRITICAL (high-value data at risk)
├─ Overall Risk: CRITICAL
└─ Recommendation: IMMEDIATE action required

Recommended Actions:
├─ Immediate (within 30 minutes):
│  ├─ Disable user account access
│  ├─ Terminate all active sessions
│  ├─ Revoke email forwarding rule
│  └─ Seize workstation for forensics
│
├─ Within 1 hour:
│  ├─ Notify HR (possible termination case)
│  ├─ Notify Legal (potential criminal activity)
│  ├─ Contact law enforcement (IP theft)
│  └─ Preserve evidence (logs, USB drives)
│
└─ Investigation:
   ├─ Where did data go? (USB, email, cloud storage?)
   ├─ Who has access now? (Accomplices? Buyer?)
   ├─ Was data copied or moved? (Assess damage)
   └─ Any previous attempts? (Pattern analysis)
```

---

## Licensing

### License Requirements

| Component | License |
|-----------|---------|
| **Data Loss Prevention** | Microsoft 365 E3 or higher, or standalone |
| **Insider Risk Management** | Microsoft 365 E5 or standalone |
| **Combined** | Microsoft 365 E5 Security |

### Included in Microsoft 365 E5

```
Microsoft 365 E5 includes:
├─ Office 365 (Email, SharePoint, Teams, etc.)
├─ Windows 10/11 Enterprise
├─ Enterprise Mobility + Security
├─ Data Loss Prevention
├─ Insider Risk Management
├─ Defender for Office 365
├─ Defender for Endpoint
└─ Plus: All other Defender components
```

---

## Best Practices

### DLP Best Practices

1. **Start with discovery**: Run DLP reports before enforcing policies
2. **Test in notify mode**: Warn before blocking to understand impact
3. **Gradual rollout**: Start with high-sensitivity data, expand gradually
4. **Clear user communication**: Train users on policy rationale
5. **Regular reviews**: Quarterly assessment of DLP effectiveness
6. **Incident response**: Quick response to policy violations

### Insider Risk Best Practices

1. **Privacy first**: Ensure compliance with data privacy regulations
2. **Minimize scope**: Only monitor when justified by risk
3. **Clear policies**: Document insider threat policies clearly
4. **Fair investigations**: Impartial, documented processes
5. **HR coordination**: Work with HR/Legal in all cases
6. **Regular training**: User education on insider threats

---

## Related Documentation

- [Defender XDR Overview](01-Overview.md)
- [High-Level Design](02-High-Level-Design.md)
- [Low-Level Design](03-Low-Level-Design.md)
- [Capabilities](04-Capabilities.md)
- [Alert & Incident Integration](10-Alert-and-Incident-Integration.md)

---

## References

- [Microsoft Purview Data Loss Prevention](https://learn.microsoft.com/en-us/purview/dlp-learn-about-dlp)
- [Microsoft Purview Insider Risk Management](https://learn.microsoft.com/en-us/purview/insider-risk-management)
- [Sensitive Information Types](https://learn.microsoft.com/en-us/purview/sensitive-information-type-entity-definitions)
- [Communication Compliance](https://learn.microsoft.com/en-us/purview/communication-compliance)

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | November 30, 2025 | Security Architecture | Initial creation |

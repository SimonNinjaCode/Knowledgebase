# Microsoft Defender XDR - Low-Level Design

## Document Information

| Item | Details |
|------|---------|
| **Product** | Microsoft Defender XDR |
| **Document Type** | Low-Level Design |
| **Last Updated** | YYYY-MM-DD |
| **Author** | [Author Name] |
| **Version** | 1.0 |

---

## Purpose

This document provides detailed technical specifications, configurations, and implementation guidance for Microsoft Defender XDR.

## Prerequisites

### Licensing

- [ ] Microsoft 365 E5 or E5 Security add-on licenses assigned
- [ ] All required Defender product licenses activated

### Technical Requirements

| Requirement | Specification |
|-------------|---------------|
| Entra ID Tenant | Configured and operational |
| Global Admin | Required for initial setup |
| Network Access | HTTPS 443 to Microsoft endpoints |

### Required URLs

```
*.security.microsoft.com
*.securitycenter.windows.com
*.protection.office.com
*.cloudappsecurity.com
```

## Configuration Specifications

### 1. Portal Access Configuration

#### Default Entra ID Roles with Defender XDR Access

| Role | Permission |
|------|------------|
| Global Administrator | Full access to all Defender XDR functionalities and data |
| Security Administrator | Same as Global administrator |
| Security Operator | Extensive access, including managing alerts, responses, and security settings, but with limited data access compared to Global Administrator and Security Administrator |
| Global Reader | Read-only access to Defender XDR data and Secure Score |
| Security Reader | Like Global Reader, with read-only access to data and Secure Score |

> **Recommendation:** Utilize the built-in RBAC model in Defender XDR to achieve higher levels of security and granularity.

#### Activate RBAC Workloads

Navigate to: **Defender XDR > System > Permissions > Roles > Workload Settings**

Ensure all workloads are activated for unified role-based access control:
- Endpoints & Vulnerability Management
- Email & Collaboration
  - Defender for Office 365
  - Exchange Online Permissions
- Identity
- Cloud Apps

#### Custom Role Configuration - Security Analyst (Reader)

| Permission Group | Description | Configured Setting |
|-----------------|-------------|-------------------|
| Security operations | Manages day-to-day operations and responds to incidents and advisories | All read-only permissions |
| Security posture | Manages the organization's security posture, performs Defender Vulnerability Management | All read-only permissions |
| Authorization and settings | Manages the security and system settings, creates and assigns roles | All read-only permissions |

**Assignment:** Group for Security Analysts  
**Data sources:** All Sources + Include future data sources automatically

#### Custom Role Configuration - Security Administrator (Full Access)

| Permission Group | Description | Configured Setting |
|-----------------|-------------|-------------------|
| Security operations | Manages day-to-day operations and responds to incidents and advisories | All read and manage permissions |
| Security posture | Manages the organization's security posture, performs Defender Vulnerability Management | All read and manage permissions |
| Authorization and settings | Manages the security and system settings, creates and assigns roles | All read and manage permissions |

**Assignment:** Group for Security Administrators  
**Data sources:** All Sources + Include future data sources automatically

#### PIM-Enabled Groups for Just-in-Time Access

Create groups that are role-assignable in Entra ID (one for Analysts and one for Administrators).

**Role-assignable groups** benefit from extra protections compared to non-role-assignable groups:
- Only the Global Administrator, Privileged Role Administrator, or the group Owner can manage the group
- No other users can change the credentials of the users who are (active) members of the group
- This feature helps prevent an admin from elevating to a higher privileged role without going through a request and approval procedure

**Immutable setting** (must be configured when the group is created):
- *Microsoft Entra Roles can be assigned to the group:* **Yes**

To PIM-enable the group: **Group in Entra ID > Privileged Identity Management**

This eliminates standing access to the permissions in Defender XDR. For access, elevation in PIM is needed.

#### Legacy Custom Role Example

```json
{
  "displayName": "Custom SOC Analyst",
  "description": "Custom role for Tier 1 SOC analysts",
  "rolePermissions": [
    {
      "allowedResourceActions": [
        "microsoft.securityCenter/incidents/read",
        "microsoft.securityCenter/alerts/read",
        "microsoft.securityCenter/alerts/updateStatus",
        "microsoft.securityCenter/hunting/read"
      ]
    }
  ]
}
```

## Configuration Implementation

This section provides implementation guidance for deploying and configuring Microsoft Defender XDR across your organization.

### Pre-Deployment Checklist

- [ ] Licensing verified for all required products
- [ ] Entra ID tenant configured and operational
- [ ] Global Admin access available
- [ ] Required URLs allowlisted in firewalls
- [ ] Network connectivity tested to Microsoft endpoints
- [ ] Backup and disaster recovery procedures in place

### Defender for Endpoint (MDE) Implementation

**Step 1: Deploy Sensor to Endpoints**
- Navigate to: **Settings > Endpoints > Device Management > Onboarding**
- Select platform (Windows, macOS, Linux, iOS, Android)
- Download configuration package
- Deploy via Group Policy, Intune, or manual installation

**Step 2: Configure Device Groups**
```powershell
# Create device group for critical assets
# Via Microsoft 365 Defender portal: Settings > Endpoints > Device Groups
# Add devices by tag or rule: "Device tag = Production"
# Assign automation level: Semi-automated
```

**Step 3: Verify Sensor Health**
```kusto
// KQL query to check sensor health
DeviceInfo
| where Timestamp > ago(1h)
| where OnboardingStatus == "Onboarded"
| summarize SensorCount=dcount(DeviceId) by OSPlatform
```

### Defender for Identity (MDI) Implementation

**Step 1: Create gMSA Accounts**

A group Managed Service Account (gMSA) is required for MDI sensor communications.

```powershell
# Install DefenderForIdentity PowerShell module
Install-Module DefenderForIdentity -Force

# Import module for PowerShell 7+ compatibility
Import-Module -Name GroupPolicy -SkipEditionCheck
Import-Module DefenderForIdentity

# Create Directory Services Account gMSA
$gMSAName = "MDI_DSA$"
$ManagedPasswordIntervalInDays = 30

# Create the gMSA
New-ADServiceAccount -Name $gmsaName `
    -Description "Managed Service Account for Defender for Identity" `
    -DNSHostName "$($gMSAName.TrimEnd('$')).contoso.com"

# Grant necessary permissions
Grant-DomainControllerPermissions -gMSAName $gMSAName
```

**Step 2: Install MDI Sensor on Domain Controllers**

```powershell
# Install DefenderForIdentity module
Import-Module DefenderForIdentity

# Download and install sensor
Invoke-MDISensorInstallation -SensorType DomainController `
    -OutputPath "C:\MDI-Sensor" `
    -SkipCheck $false
```

**Step 3: Verify MDI Configuration**

```powershell
# Test DSA connectivity and permissions
Test-MDIDSA-Full -gMSAName "MDI_DSA$"

# Verify sensor health
Get-MDISensorStatus
```

### Defender for Office 365 (MDO) Implementation

**Step 1: Configure Protection Policies**

Navigate to: **Settings > Email & Collaboration > Policies & Rules**

```
1. Safe Attachments Policy
   - Enable for all users: Yes
   - Dynamic Delivery: Enabled
   - Redirect malware: Yes

2. Safe Links Policy
   - Enable for all users: Yes
   - Block URLs on click: Yes
   - Apply to internal mail: Yes

3. Anti-Phishing Policy
   - Impersonation protection: Enabled
   - Advanced phishing thresholds: 2 or higher
   - User protection: All staff
```

**Step 2: Verify SPF/DKIM/DMARC**

```powershell
# Validate email authentication records
$domain = "contoso.com"

# Check SPF record
nslookup -type=TXT $domain | Select-String "v=spf1"

# Check DKIM record
$dkimSelector = "selector1"
nslookup -type=CNAME "${dkimSelector}._domainkey.${domain}"

# Check DMARC record
nslookup -type=TXT "_dmarc.${domain}"
```

**Step 3: Test Protection**

- Use **Attack Simulation & Training** > **Simulations** to run phishing simulations
- Verify quarantine is capturing test emails
- Review **Threat Explorer** for detection validation

### Defender for Cloud Apps (MDCA) Implementation

**Step 1: Connect Cloud Apps**

Navigate to: **Cloud Apps > Connected apps > App Connectors**

```
1. Microsoft 365 (built-in)
   - Already integrated
   - Requires global admin consent

2. AWS
   - Enable API access
   - Create IAM role for MDCA
   - Assign necessary permissions

3. Google Workspace
   - Enable API access
   - Create service account
   - Grant domain-wide delegation
```

**Step 2: Configure Policies**

```
1. Cloud Discovery Policies
   - Enable unsanctioned app detection
   - Set risk scoring thresholds
   - Create cloud app catalog

2. Anomaly Detection
   - Impossible travel: Enabled
   - Suspicious admin activities: Enabled
   - Activity from suspicious IP: Enabled

3. File Policies
   - DLP integration: Enabled
   - Sensitive file detection: Yes
```

**Step 3: Verify Cloud Discovery**

- Check **Cloud Discovery > Discovered apps** for shadow IT detection
- Review **Risk Score** for app assessment
- Validate **Firewall logs** ingestion if configured

### RBAC Configuration (All Products)

**Step 1: Create Role-Assignable Groups in Entra ID**

```powershell
# Create security group for analysts
$groupParams = @{
    DisplayName              = "Defender Security Analysts"
    SecurityEnabled          = $true
    IsAssignableToRole       = $true
    MailEnabled              = $false
    MailNickname             = "defender-analysts"
}
New-MgGroup @groupParams

# Create security group for admins
$adminGroupParams = @{
    DisplayName              = "Defender Security Admins"
    SecurityEnabled          = $true
    IsAssignableToRole       = $true
    MailEnabled              = $false
    MailNickname             = "defender-admins"
}
New-MgGroup @adminGroupParams
```

**Step 2: Enable PIM for JIT Access**

- Navigate to: **Entra ID > Privileged Identity Management > Groups**
- Select the role-assignable group
- Configure activation approval requirements
- Set maximum activation duration

**Step 3: Assign Custom Roles in Defender Portal**

Navigate to: **Settings > Permissions > Roles**

1. Assign "Security Analyst (Reader)" to analyst group
2. Assign "Security Administrator" to admin group
3. Configure data source restrictions (if needed)

### Post-Deployment Validation

**Week 1 - Connectivity Check**

```kusto
// Verify all products are sending data
union withsource=TableName *
| where Timestamp > ago(7d)
| summarize RecordCount=count(), LatestTimestamp=max(Timestamp) by TableName
| where RecordCount > 0
| order by LatestTimestamp desc
```

**Week 2 - Detection Validation**

- Review Threat Analytics for active campaigns
- Verify alerts are generating for test threats
- Confirm incidents are being correlated

**Week 4 - Operational Readiness**

- Review automated investigation results
- Assess false positive rate
- Validate incident response procedures
- Train SOC team on portal navigation

### Configuration Best Practices

| Area | Best Practice |
|------|----------------|
| **Licensing** | Assign all users M365 E5 or appropriate Defender SKUs |
| **Automation** | Start with "Semi-automated" level, adjust based on maturity |
| **RBAC** | Use role-assignable groups with PIM for JIT access |
| **Policies** | Define policy baselines aligned to industry standards |
| **Monitoring** | Enable comprehensive audit logging for compliance |
| **Testing** | Use attack simulation tools regularly to validate controls |

### Troubleshooting Deployment

**Sensor Not Reporting:**
1. Verify firewall rules allow traffic to `*.security.microsoft.com`
2. Check device is connected to network
3. Review sensor health in portal settings
4. Run Client Analyzer for diagnostics (MDE only)

**Policy Not Applying:**
1. Verify policy scope includes target users/devices
2. Check group membership with `-Filter "members"`
3. Wait up to 24 hours for policy propagation
4. Run `gpupdate /force` to force Group Policy refresh (if applicable)

**RBAC Permissions Denied:**
1. Verify user is member of assigned group
2. Check group is role-assignable (IsAssignableToRole = true)
3. Confirm Defender roles are properly assigned
4. Check for conflicting role assignments

For additional configuration details, refer to the **[Security Operations Schedule](../Processes/Security-Operations-Schedule.md)** for ongoing maintenance and validation tasks.

### 2. Incident Configuration

#### Incident Assignment Rules

| Rule Name | Condition | Action |
|-----------|-----------|--------|
| High Severity Auto-assign | Severity = High | Assign to Tier 2 |
| Endpoint Incidents | Source = MDE | Assign to Endpoint Team |
| Identity Incidents | Source = MDI | Assign to Identity Team |

#### Incident Tags

| Tag | Purpose |
|-----|---------|
| `Escalated` | Incident escalated to management |
| `False Positive` | Confirmed false positive |
| `In Progress` | Active investigation |
| `Waiting Customer` | Pending customer response |

### 3. Automated Investigation Configuration

#### Automation Levels

| Level | Description | Recommendation |
|-------|-------------|----------------|
| Full | Auto-remediate all threats | Production (mature SOC) |
| Semi | Auto-remediate, but require approval for sensitive actions | Production (standard) |
| No automated response | Investigation only | Initial deployment |

#### Device Group Configuration

```
Device Group: Production Servers
- Automation Level: Semi
- Membership Rules: Device tag = "Production"

Device Group: Workstations
- Automation Level: Full
- Membership Rules: Device type = "Workstation"

Device Group: VIP Devices
- Automation Level: No automated response
- Membership Rules: Device tag = "VIP"
```

### 4. Advanced Hunting Configuration

#### Scheduled Queries

| Query Name | Schedule | Action |
|------------|----------|--------|
| Suspicious PowerShell | Every 1 hour | Create alert |
| Lateral Movement Detection | Every 4 hours | Create alert |
| Data Exfiltration Patterns | Every 1 hour | Create alert |

#### Sample Custom Detection Rule

```kusto
// Detect potential credential theft
DeviceProcessEvents
| where Timestamp > ago(1h)
| where FileName in~ ("mimikatz.exe", "procdump.exe", "gsecdump.exe")
    or ProcessCommandLine has_any ("sekurlsa", "lsadump", "credentials")
| project Timestamp, DeviceName, FileName, ProcessCommandLine, AccountName
```

### 5. Notification Configuration

#### Email Notifications

| Notification Type | Recipients | Trigger |
|-------------------|------------|---------|
| High Severity Incidents | security-team@company.com | Severity = High |
| Critical Incidents | security-leads@company.com | Severity = Critical |
| Weekly Summary | security-management@company.com | Weekly schedule |

#### Integration Notifications

| System | Method | Events |
|--------|--------|--------|
| ServiceNow | Webhook | New incidents |
| Microsoft Teams | Connector | High/Critical alerts |
| Slack | Webhook | All alerts |

### 6. API Configuration

#### API Endpoints

| Endpoint | Purpose |
|----------|---------|
| `https://api.security.microsoft.com` | Main API endpoint |
| `https://api.securitycenter.microsoft.com` | Legacy endpoint |

#### API Authentication

```json
{
  "tenantId": "<tenant-id>",
  "clientId": "<app-client-id>",
  "clientSecret": "<app-secret>",
  "scope": "https://api.security.microsoft.com/.default"
}
```

#### Required API Permissions

| Permission | Type | Purpose |
|------------|------|---------|
| Incident.Read.All | Application | Read incidents |
| Incident.ReadWrite.All | Application | Manage incidents |
| AdvancedHunting.Read.All | Application | Run hunting queries |
| Alert.ReadWrite.All | Application | Manage alerts |

### 7. Automatic Attack Disruption (AAD) Configuration

#### Prerequisites for AAD

| Requirement | Details | Validation |
|-------------|---------|-----------|
| **Licensing** | Microsoft Defender for Endpoint Plan 2 required | Check license assignment |
| **Device Discovery** | Must be set to 'Standard' mode (not Basic) | Settings > Endpoints > Device discovery |
| **Product Deployment** | Broader deployment = greater coverage | Deploy across MDE, MDI, MDO, MDCA |
| **Permissions** | Global Admin or Security Admin for configuration | Verify Entra ID role assignment |

#### High-Fidelity Signal Correlation

AAD relies on signal correlation across multiple sources:

```
┌─────────────────────────────────────────────────┐
│ Signal Correlation (Millions of Signals)        │
├─────────────────────────────────────────────────┤
│ • Email signals (MDO threats, phishing)        │
│ • Identity signals (MDI lateral movement)      │
│ • Application signals (MDCA compromises)       │
│ • Document signals (file exfiltration)         │
│ • Device signals (MDE endpoint detections)     │
│ • Network signals (anomalous connections)      │
│ • User signals (behavioral anomalies)          │
│                                                │
│ → Microsoft Security Research Insights         │
│ → Continuous Investigation Insights            │
│ → High Signal-to-Noise Ratio (SNR) Output      │
└─────────────────────────────────────────────────┘
```

#### AAD Automation Levels

Configure automation preferences in: **Settings > Defender XDR > Automation settings**

| Level | Device Groups | Email | Identity | Cloud Apps |
|-------|---------------|-------|----------|-----------|
| **No Automation** | Manual approval only | Manual approval | Manual approval | Manual approval |
| **Semi-Automated** | Auto containment only | Manual review required | Manual review | Manual review |
| **Full Automation** | Auto all actions | Auto all actions | Auto all actions | Auto all actions |

#### Containment Actions Triggered

When AAD identifies an active attack, it automatically executes:

| Asset Type | Containment Action | Timeline |
|------------|-------------------|----------|
| **Devices** | Isolate from network (contain network traffic) | Immediate |
| **User Accounts** | Disable account and force password reset | Immediate |
| **Email** | Quarantine malicious emails from all mailboxes | Immediate |
| **Malicious Files** | Block file hash across all systems | Immediate |
| **Malicious URLs** | Block URL across all systems | Immediate |
| **Cloud Apps** | Suspend user app access / revoke tokens | Immediate |

#### AAD vs. Automated Investigation & Response (AIR)

| Aspect | Automatic Attack Disruption (AAD) | Automated Investigation & Response (AIR) |
|--------|-----------------------------------|------------------------------------------|
| **Trigger** | Active attack detected in progress | Alert or incident created |
| **Scope** | Whole attack at incident level | Individual alert or product |
| **Timing** | Real-time containment (seconds) | Investigation + approval (minutes) |
| **Action** | Automatic containment/disabling | Investigation with pending remediation |
| **Visibility** | AAD badge on incidents | Investigation details and evidence |

#### Configuration Example

```
Device Groups Settings:
├─ Group: Critical Assets
│  ├─ AAD Level: Full Automation
│  ├─ Alerts: Auto-remediate high confidence
│  └─ Exceptions: Finance servers (manual approval)
├─ Group: Standard Endpoints
│  ├─ AAD Level: Semi-Automated
│  ├─ Alerts: Auto-remediate critical only
│  └─ Approval: Required for data destruction
└─ Group: Development Lab
   ├─ AAD Level: No Automation
   ├─ Alerts: Manual investigation required
   └─ Approval: All actions require approval
```

### 8. Microsoft Security Copilot Integration

#### Copilot-Powered Guided Response

Microsoft Security Copilot provides AI-powered recommendations for incident response within the XDR portal.

#### Guided Response Capabilities

| Capability | Description | Use Case |
|------------|-------------|----------|
| **Response Cards** | Actionable cards with suggested remediation | Quick incident resolution |
| **Action Rationale** | Explanation for why each action is recommended | Analyst confidence and training |
| **Risk Scoring** | AI assessment of action impact and risk | Smart remediation prioritization |
| **Entity Targeting** | Identifies which users/devices/emails affected | Precise targeting of actions |
| **Batch Operations** | Group related actions for efficiency | Faster mass remediation |

#### Guided Response Workflow

```
1. Incident Created
        ↓
2. Copilot Analysis Begins
        ↓
3. Recommended Actions Generated
        ├─ Action 1: Isolate device (Risk: Low, Impact: High)
        ├─ Action 2: Disable account (Risk: Low, Impact: High)
        └─ Action 3: Quarantine email (Risk: None, Impact: Medium)
        ↓
4. Analyst Review
        ├─ Accept recommendations → Execute
        ├─ Modify recommendations → Custom action
        └─ Reject recommendations → Manual investigation
        ↓
5. Actions Executed & Tracked
```

#### Ask Defender Experts

Copilot integration includes "Ask Defender Experts" feature:

| Feature | Details |
|---------|---------|
| **What You Can Ask** | Complex threat analysis, campaign details, indicator assessment |
| **Credit System** | 10 credits per calendar quarter (unused roll over, max 20/quarter) |
| **Expiration** | End of calendar year or subscription end |
| **Availability** | Included with Defender Experts for XDR service |
| **Response Time** | 24-48 hours typical |

#### Accessing Copilot Features

Location in Defender Portal: **Incidents > [Incident Details] > Copilot Panel**

The Copilot panel displays:
- **Summary** - AI-generated incident summary and kill chain visualization
- **Next Steps** - Recommended investigation paths and actions
- **Guided Response** - Action cards with explanations
- **Evidence** - AI-highlighted key evidence and anomalies
- **Related Incidents** - Correlation with similar historical incidents

### 9. Data Retention Configuration

| Data Type | Default Retention | Configurable |
|-----------|-------------------|--------------|
| Raw data | 30 days | No |
| Incident data | 180 days | No |
| Alert data | 180 days | No |
| Hunting data | 30 days | No |

## Integration Specifications

### Microsoft Sentinel Integration

```json
{
  "connectorType": "Microsoft365Defender",
  "dataTypes": {
    "incidents": true,
    "alerts": true,
    "rawEvents": {
      "deviceEvents": true,
      "deviceNetworkEvents": true,
      "emailEvents": true,
      "identityEvents": true
    }
  }
}
```

### SIEM Integration (Generic)

| Method | Protocol | Details |
|--------|----------|---------|
| Streaming API | HTTPS | Real-time event streaming |
| REST API | HTTPS | Pull-based integration |
| Event Hub | AMQP | Azure Event Hub streaming |

## Operational Procedures

For comprehensive daily, weekly, monthly, and periodic operational tasks, refer to the **[Security Operations Schedule](../Processes/Security-Operations-Schedule.md)** document. This provides unified operational guidance across all Defender XDR products (Endpoint, Identity, Office 365, Cloud Apps).

### Operational Overview

| Frequency | Primary Focus | Key Activities | Related Process |
|-----------|-------------|-----------------|-----------------|
| **Daily** | Incident response & alert triage | Review incidents, manage false positives, check system health | [Security Operations Schedule](../Processes/Security-Operations-Schedule.md#daily-operations) |
| **Weekly** | Threat analysis & policy tuning | Review threat analytics, assess secure score changes, tune policies | [Security Operations Schedule](../Processes/Security-Operations-Schedule.md#weekly-operations) |
| **Monthly** | Configuration & feature review | Comprehensive policy audit, feature review, platform updates | [Security Operations Schedule](../Processes/Security-Operations-Schedule.md#monthly-operations) |
| **Periodic** | Maintenance & optimization | Advanced hunting, automation review, disaster recovery drills | [Security Operations Schedule](../Processes/Security-Operations-Schedule.md#periodic-operations) |

### Quick Reference - Daily Tasks

**Start of Shift:**
1. Review Microsoft 365 Defender incidents queue for new high-severity incidents
2. Triage and assign incidents to appropriate analysts
3. Check health reports (EDR sensors, antivirus, platform health)
4. Monitor threat alerts for immediate threats

**Throughout Shift:**
1. Investigate assigned incidents and update status
2. Manage false positives and alert suppression
3. Review and approve automated remediation actions
4. Coordinate cross-product incident response

**End of Shift:**
1. Summarize incident status and escalations
2. Update incident tracking and metrics
3. Hand off open incidents to next shift team

### Quick Reference - Weekly Tasks

- Message Center review for platform changes
- Threat Analytics deep dive
- Threat & Vulnerability Management (TVM) status review
- Attack Surface Reduction (ASR) reporting
- Policy effectiveness assessment
- Secure Score trending analysis

### Quick Reference - Monthly Tasks

- Comprehensive Defender configuration audit
- RBAC assignments review
- API access audit
- Custom detection effectiveness review
- Software inventory assessment
- Security posture reporting

For full task details, see **[Security Operations Schedule](../Processes/Security-Operations-Schedule.md)**.

## Troubleshooting

### Common Issues and Resolution

| Issue | Possible Cause | Resolution | Documentation |
|-------|---|---|---|
| Missing incidents | Product not integrated or licensed | Verify product licensing and configuration in each product's settings | [Licensing Requirements](#prerequisites) |
| Delayed incidents/alerts | Network connectivity or ingestion lag | Check firewall rules for required endpoints, verify proxy settings, review Message Center for service incidents | [Notification Configuration](#5-notification-configuration) |
| Sensor/Agent offline | Network failure or authentication issue | Verify network connectivity to cloud endpoints, check gMSA credentials (MDI), validate agent health | [Required URLs](#required-urls) |
| API authentication failures | Token expiration or permission issues | Refresh authentication token, verify API permissions are assigned to app registration | [API Configuration](#6-api-configuration) |
| Automated actions not executing | Automation level too restrictive or permission issues | Check device group automation settings, verify analyst approval is not pending, review action center | [Automation Levels](#automation-levels) |
| False positive alerts | Alert rule too sensitive or normal activity detected | Add exclusions/suppression rules, tune detection rules, test with custom detection rules | [Notification Configuration](#5-notification-configuration) |
| Data beyond retention | Data retention policy exceeded | Retention periods are fixed: raw data (30 days), incident/alert data (180 days) | [Data Retention Configuration](#9-data-retention-configuration) |
| Incident correlation not working | Product data not flowing or correlation rules not matching | Verify all product signals are ingesting, check Automatic Attack Disruption configuration, run diagnostic queries | [High-Fidelity Signal Correlation](#high-fidelity-signal-correlation) |

### Diagnostic Queries

Run these KQL queries in Advanced Hunting to diagnose data ingestion and correlation issues:

```kusto
// Check data ingestion health - last 24 hours
union withsource=TableName *
| where Timestamp > ago(24h)
| summarize count() by TableName
| order by count_ desc

// Check incident volume trend
IncidentInfo
| where CreationTime > ago(7d)
| summarize IncidentCount=dcount(IncidentId) by bin(CreationTime, 1h)
| order by CreationTime desc

// Check alert distribution by product
AlertInfo
| where Timestamp > ago(24h)
| summarize count() by AlertServiceSource
| order by count_ desc

// Check automated action results
AlertEvidence
| where Timestamp > ago(24h)
  and RemediationActions != ""
| project AlertId, RemediationActions, Timestamp
```

### Product-Specific Troubleshooting

**For Defender for Endpoint issues:** See [Troubleshooting](../01-Defender-XDR/03-Low-Level-Design.md#troubleshooting) or [Security Operations Schedule - Troubleshooting](../Processes/Security-Operations-Schedule.md#troubleshooting-procedures)

**For Defender for Identity issues:** Check [Security Operations Schedule - Troubleshooting](../Processes/Security-Operations-Schedule.md#troubleshooting-procedures)

**For Defender for Office 365 issues:** Check [Security Operations Schedule - Troubleshooting](../Processes/Security-Operations-Schedule.md#troubleshooting-procedures)

**For Defender for Cloud Apps issues:** Check [Security Operations Schedule - Troubleshooting](../Processes/Security-Operations-Schedule.md#troubleshooting-procedures)

### Support Resources

- **Microsoft 365 Admin Center** - Service Health > Health Overview
- **Message Center** - Track service incidents and announcements
- **Defender Portal** - Settings > Help & Support
- **Ask Defender Experts** - Available with Defender Experts for XDR service

## Related Documentation

- [Overview](01-Overview.md)
- [High-Level Design](02-High-Level-Design.md)
- [Capabilities](04-Capabilities.md)
- [Incident Response Process](../Processes/Incident-Response.md)

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | YYYY-MM-DD | [Author] | Initial creation |

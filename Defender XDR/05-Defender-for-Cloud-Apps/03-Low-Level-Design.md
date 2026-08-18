# Microsoft Defender for Cloud Apps - Low-Level Design

## Document Information

| Item | Details |
|------|---------|
| **Product** | Microsoft Defender for Cloud Apps |
| **Document Type** | Low-Level Design |
| **Last Updated** | YYYY-MM-DD |
| **Author** | [Author Name] |
| **Version** | 1.0 |

---

## Purpose

This document provides detailed technical specifications, configurations, and implementation guidance for Microsoft Defender for Cloud Apps.

## Prerequisites

### Licensing

- [ ] Microsoft Defender for Cloud Apps or equivalent licenses
- [ ] Licenses assigned to monitored users
- [ ] App Governance add-on (if required)

### Technical Requirements

| Requirement | Specification |
|-------------|---------------|
| Entra ID | Tenant configured |
| Admin Access | Security Administrator or Cloud App Security Admin |
| Network | HTTPS to Microsoft endpoints |
| Defender for Endpoint | Recommended for discovery |

### Network Requirements

| URL Pattern | Purpose | Port |
|-------------|---------|------|
| `*.cloudappsecurity.com` | Primary service | 443 |
| `*.security.microsoft.com` | Portal | 443 |
| `adapproxyservicepack.blob.core.windows.net` | Agent updates | 443 |
| `*.cloudappsecuritydocs.com` | Documentation | 443 |

## Configuration Specifications

### 1. Initial Setup

#### Organization Settings

| Setting | Recommended Value | Purpose |
|---------|-------------------|---------|
| Organization Display Name | Company Name | Portal branding |
| Time Zone | Local timezone | Log timestamps |
| Email for Notifications | security@company.com | Alerts |
| Default Domain | company.com | User matching |

#### User Anonymization

| Setting | Value | Use Case |
|---------|-------|----------|
| Anonymization | Disabled | Security operations |
| Anonymization | Enabled | Privacy-focused environments |

### 2. Cloud Discovery Configuration

#### Discovery Methods

| Method | Configuration | Best For |
|--------|---------------|----------|
| Defender for Endpoint | Enable in MDE settings | Managed endpoints |
| Log Collector | Deploy Docker/VM | Network logs |
| Manual Upload | Upload logs manually | Testing/POC |

#### Log Collector Deployment (Docker)

```bash
# Create log collector
docker run --name log-collector \
  -p 514:514/udp \
  -p 514:514/tcp \
  -e PUBLICIP='<collector-ip>' \
  -e PROXY='<proxy-server>' \
  -e CONSOLE='<console-url>' \
  -e COLLECTOR='<collector-token>' \
  --restart unless-stopped \
  mcr.microsoft.com/mcas/logcollector
```

#### Supported Log Formats

| Vendor | Format |
|--------|--------|
| Palo Alto | LEEF, CEF, W3C |
| Cisco ASA | Syslog |
| Zscaler | CSV, CEF |
| Blue Coat | W3C |
| Fortinet | Syslog |

#### Discovery Policies

| Policy | Trigger | Action |
|--------|---------|--------|
| New High-Risk App | Risk score > 5 | Alert security team |
| New Cloud Storage App | Category = Storage | Alert + review |
| High Volume App | Traffic > threshold | Alert for investigation |

### 3. App Connector Configuration

#### Microsoft 365 Connector

```
Configuration Steps:
1. Navigate to Settings > App Connectors
2. Select Microsoft 365
3. Enable required components:
   - Entra ID users and groups
   - Entra ID management events
   - Entra ID sign-in events
   - Office 365 activities
   - Office 365 files
```

#### Third-Party App Connectors

| App | Authentication | Required Permissions |
|-----|----------------|---------------------|
| Salesforce | OAuth | View all data |
| Box | OAuth | Manage enterprise |
| Dropbox | OAuth | Team member management |
| Google Workspace | Service Account | Domain-wide delegation |
| AWS | IAM Role | SecurityAudit |

#### Salesforce Connector Setup

```json
{
  "connectorType": "Salesforce",
  "authentication": "OAuth",
  "requiredPermissions": [
    "View All Data",
    "Manage Users",
    "View Event Log Files"
  ],
  "eventTypes": [
    "Login",
    "Logout",
    "Report Export",
    "Content Transfer"
  ]
}
```

### 4. Conditional Access App Control

#### Prerequisites

1. Entra ID Premium P1 or P2
2. Apps federated with Entra ID
3. Conditional Access policies configured

#### Session Control Setup

```
Configuration Steps:
1. Create Conditional Access policy in Entra ID
2. Under Session controls, select:
   - Use Conditional Access App Control
   - Use custom policy / Monitor only
3. User signs in to app
4. App appears in MDCA catalog
5. Configure session policies in MDCA
```

#### Session Policies

| Policy Type | Controls | Use Case |
|-------------|----------|----------|
| Monitor Only | Log all activities | Initial deployment |
| Block Downloads | Prevent file downloads | Unmanaged devices |
| Protect Downloads | Apply encryption | External access |
| Block Upload | Prevent uploads | Compliance |

#### Session Policy Configuration

```json
{
  "policyName": "Block Sensitive Downloads on Unmanaged",
  "filters": {
    "app": ["Salesforce", "Box"],
    "device": "Unmanaged",
    "file": {
      "sensitivityLabel": ["Confidential", "Highly Confidential"]
    }
  },
  "action": "Block",
  "alert": true
}
```

### 5. Activity Policies

#### Built-in Policies

| Policy | Detection | Severity |
|--------|-----------|----------|
| Mass download by single user | >50 downloads in 1 hour | Medium |
| Multiple failed login attempts | >10 failures in 5 minutes | High |
| Risky sign-in | Impossible travel | High |
| Admin activity from new location | New admin IP | High |

#### Custom Activity Policy

```json
{
  "policyName": "Mass Delete Detection",
  "description": "Detect bulk file deletion",
  "filters": {
    "activityType": "Delete",
    "app": ["All apps"],
    "singleUser": {
      "threshold": 100,
      "timeWindow": "1 hour"
    }
  },
  "severity": "High",
  "governance": {
    "suspendUser": false,
    "alertOwner": true,
    "notifyAdmin": true
  }
}
```

### 6. File Policies

#### File Policy Types

| Policy | Purpose | Action |
|--------|---------|--------|
| DLP Inspection | Detect sensitive data | Alert, quarantine |
| External Sharing | Detect public shares | Remove access |
| Stale External Share | Old shared files | Remove access |
| Malware Detection | Detect malicious files | Quarantine |

#### File Policy Configuration

```json
{
  "policyName": "Credit Card Detection",
  "filters": {
    "app": ["Microsoft 365", "Box", "Dropbox"],
    "fileType": ["Document", "Spreadsheet"],
    "sharing": "External"
  },
  "contentInspection": {
    "enabled": true,
    "inspectionType": "DLP",
    "dataTypes": ["Credit Card Number", "SSN"]
  },
  "governance": {
    "action": "Quarantine",
    "notifyOwner": true,
    "removeSharing": true
  }
}
```

### 7. OAuth App Governance

#### App Governance Settings

| Setting | Value | Purpose |
|---------|-------|---------|
| Monitor OAuth apps | Enabled | Track app permissions |
| High privilege alerts | Enabled | Alert on sensitive permissions |
| Unused app alerts | 90 days | Clean up stale apps |

#### OAuth App Policy

```json
{
  "policyName": "Block Risky OAuth Apps",
  "filters": {
    "permissions": ["Mail.Read", "Files.Read.All"],
    "publisher": "Unknown",
    "communityUse": "Rare"
  },
  "action": "Ban",
  "alert": true
}
```

### 8. Information Protection Integration

#### Sensitivity Labels

| Label | Auto-apply | Action |
|-------|------------|--------|
| Public | No | None |
| Internal | Content match | Monitor |
| Confidential | Content match | Block external |
| Highly Confidential | Content match | Block + alert |

#### Integration Configuration

```
Settings > Information Protection:
1. Enable Azure Information Protection integration
2. Enable automatic labeling
3. Configure scan behavior
4. Set governance actions
```

### 9. Threat Detection Configuration

#### Anomaly Detection Policies

| Policy | Learning Period | Sensitivity |
|--------|-----------------|-------------|
| Impossible travel | 7 days | Medium |
| Activity from infrequent country | 7 days | Medium |
| Unusual file activities | 7 days | Medium |
| Multiple failed logins | Immediate | High |
| Ransomware activity | Immediate | High |

#### Tuning Anomaly Detection

| Setting | Adjustment | Effect |
|---------|------------|--------|
| Sensitivity | Lower | Fewer alerts, less false positives |
| Scope | Specific users | Focus on high-risk users |
| Learning | Extended | More accurate baseline |

## Operational Procedures

### Daily Operations

1. Review high-severity alerts
2. Check app connector health
3. Process governance actions
4. Review new discovered apps

### Weekly Operations

1. Analyze discovery reports
2. Review OAuth app activity
3. Check policy match rates
4. Update app tags and sanctions

### Monthly Operations

1. Review and update policies
2. Analyze trend reports
3. Update sanctioned/unsanctioned apps
4. Review user access patterns

## Troubleshooting

### Common Issues

| Issue | Cause | Resolution |
|-------|-------|------------|
| App not appearing | Connector issue | Reconnect app connector |
| Missing activities | API limitations | Check connector status |
| Session control not working | CA policy issue | Verify Conditional Access |
| Discovery gaps | Log collector issue | Check collector health |

### Diagnostic Commands

```powershell
# Check log collector status (on collector)
docker logs log-collector

# Test connectivity
Test-NetConnection -ComputerName "portal.cloudappsecurity.com" -Port 443

# API health check
Invoke-RestMethod -Uri "https://<tenant>.cloudappsecurity.com/api/v1/status"
```

### Log Locations

| Component | Log Location |
|-----------|--------------|
| Log Collector | Docker logs |
| Activity Logs | MDCA portal > Activity log |
| Governance Log | MDCA portal > Governance log |
| Alerts | MDCA portal > Alerts |

## Anomaly Detection Policy

### Category: Threat Detection

Built-in anomaly detection policies monitor for:

| Category | Detection Types |
|----------|----------------|
| Risky IP address | Known malicious or suspicious IPs |
| Login failures | Multiple failed authentication attempts |
| Admin activity | Unusual administrative actions |
| Inactive accounts | Activity from dormant accounts |
| Location | Unusual geographic locations |
| Impossible travel | Physically impossible travel patterns |
| Device and user agent | New or suspicious devices |
| Activity rate | Unusual activity volumes |

### Entra ID Identity Protection Integration

In addition to native Defender for Cloud Apps alerts, these detections are received from Entra ID Identity Protection:

| Detection | Description | Requirement |
|-----------|-------------|-------------|
| Leaked credentials | User's valid credentials have been leaked | Requires Password Hash Sync (PHS) |
| Risky sign-in | Combines multiple Entra ID Identity Protection sign-in detections | Entra ID P2 |

## Advanced Hunting KQL Queries

### Sharing Activities

```kusto
// List of sharing activities in cloud apps
CloudAppEvents
| where ActivityType == "Share"
| take 100
```

### Guest Account Monitoring

```kusto
// Search for new guest accounts promoted to Entra ID Roles
let Roles = pack_array("Company Administrator");
let newGuestAccounts = (
CloudAppEvents
| where Timestamp > ago(30d)
| where ActionType == "Add user."
| where RawEventData.ResultStatus == "Success"
| where RawEventData has "guest" and RawEventData.ObjectId has "#EXT#"
| mv-expand Property = RawEventData.ModifiedProperties
| where Property.Name == "AccountEnabled" and Property.NewValue has "true"
| project CreationTimestamp = Timestamp, AccountObjectId, AccountDisplayName, newGuestAccount = RawEventData.ObjectId, newGuestAccountObjectId = tostring(RawEventData.Target[1].ID), UserAgent);
let promotedAccounts = (
CloudAppEvents
| where Timestamp > ago(7d)
| where isnotempty(AccountObjectId)
| where ActionType == "Add member to role."
| where RawEventData.ResultStatus == "Success"
| where RawEventData has_any(Roles)
| where RawEventData.Actor has "User"
| project PromoteTimestamp = Timestamp, PromotedUserAccountObjectId = tostring(RawEventData.Target[1].ID));
newGuestAccounts
| join promotedAccounts on $left.newGuestAccountObjectId == $right.PromotedUserAccountObjectId
| where PromoteTimestamp > CreationTimestamp
| project CreationTimestamp, PromoteTimestamp, PromotedUserAccountObjectId, newGuestAccount, newGuestAccountObjectId
```

### Shadow IT Reporting

```kusto
// Shadow IT analysis from Defender-managed endpoints
McasShadowItReporting
| where TimeGenerated > ago(90d)
| where StreamName == "Defender-managed endpoints"
| summarize Totalbytes = sum(TotalBytes), UploadBytes = sum(UploadedBytes), DownloadBytes = sum(DownloadedBytes), Users = make_set(EnrichedUserName), Devices = make_set(MachineName), IPAddresses = make_set(IpAddress) by AppName, AppScore
| extend TotalDevices = array_length(Devices)
| extend TotalIPAddresses = array_length(IPAddresses)
| extend Totalusers = array_length(Users)
| extend UploadMB = format_bytes(UploadBytes,0,"MB")
| extend TotalTraffic = format_bytes(Totalbytes,0,"MB")
| extend DownloadMB = format_bytes(DownloadBytes,0,"MB")
| project AppName, AppScore, TotalDevices, TotalIPAddresses, Totalusers, TotalTraffic, UploadMB, DownloadMB, IPAddresses, Devices, Users
```

### MFA Monitoring

```kusto
// Suspicious MFA reset operations
let relevantActionTypes = pack_array("Disable Strong Authentication.", "system.mfa.factor.deactivate", "user.mfa.factor.update", "user.mfa.factor.reset_all", "core.user_auth.mfa_bypass_attempted");
CloudAppEvents
| where Timestamp > ago(1d)
| where isnotempty(AccountObjectId)
| where Application in ("Office 365", "Okta")
| where ActionType in (relevantActionTypes)
| where RawEventData contains "success"
| project Timestamp, ReportId, AccountObjectId, IPAddress, ActionType

// Suspicious MFA tampering - altering authentication levels
CloudAppEvents
| where Timestamp > ago(1d)
| where ApplicationId == 11161
| where ActionType == "Update user."
| where isnotempty(AccountObjectId)
| where RawEventData has_all("StrongAuthenticationRequirement", "[]")
| mv-expand ModifiedProperties = RawEventData.ModifiedProperties
| where ModifiedProperties.Name == "StrongAuthenticationRequirement" and ModifiedProperties.OldValue != "[]" and ModifiedProperties.NewValue == "[]"
| mv-expand ActivityObject = ActivityObjects
| where ActivityObject.Role == "Target object"
| extend TargetObjectId = tostring(ActivityObject.Id)
| project Timestamp, ReportId, AccountObjectId, ActivityObjects, TargetObjectId
```

### File Sharing Analysis

```kusto
// SharePoint/OneDrive - file shared with multiple participants
let securelinkCreated = CloudAppEvents
| where ActionType == "SecureLinkCreated"
| project FileCreatedTime = Timestamp, AccountObjectId, ObjectName;
let filesCreated = securelinkCreated
| where isnotempty(ObjectName)
| distinct tostring(ObjectName);
CloudAppEvents
| where ActionType == "AddedToSecureLink"
| where Application in ("Microsoft SharePoint Online", "Microsoft OneDrive for Business")
| extend FileShared = tostring(RawEventData.ObjectId)
| where FileShared in (filesCreated)
| extend UserSharedWith = tostring(RawEventData.TargetUserOrGroupName)
| extend TypeofUserSharedWith = RawEventData.TargetUserOrGroupType
| where TypeofUserSharedWith == "Guest"
| where isnotempty(FileShared) and isnotempty(UserSharedWith)
| join kind=inner securelinkCreated on $left.FileShared==$right.ObjectName
| where (Timestamp - FileCreatedTime) between (1d .. 0h)
| summarize NumofUsersSharedWith = dcount(UserSharedWith) by FileShared
| where NumofUsersSharedWith >= 20
```

## Related Documentation

- [Overview](01-Overview.md)
- [High-Level Design](02-High-Level-Design.md)
- [Capabilities](04-Capabilities.md)
- [Cloud App Security Process](../Processes/Cloud-App-Security.md)

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | YYYY-MM-DD | [Author] | Initial creation |

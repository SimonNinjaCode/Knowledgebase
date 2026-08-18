# Microsoft Defender for Office 365 - Low-Level Design

## Document Information

| Item | Details |
|------|---------|
| **Product** | Microsoft Defender for Office 365 |
| **Document Type** | Low-Level Design |
| **Last Updated** | YYYY-MM-DD |
| **Author** | [Author Name] |
| **Version** | 1.0 |

---

## Purpose

This document provides detailed technical specifications, configurations, and implementation guidance for Microsoft Defender for Office 365.

## Prerequisites

### Licensing

- [ ] Microsoft Defender for Office 365 Plan 1 or Plan 2 licenses
- [ ] Exchange Online licenses for protected users
- [ ] Licenses assigned to target users

### Technical Requirements

| Requirement | Specification |
|-------------|---------------|
| Exchange Online | Required for email protection |
| MX Records | Point to Microsoft 365 (recommended) |
| SPF/DKIM/DMARC | Configured for sending domain |
| Connectors | Configured if using third-party gateway |

## Configuration Specifications

### 1. Preset Security Policies

#### Policy Levels

| Policy Level | Target Users | Protection Level |
|--------------|--------------|------------------|
| Standard | Most users | Balanced protection |
| Strict | Executives, high-risk users | Maximum protection |
| Built-in | All users | Baseline protection |

#### Standard vs Strict Comparison

| Setting | Standard | Strict |
|---------|----------|--------|
| Safe Attachments | Dynamic Delivery | Block |
| Safe Links | Track clicks | Block untrusted URLs |
| Anti-phishing | Medium sensitivity | High sensitivity |
| Impersonation | Protected domains | All domains |

### 2. Safe Attachments Configuration

#### Policy Settings

| Setting | Standard Value | Strict Value | Purpose |
|---------|----------------|--------------|---------|
| Action | Dynamic Delivery | Block | Handle malicious files |
| Redirect | Enabled | Enabled | Send to security team |
| Redirect Address | security@contoso.com | security@contoso.com | Review mailbox |
| Apply to Unknown | Enabled | Enabled | Scan unknown attachments |
| Monitor Action | Report only | Report only | For monitoring mode |

#### Safe Attachments Policy (PowerShell)

```powershell
# Create Safe Attachments Policy
New-SafeAttachmentPolicy -Name "Standard Protection" `
    -Enable $true `
    -Action DynamicDelivery `
    -Redirect $true `
    -RedirectAddress "security@contoso.com" `
    -ActionOnError $true

# Create Safe Attachments Rule
New-SafeAttachmentRule -Name "Standard Protection Rule" `
    -SafeAttachmentPolicy "Standard Protection" `
    -RecipientDomainIs "contoso.com" `
    -Enabled $true
```

#### SharePoint, OneDrive, and Teams

| Setting | Value | Purpose |
|---------|-------|---------|
| Turn on Safe Attachments | Enabled | Protect file sharing |
| Turn on Safe Documents | Enabled | Office document protection |
| Allow clicking through | Disabled | Enforce protection |

### 3. Safe Links Configuration

#### Policy Settings

| Setting | Standard Value | Strict Value |
|---------|----------------|--------------|
| On: Safe Links checks URLs | Enabled | Enabled |
| Apply to messages within org | Enabled | Enabled |
| Apply real-time URL scanning | Enabled | Enabled |
| Wait for URL scanning | Enabled | Enabled |
| Do not rewrite URLs | Disabled | Disabled |
| Track user clicks | Enabled | Enabled |
| Let users click through | Enabled | Disabled |
| Display branding | Enabled | Enabled |

#### Safe Links Policy (PowerShell)

```powershell
# Create Safe Links Policy
New-SafeLinksPolicy -Name "Standard Protection" `
    -EnableSafeLinksForEmail $true `
    -EnableSafeLinksForTeams $true `
    -EnableSafeLinksForOffice $true `
    -TrackUserClicks $true `
    -AllowClickThrough $false `
    -ScanUrls $true `
    -EnableForInternalSenders $true `
    -DeliverMessageAfterScan $true `
    -DisableUrlRewrite $false

# Create Safe Links Rule
New-SafeLinksRule -Name "Standard Protection Rule" `
    -SafeLinksPolicy "Standard Protection" `
    -RecipientDomainIs "contoso.com" `
    -Enabled $true
```

#### URL Block/Allow Lists

| List Type | Purpose | Management |
|-----------|---------|------------|
| Tenant Allow/Block List | Allow/block specific URLs | Portal or PowerShell |
| Do Not Rewrite | Skip rewriting for trusted URLs | Policy configuration |

### 4. Anti-Phishing Configuration

#### Impersonation Protection

| Setting | Standard | Strict |
|---------|----------|--------|
| Enable users to protect | 10 users | 10 users |
| Enable domains to protect | Enabled | Enabled |
| Include owned domains | Enabled | Enabled |
| Include custom domains | As needed | As needed |
| Trusted senders | Minimal | None |
| Trusted domains | Minimal | None |

#### Action Settings

| Detection Type | Standard Action | Strict Action |
|----------------|-----------------|---------------|
| User impersonation | Quarantine | Quarantine |
| Domain impersonation | Quarantine | Quarantine |
| Mailbox intelligence | Move to Junk | Quarantine |
| Spoof | Move to Junk | Quarantine |

#### Anti-Phishing Policy (PowerShell)

```powershell
# Create Anti-Phishing Policy
New-AntiPhishPolicy -Name "Executive Protection" `
    -EnableTargetedUserProtection $true `
    -TargetedUsersToProtect "CEO;ceo@contoso.com","CFO;cfo@contoso.com" `
    -EnableTargetedDomainsProtection $true `
    -TargetedDomainProtectionAction Quarantine `
    -EnableMailboxIntelligence $true `
    -EnableMailboxIntelligenceProtection $true `
    -MailboxIntelligenceProtectionAction Quarantine `
    -EnableSpoofIntelligence $true `
    -SpoofQuarantineTag DefaultFullAccessPolicy `
    -PhishThresholdLevel 3

# Create Anti-Phishing Rule
New-AntiPhishRule -Name "Executive Protection Rule" `
    -AntiPhishPolicy "Executive Protection" `
    -RecipientDomainIs "contoso.com" `
    -SentTo "ceo@contoso.com","cfo@contoso.com" `
    -Enabled $true
```

### 5. Quarantine Configuration

#### Quarantine Policies

| Policy | User Access | Admin Notifications |
|--------|-------------|---------------------|
| Admin Only | No user access | Enabled |
| Limited Access | View, request release | Enabled |
| Full Access | View, release, delete | Enabled |

#### Quarantine Settings

```powershell
# Create Custom Quarantine Policy
New-QuarantinePolicy -Name "Standard User Quarantine" `
    -EndUserQuarantinePermissionsValue 27 `
    -ESNEnabled $true

# Permission Values:
# PermissionToBlockSender: 1
# PermissionToDelete: 2
# PermissionToPreview: 4
# PermissionToRelease: 8
# PermissionToRequestRelease: 16
```

### 6. Threat Intelligence Settings

#### Tenant Allow/Block List

| Entry Type | Purpose | Duration |
|------------|---------|----------|
| Block Entry | Block specific IOCs | 90 days max |
| Allow Entry | Allow false positives | 30 days max |
| Spoof Entry | Override spoof verdict | Indefinite |

#### Submission Configuration

| Setting | Value | Purpose |
|---------|-------|---------|
| User reported | Enabled | User phish reporting |
| Report destination | Junk folder + Microsoft | Both analysis |
| Result email | Enabled | Feedback to users |

### 7. Attack Simulation Training (Plan 2)

#### Simulation Configuration

| Setting | Recommended Value |
|---------|-------------------|
| Payload types | Credential Harvest, Malware, Link |
| Target users | All users, rotating groups |
| Frequency | Monthly |
| Training assignment | Automatic for failures |

#### Training Modules

| Module Type | Target Audience | Duration |
|-------------|-----------------|----------|
| Phishing Awareness | All users | 15 minutes |
| Social Engineering | All users | 20 minutes |
| Safe Browsing | All users | 10 minutes |
| Data Protection | Executives | 15 minutes |

### 8. Automated Investigation Configuration (Plan 2)

#### Investigation Settings

| Setting | Value |
|---------|-------|
| Auto-investigation | Enabled |
| Pending actions | Require approval for delete |
| Email soft delete | Auto-approve |
| Email hard delete | Require approval |

### 9. Alert Policies

#### Custom Alert Configuration

| Alert | Condition | Severity | Notification |
|-------|-----------|----------|--------------|
| Phishing Campaign | >10 phishing emails in 1 hour | High | Security team |
| Malware Detected | Any malware detection | Medium | Security team |
| User Compromised | Impossible travel + suspicious forwarding | High | Security team |

## Operational Procedures

### Daily Operations

1. Review quarantine for false positives
2. Check email threat reports
3. Process user-reported messages
4. Review Safe Attachments verdicts

### Weekly Operations

1. Analyze Threat Explorer data
2. Review blocked senders/URLs
3. Check protection policy status
4. Review attack simulation results

### Monthly Operations

1. Review and update impersonation protection
2. Analyze email security trends
3. Update training assignments
4. Review quarantine policies

## Troubleshooting

### Common Issues

| Issue | Cause | Resolution |
|-------|-------|------------|
| Emails delayed | Safe Attachments scanning | Use Dynamic Delivery |
| False positives | Overly strict policies | Add to Tenant Allow List |
| Phishing bypassing | Policy gaps | Review anti-phishing settings |
| Safe Links not working | URL not rewritten | Check excluded URLs |

### Diagnostic Commands

```powershell
# Check Safe Attachments status
Get-SafeAttachmentPolicy | Format-List

# Check Safe Links status
Get-SafeLinksPolicy | Format-List

# Check Anti-Phishing status
Get-AntiPhishPolicy | Format-List

# Get message trace
Get-MessageTrace -RecipientAddress "user@contoso.com" -StartDate (Get-Date).AddDays(-7)

# Check quarantine
Get-QuarantineMessage -Type Phish
```

### Log Analysis

| Log Source | Access Method |
|------------|---------------|
| Email trace | Message trace in portal |
| Threat Explorer | security.microsoft.com |
| Audit logs | Unified audit log |
| Alert history | Alert center |

## Configuration Analyzer

The Configuration Analyzer is a powerful tool for analyzing and improving your email protection policies.

### Role Based Access Controls

| Function | Required Roles |
|----------|---------------|
| Use the analyzer, configure and update policies | Organization Management or Security Administrator |
| Read-only access | Global Reader or Security Reader |

### Policies Analyzed

**Exchange Online Protection (EOP) policies:**
- [Anti-spam policies](https://docs.microsoft.com/en-gb/microsoft-365/security/office-365-security/configure-your-spam-filter-policies)
- [Anti-malware policies](https://docs.microsoft.com/en-gb/microsoft-365/security/office-365-security/configure-anti-malware-policies)
- [EOP anti-phishing policies](https://docs.microsoft.com/en-gb/microsoft-365/security/office-365-security/set-up-anti-phishing-policies#spoof-settings)

**Microsoft Defender for Office 365 policies:**
- [Spoof settings](https://docs.microsoft.com/en-gb/microsoft-365/security/office-365-security/set-up-anti-phishing-policies#spoof-settings)
- [Impersonation settings](https://docs.microsoft.com/en-gb/microsoft-365/security/office-365-security/set-up-anti-phishing-policies#impersonation-settings-in-anti-phishing-policies-in-microsoft-defender-for-office-365)
- [Advanced phishing thresholds](https://docs.microsoft.com/en-gb/microsoft-365/security/office-365-security/set-up-anti-phishing-policies#advanced-phishing-thresholds-in-anti-phishing-policies-in-microsoft-defender-for-office-365)
- [Safe Links policies](https://docs.microsoft.com/en-gb/microsoft-365/security/office-365-security/set-up-safe-links-policies)
- [Safe Attachments policies](https://docs.microsoft.com/en-gb/microsoft-365/security/office-365-security/set-up-safe-attachments-policies)

## Attack Simulator Training

To increase security culture and awareness, education is paramount. Attack simulation training tests and educates users with realistic attack simulations.

### Available Social Engineering Techniques

| Technique | Description |
|-----------|-------------|
| Credential Harvest | Simulated credential theft attempts |
| Malware Attachment | Test user response to malicious attachments |
| Link in Attachment | Hidden malicious links in documents |
| Link to Malware | Direct malware download links |
| Drive-by-url | Simulated drive-by download attacks |
| OAuth Consent Grant | Test OAuth permission requests |

### Available Training Modules

The following are example training modules available (89 modules covering 37 languages):
- Introduction to Information Security
- Business Email Compromise
- Identity Theft
- Malware
- Phishing
- Ransomware
- Social Engineering
- Smishing
- C-Level Impersonation
- Spear Phishing (CEO Fraud)
- Data Leakage
- Insider Threat

### Simulation Features

- Default or customizable end user notifications
- Customizable login pages
- Customizable phish landing pages
- Reporting on simulations completed, training completed, and behavioral impact

## Advanced Hunting KQL Queries

### Email Attachments

```kusto
// QR code phishing with adversary-in-the-middle capability
EmailAttachmentInfo
| where Timestamp > ago(30d)
| where FileType contains "png"
| where FileName matches regex "^[A-Z0-9]{9,10}\\.[A-Za-z0-9]+$"
| where SenderFromAddress !contains "yourdomain.com" // Exclude your corporate domain
| where RecipientObjectId != ""
| join EmailEvents on NetworkMessageId
| where DeliveryAction != "Blocked"
| where DeliveryAction != "Junked"

// Hunt for all inbound emails with HTML attachments and compile list of URLs
let HTMLfile = (EmailAttachmentInfo
| where FileType =~ "html");
let HTMLurl = (EmailUrlInfo
| where UrlLocation == "Attachment"
| summarize HTMLfile_URL_list = make_list(Url) by NetworkMessageId);
let Emailurl = (EmailUrlInfo
| where UrlLocation == "Body"
| summarize Email_URL_list = make_list(Url) by NetworkMessageId);
EmailEvents
| where EmailDirection == "Inbound"
| join kind = inner HTMLfile on NetworkMessageId
| join kind = inner HTMLurl on NetworkMessageId
| join kind = leftouter Emailurl on NetworkMessageId
| project Timestamp, ReportId, NetworkMessageId, SenderFromAddress, RecipientEmailAddress, FileName, FileType, ThreatTypes, ThreatNames, HTMLfile_URL_list, Email_URL_list

// Hunt all emails with ZIP attachments from specific TLDs
EmailAttachmentInfo
| where Timestamp > ago(4h)
| where FileType == "zip"
| where SenderFromAddress has_any (".br", ".ru", ".jp")

// Hunt for emails containing zip files based on name "invoice"
EmailAttachmentInfo
| where Timestamp > ago(8h)
| where FileType == "zip"
| where FileName contains "invoice"
| distinct SHA256, FileName
```

### Suspicious Emails & Clicked URLs

```kusto
// Users who received suspicious emails and clicked on URLs
let UserClickedLink = (UrlClickEvents
| where Workload == "Email"
| where ActionType == "ClickAllowed" or IsClickedThrough != "0");
EmailEvents
| where EmailDirection == "Inbound"
| where ThreatTypes has_any ("Phish", "Malware")
| join kind = inner UserClickedLink on NetworkMessageId
| project Timestamp, ReportId, NetworkMessageId, SenderFromAddress, RecipientEmailAddress, ActionType, IsClickedThrough, Url

// Users who clicked suspicious URLs including MDE-onboarded devices
let ClickedURL = EmailEvents
| where EmailDirection == "Inbound"
| where ThreatTypes has_any ("Phish", "Malware")
| join (UrlClickEvents
| where Workload == "Email"
| where ActionType == "ClickAllowed" or IsClickedThrough != "0") on NetworkMessageId
| project Timestamp, AccountUpn, Url, UrlChain, UrlCount, DeliveryAction;
DeviceEvents
| where ActionType == "BrowserLaunchedToOpenUrl"
| where InitiatingProcessFileName =~ "outlook.exe"
| join kind = inner ClickedURL on $left.RemoteUrl == $right.Url
| project Timestamp, DeviceId, DeviceName, AccountUpn, Url, UrlChain, UrlCount

// Hunt for malicious URLs to add as indicators in MDE
EmailUrlInfo
| where Timestamp > ago(4h)
| where Url contains "malicious.example"
| distinct Url
```

### Advanced Hunting Schema

| Table | Description |
|-------|-------------|
| EmailEvents | General information about email processing events |
| EmailAttachmentInfo | Information about email attachments |
| EmailUrlInfo | Information about URLs on emails and attachments |
| EmailPostDeliveryEvents | Information about post-delivery actions on emails |
| UrlClickEvents | Information about Safe Links clicks from email messages |

## Related Documentation

- [Overview](01-Overview.md)
- [High-Level Design](02-High-Level-Design.md)
- [Capabilities](04-Capabilities.md)
- [Phishing Response Process](../Processes/Phishing-Response.md)

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | YYYY-MM-DD | [Author] | Initial creation |

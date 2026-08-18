# Microsoft Defender for Identity - Low-Level Design

## Document Information

| Item | Details |
|------|---------|
| **Product** | Microsoft Defender for Identity |
| **Document Type** | Low-Level Design |
| **Last Updated** | YYYY-MM-DD |
| **Author** | [Author Name] |
| **Version** | 1.0 |

---

## Purpose

This document provides detailed technical specifications, configurations, and implementation guidance for Microsoft Defender for Identity.

## Prerequisites

### Licensing

- [ ] Microsoft Defender for Identity or equivalent licenses assigned
- [ ] License capacity sufficient for all monitored users

### System Requirements

#### Domain Controller Requirements

| Requirement | Specification |
|-------------|---------------|
| Operating System | Windows Server 2012 R2+ |
| .NET Framework | 4.7 or later |
| RAM (Sensor) | Minimum 6 GB |
| Disk Space | 10 GB minimum |
| CPU | 2 cores minimum |

#### Sensor Sizing

| Domain Traffic | RAM | CPU |
|---------------|-----|-----|
| Light (< 10K events/sec) | 6 GB | 2 cores |
| Medium (10K-40K events/sec) | 8 GB | 4 cores |
| Heavy (> 40K events/sec) | 12 GB+ | 6 cores |

### Network Requirements

| Destination | Port | Purpose |
|-------------|------|---------|
| `<instancename>sensorapi.atp.azure.com` | 443 | Sensor to cloud |
| `*.blob.core.windows.net` | 443 | Updates and storage |
| `crl.microsoft.com` | 80/443 | Certificate validation |
| `ctldl.windowsupdate.com` | 80/443 | Windows Update |
| `www.microsoft.com/pkiops/*` | 443 | PKI operations |
| `www.microsoft.com/pki/*` | 443 | PKI |
| Domain Controllers | 389, 636 | LDAP |
| Domain Controllers | 88 | Kerberos |

## Configuration Specifications

### 1. Instance Configuration

#### Create Defender for Identity Instance

```
Portal: security.microsoft.com > Settings > Identities
Instance URL: [tenant].atp.azure.com
```

#### Instance Settings

| Setting | Recommended Value |
|---------|-------------------|
| Instance Name | Primary |
| Sensor Updates | Automatic (Delayed) |
| Alert Notifications | Enabled |

### 2. Directory Services Account

#### Option A: Group Managed Service Account (Recommended)

```powershell
# Create gMSA for MDI
Add-KdsRootKey -EffectiveTime ((Get-Date).AddHours(-10))

New-ADServiceAccount -Name "gMSA-MDI" `
    -DNSHostName "gMSA-MDI.contoso.com" `
    -PrincipalsAllowedToRetrieveManagedPassword "Domain Controllers"

# Install on each DC
Install-ADServiceAccount -Identity "gMSA-MDI"
```

#### Option B: Standard Service Account

| Setting | Value |
|---------|-------|
| Account Type | Domain User |
| Password Policy | Never expires, complex password |
| Permissions | Read-only access to AD |

#### Required Permissions

| Permission | Scope | Purpose |
|------------|-------|---------|
| Read All Properties | Domain object | User profiling |
| Read Directory Changes | Domain object | Monitoring changes |
| Replicate Directory Changes | Domain object | Deleted objects tracking |

### 3. Sensor Deployment

#### High-Level Installation Steps

1. Install Sensors (Domain Controllers, PKI Server, Entra Connect, ADFS)
2. Create and Configure gMSA accounts (Managed DSA and Action Account)
3. Configure MDI and create GPOs using PowerShell Module
4. Verify Configuration using reporting in PowerShell Module

#### Sensor Installation Location

Navigate to: **Defender XDR > Settings > Identities** (https://security.microsoft.com/settings/identities)

Steps:
- Verify Network Connectivity
- Add Sensor
- Directory services accounts
- Manage action accounts

#### PowerShell Module Configuration

```powershell
# Install the DefenderForIdentity module
Install-Module DefenderForIdentity

# Import the module
Import-Module DefenderForIdentity

# Get help information
Get-Help -Name Test-MDIDSA-Full

# Test the configuration for all settings in Domain mode
Test-MDIConfiguration -Mode Domain -Configuration All

# Set the configuration for all settings in Domain mode
Set-MDIConfiguration -Mode Domain -Configuration All

# Get configuration for all settings in LocalMachine mode
Get-MDIConfiguration -Mode LocalMachine -Configuration All

# Generate configuration report
New-MDIConfigurationReport -Path C:\Temp -OpenHtmlReport
```

#### GPO Files Created

The PowerShell module creates the following policy files:
- Microsoft Defender for Identity - Advanced Audit Policy for CAs
- Microsoft Defender for Identity - Advanced Audit Policy for DCs
- Microsoft Defender for Identity - Auditing for CAs
- Microsoft Defender for Identity - NTLM Auditing for DCs
- Microsoft Defender for Identity - Processor Performance

#### Sensor Installation (Command Line)

```cmd
# Silent installation
"Azure ATP sensor Setup.exe" /quiet NetFrameworkCommandLineArguments="/q" AccessKey="<ACCESS_KEY>"

# With proxy
"Azure ATP sensor Setup.exe" /quiet NetFrameworkCommandLineArguments="/q" AccessKey="<ACCESS_KEY>" ProxyUrl="http://proxy:8080"
```

#### Sensor Configuration

| Setting | Value | Location |
|---------|-------|----------|
| Access Key | From portal | Portal > Settings > Sensors |
| Proxy Settings | If required | Sensor configuration |
| Domain Connectivity | All DCs | Automatic |

### 4. Learning Period

MDI requires a learning period before certain detections become active:

| Detection | Learning Period (Days) |
|-----------|----------------------|
| Network mapping reconnaissance (DNS) | 8 days |
| Security principal reconnaissance (LDAP) | 15 days |
| User and group membership reconnaissance (SAMR) | 28 days |
| Suspected brute force attack | 7 days |
| Suspected Golden Ticket usage | 5 days |
| Suspicious additions to sensitive groups | 28 days (from first event) |
| Data exfiltration over SMB | 15 days |
| Suspicious VPN connection | 30 days (min 5 VPN connections in last 30 days per user) |

### 4. SIEM Notifications

#### Syslog Configuration

| Setting | Value |
|---------|-------|
| Server Address | siem.contoso.com |
| Port | 514 |
| Protocol | UDP/TCP/TLS |
| Format | CEF/RFC 5424 |

### 5. Detection Tuning

#### Excluded Entities

| Entity Type | Example | Reason |
|-------------|---------|--------|
| Users | SVC_Backup | Service account |
| Computers | SCCM-Server | Management server |
| IP Addresses | 10.0.0.50 | Vulnerability scanner |

#### Honeytoken Accounts

```
Purpose: Early warning for credential theft
Setup:
1. Create decoy user accounts
2. Add to Sensitive accounts in MDI
3. Monitor for any authentication attempts
```

### 6. Sensitive Accounts and Groups

#### Default Sensitive Groups

- Domain Admins
- Enterprise Admins
- Schema Admins
- Administrators
- Account Operators
- Backup Operators

#### Custom Sensitive Accounts

| Account Type | Example | Reason |
|--------------|---------|--------|
| Executive Accounts | CEO, CFO | High-value targets |
| IT Admin Accounts | admin_* | Privileged access |
| Service Accounts | SVC_Critical | Critical services |

### 7. Alert Tuning

#### Alert Severity Mapping

| MDI Severity | SIEM Priority | Response Time |
|--------------|---------------|---------------|
| High | Critical | Immediate |
| Medium | High | 4 hours |
| Low | Medium | 24 hours |

#### Common False Positive Tuning

| Alert | Exclusion Type | Example |
|-------|---------------|---------|
| Suspicious VPN | Source IP | VPN gateway IPs |
| Reconnaissance | Source Account | Vulnerability scanner |
| Unusual Protocol | Source Computer | Network management |

### 8. Remediation Actions

#### Automatic Actions

| Action | Configuration | Use Case |
|--------|---------------|----------|
| Disable User | Via Defender XDR | Confirmed compromise |
| Force Password Reset | Via Entra ID | Credential theft |
| Confirm User Compromised | Manual | Investigation result |

### 9. Health Monitoring

#### Health Alerts

| Alert | Cause | Resolution |
|-------|-------|------------|
| Sensor Unreachable | Network issue | Check connectivity |
| Sensor Outdated | Update failed | Manual update |
| Low Memory | Insufficient resources | Add RAM |
| Domain Sync Issue | DS account issue | Check permissions |

#### Monitoring Script

```powershell
# Check sensor service status
Get-Service -Name "Azure Advanced Threat Protection Sensor" -ComputerName $DCs

# Check sensor health via API
$Uri = "https://<instance>.atp.azure.com/api/sensors"
$Headers = @{ "Authorization" = "Bearer $Token" }
Invoke-RestMethod -Uri $Uri -Headers $Headers
```

## Operational Procedures

### Daily Operations

1. Review high-severity alerts
2. Check sensor health status
3. Review learning period progress
4. Update excluded entities as needed

### Weekly Operations

1. Review medium/low severity alerts
2. Analyze security assessment findings
3. Review lateral movement paths
4. Update honeytoken monitoring

### Monthly Operations

1. Review and update sensitive accounts
2. Audit exclusion lists
3. Review sensor performance
4. Update detection tuning

## Troubleshooting

### Common Issues

| Issue | Cause | Resolution |
|-------|-------|------------|
| Sensor not reporting | Network blocked | Check firewall rules |
| Missing detections | Learning period | Wait 30 days |
| High CPU usage | Traffic volume | Size up sensor |
| DS account issues | Password expired | Update credentials |

### Diagnostic Commands

```powershell
# Check sensor connectivity
Test-NetConnection -ComputerName "<instance>.atp.azure.com" -Port 443

# Check sensor service
Get-Service "Azure Advanced Threat Protection Sensor"

# View sensor logs
Get-EventLog -LogName Application -Source "Azure Advanced Threat Protection Sensor" -Newest 100
```

### Log Locations

| Log | Path |
|-----|------|
| Installation Logs | `C:\Users\%userprofile%\AppData\Local\Temp` |
| Sensor Logs | `C:\Program Files\Azure Advanced Threat Protection Sensor\<version>\Logs` |
| Updater Logs | `C:\Program Files\Azure Advanced Threat Protection Sensor\<version>\Logs\Updater` |
| Installation Log Files | `%temp%\Azure Advanced Threat Protection Sensor_*.log` |

#### Log File Descriptions

| Log File | Description |
|----------|-------------|
| Microsoft.Tri.Sensor.log | All logs related to the Defender for Identity sensor |
| Microsoft.Tri.Sensor-Errors.log | Contains just the errors caught by the Defender for Identity sensor |
| Microsoft.Tri.Sensor.Updater.log | Used for the sensor updater process |
| Microsoft.Tri.Sensor.Updater-Errors.log | Contains errors caught by the sensor updater |

#### Sensor Service Information

Display names: "Azure Advanced Threat Protection Sensor" & "Azure Advanced Threat Protection Sensor Updater"

Executables location: `C:\Program Files\Azure Advanced Threat Protection Sensor\`

## Security Testing

These commands can be executed on a domain-joined endpoint or server to generate alerts for Defender for Identity. Use these for testing purposes to validate functionality.

### Network Mapping Reconnaissance (DNS)

```cmd
Nslookup
server DC-FQDN
ls -d DC-FQDN
```

### User and Group Membership Reconnaissance (SAMR)

```cmd
net user /domain
net group /domain
net group "Domain Admins" /domain
net group "Enterprise Admins" /domain
net group "Schema Admins" /domain
```

## Advanced Hunting KQL Queries

### Verify Data Ingestion

```kusto
// Verify Advanced Hunting - Defender for Identity
IdentityDirectoryEvents
| where TargetDeviceName contains "Domain_Controller_FQDN"

IdentityInfo
| where AccountDomain contains "DOMAIN"

IdentityQueryEvents
| where DeviceName contains "Domain_Controller_FQDN"
```

### User Account Queries

```kusto
// Find disabled user accounts
IdentityInfo
| where IsAccountEnabled == "0"
| summarize arg_max(AccountName,*) by AccountUpn

// Alert when account is set to 'password never expires'
IdentityDirectoryEvents
| where ActionType == "Account Password Never Expires changed"
| extend ['Password never expires previous setting'] = tostring(AdditionalFields.["FROM Account Password Never Expires"])
| extend ['Password never expires current setting'] = tostring(AdditionalFields.["TO Account Password Never Expires"])
| project Timestamp, TargetAccountUpn, ['Password never expires current setting'], ['Password never expires previous setting']
```

### Service Account Monitoring

```kusto
// Count authentication requests per day for service accounts
let timeframe = 30d;
let srvc_list = dynamic(["svc_account1@contoso.com","svc_account6@contoso.com"]);
IdentityLogonEvents
| where Timestamp >= ago(timeframe)
| where AccountUpn in~ (srvc_list)
| summarize Count = count() by bin(Timestamp, 24h), AccountName, DeviceName
| sort by Timestamp desc

// Service Accounts in Domain Admins
let timeframe = 30d;
let srvc_list = dynamic(["svc_account1@contoso.com","svc_account2@contoso.com","svc_account3@contoso.com"]);
IdentityLogonEvents
| where Timestamp >= ago(timeframe)
| where AccountUpn in~ (srvc_list)
| summarize Count = count() by AccountName, DeviceName, Protocol
```

### Service Creation Tracking

```kusto
// Track service creation activities on domain controllers
IdentityDirectoryEvents
| where ActionType == "Service creation"
| extend ServiceName = AdditionalFields["ServiceName"]
| extend ServiceCommand = AdditionalFields["ServiceCommand"]
| project Timestamp, ActionType, Protocol, DC = TargetDeviceName, ServiceName, ServiceCommand, AccountDisplayName, AccountSid, AdditionalFields
| limit 100
```

## Integration Specifications

### Defender XDR Integration

```
Configuration:
1. Enabled by default when MDI is configured
2. Alerts flow automatically to unified incident queue
3. User entities are correlated across products
```

### Microsoft Sentinel Integration

```
Connector: Microsoft 365 Defender
Data Types:
- IdentityInfo
- IdentityLogonEvents
- IdentityQueryEvents
- IdentityDirectoryEvents
```

### SIEM Integration

| Method | Configuration |
|--------|---------------|
| Syslog | Configure in MDI settings |
| API | Use Microsoft Graph Security API |
| Event Hub | Configure in Defender XDR |

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

# Midnight Blizzard

## Threat Overview

* **Spear-Phishing Campaign**: Since October 22, 2024, Russian threat actor Midnight Blizzard has been sending targeted spear-phishing emails to various sectors, including government and academia.
 
* **Novel Access Vector**: The campaign uses a signed Remote Desktop Protocol (RDP) configuration file to gain access to targets' devices, a new method for this actor.
 
* **Targets and Techniques**: Midnight Blizzard primarily targets entities in the US and Europe, using diverse methods like spear phishing, stolen credentials, and supply chain attacks.
 
* **Mitigation and Detection**: Microsoft provides indicators of compromise (IOCs), hunting queries, and recommendations to help mitigate this threat.
 
## Detection Queries

### Potential RDP Attachment Phishing Attempts
```kusto
EmailAttachmentInfo
| where FileName has ".rdp"
| join kind=inner (EmailEvents) on NetworkMessageId
| project SenderFromAddress, RecipientEmailAddress, Subject, Timestamp, FileName, FileType
```

### Correlation Between RDP Email Attachments and Outbound RDP Connections
```kusto
// Step 1: Identify emails with RDP attachments
let rdpEmails = EmailAttachmentInfo
| where FileName has ".rdp"
| join kind=inner (EmailEvents) on NetworkMessageId
| project EmailTimestamp = Timestamp, RecipientEmailAddress, NetworkMessageId, SenderFromAddress;
// Step 2: Identify outbound RDP connections
let outboundRDPConnections = DeviceNetworkEvents
| where RemotePort == 3389
| where ActionType == "ConnectionAttempt"
| where RemoteIPType == "Public"
| project RDPConnectionTimestamp = Timestamp, DeviceId, InitiatingProcessAccountUpn, RemoteIP;
// Step 3: Correlate email and network events
rdpEmails
| join kind=inner (outboundRDPConnections) on $left.RecipientEmailAddress == $right.InitiatingProcessAccountUpn
| project EmailTimestamp, RecipientEmailAddress, SenderFromAddress, RDPConnectionTimestamp, DeviceId, RemoteIP
```

### Microsoft Threat Intelligence RDP Connection Files
```kusto
EmailAttachmentInfo
| where FileName in~ (
    "AWS IAM Compliance Check.rdp",
    "AWS IAM Configuration.rdp",
    "AWS IAM Quick Start.rdp",
    "AWS SDE Compliance Check.rdp",
    "AWS SDE Environment Check.rdp",
    "AWS Secure Data Exchange - Compliance Check.rdp",
    "AWS Secure Data Exchange Compliance.rdp",
    "Device Configuration Verification.rdp",
    "Device Security Requirements Check.rdp",
    "IAM Identity Center Access.rdp",
    "IAM Identity Center Application Access.rdp",
    "Zero Trust Architecture Configuration.rdp",
    "Zero Trust Security Environment Compliance Check.rdp",
    "ZTS Device Compatibility Test.rdp"
)
| project Timestamp, FileName, SHA256, RecipientEmailAddress, SenderDisplayName, SenderFromAddress
```

### Defender for Endpoint - All Initiated RDP Connections
```kusto
DeviceProcessEvents
| where FileName == "mstsc.exe" and ProcessCommandLine contains ".rdp"
| where ProcessCommandLine !contains @"Documents\Default.rdp"
```

## Reference
[Microsoft Security Blog: Midnight Blizzard conducts large-scale spear-phishing campaign using RDP files](https://www.microsoft.com/en-us/security/blog/2024/10/29/midnight-blizzard-conducts-large-scale-spear-phishing-campaign-using-rdp-files)
=======
# Midnight Blizzard (NOBELIUM)
## Threat Overview
* **Spear-Phishing Campaign**: Since October 22, 2024, Russian threat actor Midnight Blizzard has been sending targeted spear-phishing emails to various sectors, including government and academia.
 
* **Novel Access Vector**: The campaign uses a signed Remote Desktop Protocol (RDP) configuration file to gain access to targets' devices, a new method for this actor.
 
* **Targets and Techniques**: Midnight Blizzard primarily targets entities in the US and Europe, using diverse methods like spear phishing, stolen credentials, and supply chain attacks.
 
* **Mitigation and Detection**: Microsoft provides indicators of compromise (IOCs), hunting queries, and recommendations to help mitigate this threat.
 
## Detection Queries
### Potential RDP Attachment Phishing Attempts
```kusto
EmailAttachmentInfo
| where FileName has ".rdp"
| join kind=inner (EmailEvents) on NetworkMessageId
| project SenderFromAddress, RecipientEmailAddress, Subject, Timestamp, FileName, FileType
```
### Correlation Between RDP Email Attachments and Outbound RDP Connections
```kusto
// Step 1: Identify emails with RDP attachments
let rdpEmails = EmailAttachmentInfo
| where FileName has ".rdp"
| join kind=inner (EmailEvents) on NetworkMessageId
| project EmailTimestamp = Timestamp, RecipientEmailAddress, NetworkMessageId, SenderFromAddress;
// Step 2: Identify outbound RDP connections
let outboundRDPConnections = DeviceNetworkEvents
| where RemotePort == 3389
| where ActionType == "ConnectionAttempt"
| where RemoteIPType == "Public"
| project RDPConnectionTimestamp = Timestamp, DeviceId, InitiatingProcessAccountUpn, RemoteIP;
// Step 3: Correlate email and network events
rdpEmails
| join kind=inner (outboundRDPConnections) on $left.RecipientEmailAddress == $right.InitiatingProcessAccountUpn
| project EmailTimestamp, RecipientEmailAddress, SenderFromAddress, RDPConnectionTimestamp, DeviceId, RemoteIP
```
### Microsoft Threat Intelligence RDP Connection Files
```kusto
EmailAttachmentInfo
| where FileName in~ (
    "AWS IAM Compliance Check.rdp",
    "AWS IAM Configuration.rdp",
    "AWS IAM Quick Start.rdp",
    "AWS SDE Compliance Check.rdp",
    "AWS SDE Environment Check.rdp",
    "AWS Secure Data Exchange - Compliance Check.rdp",
    "AWS Secure Data Exchange Compliance.rdp",
    "Device Configuration Verification.rdp",
    "Device Security Requirements Check.rdp",
    "IAM Identity Center Access.rdp",
    "IAM Identity Center Application Access.rdp",
    "Zero Trust Architecture Configuration.rdp",
    "Zero Trust Security Environment Compliance Check.rdp",
    "ZTS Device Compatibility Test.rdp"
)
| project Timestamp, FileName, SHA256, RecipientEmailAddress, SenderDisplayName, SenderFromAddress
```
### Defender for Endpoint - All Initiated RDP Connections
```kusto
DeviceProcessEvents
| where FileName == "mstsc.exe" and ProcessCommandLine contains ".rdp"
| where ProcessCommandLine !contains @"Documents\Default.rdp"
```
## Reference
[Microsoft Security Blog: Midnight Blizzard conducts large-scale spear-phishing campaign using RDP files](https://www.microsoft.com/en-us/security/blog/2024/10/29/midnight-blizzard-conducts-large-scale-spear-phishing-campaign-using-rdp-files)
![image](https://github.com/user-attachments/assets/a27ecb64-f394-4dcf-9422-ce314d4b665c)
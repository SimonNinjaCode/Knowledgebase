---
layout:
  width: wide
---

# Threat Report Summary: Storm-0501

## Key Findings

* **Hybrid Cloud Compromise:** Storm-0501 exploited weak credentials and over-privileged accounts to move from on-premises to cloud environments, leading to data exfiltration, credential theft, and ransomware deployment.
* **Credential Theft:** The threat actor stole credentials from on-premises environments, including Microsoft Entra ID (formerly Azure AD), to gain control of cloud networks and establish persistent backdoor access.
* **Cloud Pivot Techniques:** They used tools like Microsoft Entra Connect Sync to synchronize identity data and exploited these accounts to pivot from on-premises to cloud environments.
 
## Entra Connect Accounts
* On-premises: prefix "MSOL_"
* Cloud: "sync_Entra_Connect_Server_Name"
* Displayname: "On-Premises Directory Synchronization Service Account"
 
## Compromised Domain Admin Credentials
* If the password is known, then logging in to Microsoft Entra is possible from any device.
* If the password is unknown, the threat actor can reset the on-premises user password, and after a few minutes the new password will be synced to the cloud.
* If they hold credentials of a compromised Microsoft Entra Directory Synchronization Account, they can set the cloud password using AADInternals' Set-AADIntUserPassword cmdlet.
 
## Attack Techniques
* **Used Existing/Masquerading Binaries:** The threat actor was observed exfiltrating sensitive data from compromised devices. To exfiltrate data, the threat actor used the open-source tool Rclone and renamed it to known Windows binary names or variations of them, such as *svhost.exe* or *scvhost.exe* as masquerading means.
 
* **Persistent Backdoor:** Storm-0501 created a persistent backdoor by setting up a federated domain, allowing them to impersonate any user in the Microsoft Entra ID tenant.
 
## Recommendations
 
### On-premises
* Decrease the accounts that can login to Tier 0 entities. This includes Entra Connect servers.
* Optimal security is to use tiering for Active Directory and to ensure that highly privileged admins can manage the infrastructure from PAWs.
 
### Cloud
* Ensure that the admin account is separate from the on-premises.
* Ensure that MFA and session token time is enforced for all admin roles.
* Decrease the number of global administrators in the tenant.
* Optimal Security is to ensure that highly privileged admins can manage the infrastructure from PAWs.
 
## Reference
[Microsoft Security Blog: Storm-0501 ransomware attacks expanding to hybrid cloud environments](https://www.microsoft.com/en-us/security/blog/2024/09/26/storm-0501-ransomware-attacks-expanding-to-hybrid-cloud-environments/)

# Device Code Phishing Campaign

**Category: Phishing / Social Engineering**
 
Microsoft has identified a cyberattack group called Storm-2372, which is using a phishing technique known as "device code phishing" to steal login tokens from users.
 
## What is Device Code Phishing?

Device Code Phishing is an attack that exploits OAuth 2.0 device authorization flow, primarily used for devices with limited input capabilities.

Attackers trick users into entering a legitimate-looking device code on Microsoft's website, granting the attacker's malicious application access to the user's account, often bypassing MFA.
 
## Teams-Specific Risks

* Phishing messages sent through Teams from compromised accounts
* Disguised Meeting Invites
* External Teams messages containing device code phishing links  

## Mitigations
 
* Block the device code flow in Conditional Access
* Restrict guest access capabilities
* Regulate which tenants your organization can collaborate with
* Ensure MFA is enabled, even better if it's phishing-resistant MFA
* Ensure Risk policies in conditional access are used (User Risk, Sign-in risk)
* Block Legacy authentication using Conditional Access
 
## Reference

[Microsoft Security Blog: Storm-2372 conducts device code phishing campaign](https://www.microsoft.com/en-us/security/blog/2025/02/13/storm-2372-conducts-device-code-phishing-campaign/)

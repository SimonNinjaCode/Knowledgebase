---
layout:
  width: wide
---

# TokenSmith – Bypassing Intune Compliant Device

**Proof of Concept (PoC)** developed by JUMPSEC Labs, which leverages a tool called TokenSmith to bypass this requirement.

The PoC involves using a specific client ID and redirect URI to obtain access and refresh tokens without meeting the compliance requirements.

## Application Details
- **Application**: Company Intune Portal
- **Client_id**: 9ba1a5c7-f17a-4de9-a1f1-6178c8d51223
- **Note**: *First Party Application in Entra ID*

## Bypass Requirements
Either of the following:
* Enduser account with password/MFA stolen (phishing) 
* Valid ESTSAUTH/ESTSAUTHPERSISENT Cookies (Can be stolen from AiTM Phishing, evilginx for example)

## Reference
[JUMPSEC Labs: TokenSmith - Bypassing Intune Compliant Device Conditional Access](https://labs.jumpsec.com/tokensmith-bypassing-intune-compliant-device-conditional-access/)

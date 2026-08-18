# Token Theft Protection

### Authentication Methods Security Comparison

| **Authentication Method** | **Password Spray / MFA Fatigue** | **Adversary in the Middle - AitM** |
|--------------------------|----------------------------------|-----------------------------------|
| Username + Password | ❌ | ❌ |
| Telephony as MFA | ❌ | ❌ |
| Authenticator App (Notifications) | ❌ | ❌ |
| Authenticator App (Number match) | ✅ | ❌ |
| Authenticator App (Passwordless) | ✅ | ❌ |
| Certificate Based Authentication | ✅ | ✅ |
| Windows Hello for Business | ✅ | ✅ |
| FIDO2 Security Key | ✅ | ✅ |
| Entra ID Passkey | ✅ | ✅ |
| Token Protection (CA Preview) | - | ✅ |
| Cloud PAW + FIDO2 | 👑 | 👑 |

### Conditional Access
* Token Protection (Token Binding)
* Continuous access evaluation

###  Defender XDR
* Stolen session cookie was used. Cross signal alert created when Cookie stolen using Microsoft Edge browser and attacker attempts to reply the stolen session cookie to access Exchange Online.

### Defender for Office 365
* Email messages containing malicious file removed after delivery. This alert is generated when any messages containing a malicious file are delivered to mailboxes in an organization. Microsoft removes the infected messages from Exchange Online mailboxes using zero-hour auto purge (ZAP) if this event occurs.
* Email messages from a campaign removed after delivery. This alert is generated when any messages associated with a campaign are delivered to mailboxes in an organization. Microsoft removes the infected messages from Exchange Online mailboxes using ZAP if this event occurs.

### Defender for Cloud Apps
* Suspicious inbox manipulation rule. The attackers set an Inbox rule to hide their malicious activities. Defender for Cloud Apps identifies such suspicious rules and alerts users when detected.
* Impossible travel activity. The attackers used multiple proxies or virtual private networks (VPNs) from various countries or regions. Sometimes, their attack attempts happen at the same time the actual user is signed in, thus raising impossible travel alerts.
* Activity from infrequent country. Because the attackers used multiple proxies or VPNs, on certain occasions, the egress endpoints of these VPN and proxy servers are uncommon for the user, thus raising this alert.

###  Identity Protection
* Anomalous Token. This alert flags a token's unusual characteristics, such as its token lifetime or played from an unfamiliar location.
* Unfamiliar sign-in properties. In this phishing campaign, the attackers used multiple proxies or VPNs originating from various countries or regions unfamiliar to the target user.
* Unfamiliar sign-in properties for session cookies. This alert flags anomalies in the token claims, token age, and other authentication attributes.
* Anonymous IP address. This alert flags sign-in attempts from anonymous IP addresses (for example, Tor browser or anonymous VPN).

---

# Token Protection (Token Binding)

Token protection (sometimes referred to as token binding in the industry) attempts to reduce attacks using token theft by ensuring a token is usable only from the intended device.

When an attacker is able to steal a token, by hijacking or replay, they can impersonate their victim until the token expires or is revoked.

Token protection creates a cryptographically secure tie between the token and the device (client secret) it's issued to. Without the client secret, the bound token is useless.

When a user registers a Windows or newer device in Entra ID, their primary identity is bound to the device. This connection means that any issued sign-in token is tied to the device, significantly reducing the chance of theft and replay attacks.

These sign-in tokens are specifically the session cookies in Microsoft Edge and most Microsoft product refresh tokens in this preview release.

---

# Token Theft Resources

## Security Guidelines
- [OAuth 2.0 Threat Model and Security Considerations](https://datatracker.ietf.org/doc/html/rfc6819)
- [Cloud Architekt - AzureAD-Attack-Defense - Replay of Primary Refresh (PRT) and other issued tokens from an Azure AD joined device](https://github.com/Cloud-Architekt/AzureAD-Attack-Defense/blob/main/ReplayPRTandTokens.md)
- [Microsoft Incident Response / Security Research - Token tactics: How to prevent, detect, and respond to cloud token theft](https://learn.microsoft.com/en-us/security/operations/token-tactics)
- [Jeffrey Appel - Protect against AiTM/ MFA phishing attacks using Microsoft technology](https://jeffreyappel.nl/protect-against-aitm-mfa-phishing-attacks-using-microsoft-technology/)
- [Security Blog - Microsoft - Token Theft](https://www.microsoft.com/en-us/security/blog/2022/09/22/malicious-oauth-applications-used-to-compromise-email-servers-and-spread-spam/)
- [BlueHat IL 2023 - David Weston - Default Security](https://www.youtube.com/watch?v=nX1lLQgkScw)
- [Phishing and Microsoft Protections](https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/anti-phishing-protection-about)

## Attack Tools & Techniques
- [Muarena Phishing Toolkit](https://github.com/Muara/muarena)
- [Modlishka Reverse Proxy (Phishing)](https://github.com/drk1wi/Modlishka)
- [Github - Kuba Gretzky - Evilginx](https://github.com/kgretzky/evilginx2)
- [Dirk-jan Mollema - Abusing Azure AD SSO with the Primary Refresh Token](https://dirkjanm.io/abusing-azure-ad-sso-with-the-primary-refresh-token/)
- [Lee Christensen - Requesting Azure AD Request Tokens on Azure-AD-joined Machines for Browser SSO](https://posts.specterops.io/requesting-azure-ad-request-tokens-on-azure-ad-joined-machines-for-browser-sso-2b0409caad30)
- [Dr.AzureAD - Getting access with pass-the-token and pass-the-cert](https://dr.azureadadvisors.com/2022/09/getting-access-with-pass-token-and.html)
- [Jan Bakker - How to set up Evilginx to phish Office 365 credentials](https://janbakker.tech/how-to-set-up-evilginx-to-phish-office-365-credentials/)
- [mr d0x - Stealing tokens from Office Applications](https://mrd0x.com/stealing-tokens-from-office-applications/)
- [Trusted Sec - HACKING YOUR CLOUD: TOKENS EDITION 2.0](https://trustedsec.com/blog/hacking-your-cloud-tokens-edition-2-0)
- [Northsec IO 2023 - Dr AzureAD - Tokens Everywhere](https://www.youtube.com/watch?v=HwbXzPZHSx0)
- [Building an AITM attack tool in Cloudflare Workers (174 LOC) – Zolder B.V.](https://zolder.io/building-an-aitm-attack-tool-in-cloudflare-workers/)
- [AiTM Phishing with Azure Functions | by Nicola | Apr, 2024 | Medium](https://medium.com/@nicolabeach/aitm-phishing-with-azure-functions-db2e73400623)
---

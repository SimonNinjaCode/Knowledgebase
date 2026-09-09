---
layout:
  width: wide
---

# Threat Intelligence Report — 2026-09-07

## Executive Summary

The current material is dominated by identity-led access: attackers are using Teams social engineering, phishing obfuscation, helpdesk impersonation, and stolen or misused credentials to reach Microsoft 365 and on-premises identity systems. Endpoint campaigns remain tightly connected to that problem, with TerminalFix and counterfeit installers adding persistence, reconnaissance, and lateral movement after a user executes the initial lure. The most immediate risk is a successful user-initiated access path that bypasses normal email controls and hands an attacker an interactive session inside the enterprise.

## Key Threats

### Teams helpdesk impersonation and remote-session abuse
**Type:** Social engineering, remote access, hands-on-keyboard intrusion  
**Severity:** Critical  
**MITRE ATT&CK:** T1566.003, T1059.001, T1218.007, T1087.002, T1018, T1113, T1021.006, T1105  
**CVEs:** None reported  
**Affected:** Microsoft Teams external collaboration, RMM tools, Windows endpoints, Active Directory, WinRM  
**M365/Azure relevance:** External Teams contact can become a direct bridge into user devices and identity infrastructure.  
**Summary:** Microsoft observed attackers posing as IT or helpdesk staff in Teams, persuading users to grant remote control, then installing an MSI and a Node.js implant. The chain includes AD discovery, screenshots, PowerShell, trusted Windows binaries, and WinRM movement toward domain controllers.  
**Recommendations:** Restrict and review external Teams communication; require verified helpdesk workflows and just-in-time remote support; alert on unusual RMM, MSI, PowerShell, Node.js, and WinRM combinations.  
**Source:** [Impersonating IT support](https://www.microsoft.com/en-us/security/blog/2026/09/02/impersonating-it-support-threat-actors-turn-remote-session-into-enterprise-wide-access/)

### ASCII smuggling in finance-themed phishing
**Type:** Phishing and filter evasion  
**Severity:** High  
**MITRE ATT&CK:** T1566, T1027; MITRE ATLAS AML.T0068  
**CVEs:** None reported  
**Affected:** Exchange Online, Defender for Office 365, email security gateways, AI systems that ingest email  
**M365/Azure relevance:** Invisible Unicode tag characters can change how filters and downstream AI systems tokenize a message while leaving the visible lure readable to users.  
**Summary:** A high-volume campaign inserted invisible Unicode characters into words such as “funding” to evade keyword and signature matching. Microsoft linked the activity to an ActiveCampaign-delivered SBA-themed phishing operation.  
**Recommendations:** Hunt for U+E0000–U+E007F in message bodies and subjects; keep layered anti-phishing controls enabled; test mail-processing and AI workflows against Unicode normalization and hidden text.  
**Source:** [ASCII smuggling crosses over from AI prompt injection to phishing evasion](https://www.microsoft.com/en-us/security/blog/2026/09/03/ascii-smuggling-crosses-over-from-ai-prompt-injection-to-phishing-evasion/)

### Counterfeit installers linked to Silver Fox activity
**Type:** Malware delivery, privilege escalation, defense evasion  
**Severity:** High  
**MITRE ATT&CK:** T1204.002, T1059.001, T1218.007, T1053.005, T1562.001, T1036.005, T1574.002, T1055  
**CVEs:** None reported  
**Affected:** Windows endpoints, Microsoft Defender, organizations downloading software from the web  
**M365/Azure relevance:** Compromised endpoints can expose browser sessions, credentials, and cloud access; Defender exclusions and SMB movement increase tenant blast radius.  
**Summary:** Look-alike vendor sites deliver malicious installers to Chinese-speaking users and China-based operations of multinational organizations. Microsoft observed scheduled-task SYSTEM execution, Defender exclusion changes, process injection, SMB lateral movement, and C2; the activity is assessed with moderate confidence as Silver Fox/Yinhu.  
**Recommendations:** Enforce approved software sources; enable SmartScreen, network protection, tamper protection, and Defender XDR; investigate new Defender exclusions and short-lived SYSTEM tasks.  
**Source:** [Counterfeit installers to system compromise](https://www.microsoft.com/en-us/security/blog/2026/09/01/counterfeit-installers-system-compromise-tracking-deceptive-software-download-campaign/)

### TerminalFix reverse-tunnel campaign
**Type:** ClickFix social engineering, persistence, network pivoting  
**Severity:** Critical  
**MITRE ATT&CK:** T1189, T1059.001, T1204.002, T1547.001, T1053.005, T1574.002, T1027.003, T1572, T1018, T1069.002, T1482, T1087.002  
**CVEs:** None reported  
**Affected:** Windows endpoints, PowerShell/Windows Terminal, Active Directory, internal network paths  
**M365/Azure relevance:** A device compromised through a web lure can become a pivot into hybrid identity and privileged network segments.  
**Summary:** A fake Cloudflare CAPTCHA persuades users to paste a PowerShell command. The chain uses DLL sideloading, steganography, AD reconnaissance, persistence, and a reverse WebSocket tunnel.  
**Recommendations:** Hunt for fake-CAPTCHA referrals, suspicious Run keys and scheduled tasks, DLL sideloading, and WebSocket tunnels; isolate affected devices and review identity activity from them.  
**Source:** [TerminalFix campaign](https://www.microsoft.com/en-us/security/blog/2026/08/28/terminalfix-campaign-deploys-reverse-tunnel-through-multistage-intrusion/)

### Pass-the-Passkey implementation bypass
**Type:** Authentication bypass and credential theft  
**Severity:** High  
**MITRE ATT&CK:** T1555, T1056.002, T1078.004  
**CVEs:** No single CVE established in the source material  
**Affected:** Windows passkeys, browsers, password managers, Microsoft Entra ID  
**M365/Azure relevance:** Phishing resistance weakens when an attacker can operate below the browser origin-binding layer or obtain reusable assertion material.  
**Summary:** Black Hat research described attacks against passkey implementations across Windows, Entra ID, browsers, and password managers, including exposure of complete passkey assertions in Windows event logs.  
**Recommendations:** Track vendor fixes; restrict access to authentication logs; pair passkeys with device compliance, phishing-resistant Conditional Access, and strong workstation controls.  
**Source:** [Pass-the-Passkey](https://entra.news/p/pass-the-passkey-what-michael-grafnetters)

### DeadLock ransomware
**Type:** Ransomware and data extortion  
**Severity:** Critical  
**MITRE ATT&CK:** T1486, T1490, T1562.001, T1071.001, T1105  
**CVEs:** None reported  
**Affected:** Windows environments, backup and recovery infrastructure, data-leak channels  
**M365/Azure relevance:** Identity compromise and cloud-connected recovery workflows can let ransomware operators move from endpoints into shared data and administrative control planes.  
**Summary:** Microsoft tracks DeadLock as an emerging financially motivated operation using a Rust encryptor and decentralized infrastructure built around Session messaging and blockchain-backed services.  
**Recommendations:** Separate and test recovery paths; enforce least privilege for backup and storage administrators; monitor for deletion of recovery artifacts and abnormal encryption.  
**Source:** [DeadLock ransomware](https://www.microsoft.com/en-us/security/blog/2026/08/10/deadlock-ransomware-breaking-down-a-rust-based-encryptor-with-decentralized-recovery-infrastructure/)

### Cloaked macOS ClickFix and infostealers
**Type:** Social engineering, infostealer delivery, browser fingerprinting  
**Severity:** High  
**MITRE ATT&CK:** T1189, T1204.002, T1059.004, T1027  
**CVEs:** None reported  
**Affected:** macOS endpoints, browsers, Microsoft 365 sessions and stored credentials  
**M365/Azure relevance:** MacSync and Atomic Stealer can target tokens and credentials used for M365 and SaaS access; server-side cloaking reduces sandbox visibility.  
**Summary:** The campaign shifted from openly serving fake Terminal lures to fingerprinting visitors and showing the lure only to likely macOS users. The same infrastructure distributes MacSync and Atomic Stealer through look-alike domains.  
**Recommendations:** Treat user-pasted Terminal commands as high risk; hunt for domain-generation and fingerprinting patterns; revoke sessions and reauthenticate after suspected infostealer exposure.  
**Source:** [macOS ClickFix campaign](https://www.microsoft.com/en-us/security/blog/2026/08/05/macos-clickfix-campaign-learned-hide/)

### Endpoint isolation as ransomware containment
**Type:** Ransomware interruption and lateral-movement prevention  
**Severity:** High  
**MITRE ATT&CK:** T1059, T1105, T1021, T1486  
**CVEs:** None reported  
**Affected:** Microsoft Defender for Endpoint-managed Windows workstations  
**M365/Azure relevance:** Identity containment alone does not stop code already running on a device; device isolation closes the local execution and pivot path.  
**Summary:** In the QNET case, Defender isolated the endpoint 128 seconds after a high-severity alert, stopping a multistage attack before persistence or lateral movement.  
**Recommendations:** Validate automatic attack-disruption eligibility; onboard high-value workstations; rehearse the joint user-plus-device containment workflow.  
**Source:** [128 Seconds to disruption](https://www.microsoft.com/en-us/security/blog/2026/08/04/129-seconds-disruption-microsoft-defender-stops-ransomware-qnet/)

## Threat Actor Activity

Named activity includes Silver Fox/Yinhu fake-software distribution, TeamPCP supply-chain operations, and financially motivated DeadLock ransomware. Microsoft also describes an unnamed macOS ClickFix operator cluster and a broader ActiveCampaign-delivered SBA-themed phishing campaign. The Teams helpdesk operation and TerminalFix activity are described as campaigns without a named actor; attribution should not be inferred from tooling or infrastructure alone.

## Recommended Actions

1. Tighten external Teams and remote-support workflows.
2. Hunt for PowerShell, msiexec, Node.js, RMM, WinRM, scheduled tasks, Defender exclusion changes, DLL sideloading, and reverse tunnels.
3. Add Unicode tag-character detection to email and AI-ingestion pipelines.
4. Enforce approved software sources and enable SmartScreen, tamper protection, network protection, and attack disruption.
5. Review Entra service accounts, SaaS-local administrators, delegated password-reset rights, workload federation, and privileged roles.
6. Treat suspected infostealer or passkey exposure as an identity incident: revoke sessions and tokens, rotate secrets, and re-register affected authenticators.
7. Test recovery and ransomware containment with both user and device isolation.

## Sources

- [Entra News #165](https://entra.news/p/entra-news-165-this-week-in-microsoft)
- [ASCII smuggling](https://www.microsoft.com/en-us/security/blog/2026/09/03/ascii-smuggling-crosses-over-from-ai-prompt-injection-to-phishing-evasion/)
- [Impersonating IT support](https://www.microsoft.com/en-us/security/blog/2026/09/02/impersonating-it-support-threat-actors-turn-remote-session-into-enterprise-wide-access/)
- [Counterfeit installers](https://www.microsoft.com/en-us/security/blog/2026/09/01/counterfeit-installers-system-compromise-tracking-deceptive-software-download-campaign/)
- [Microsoft ISPM recommendations](https://techcommunity.microsoft.com/t5/microsoft-defender-xdr-blog/stop-identity-attacks-before-they-start-with-microsoft-ispm/ba-p/4549692)
- [Entra News #164](https://entra.news/p/entra-news-164-this-week-in-microsoft)
- [TerminalFix](https://www.microsoft.com/en-us/security/blog/2026/08/28/terminalfix-campaign-deploys-reverse-tunnel-through-multistage-intrusion/)
- [TeamPCP arrests](https://arstechnica.com/security/2026/08/authorities-arrest-2-alleged-members-of-prolific-hacking-group-teampcp/)
- [Entra News #163](https://entra.news/p/entra-news-163-this-week-in-microsoft)
- [Pass-the-Passkey](https://entra.news/p/pass-the-passkey-what-michael-grafnetters)
- [Entra News #162](https://entra.news/p/entra-news-162-this-week-in-microsoft)
- [Chrome account-takeover protection](https://arstechnica.com/security/2026/08/chrome-adopts-what-may-be-the-best-protection-yet-against-account-takeovers/)
- [DeadLock ransomware](https://www.microsoft.com/en-us/security/blog/2026/08/10/deadlock-ransomware-breaking-down-a-rust-based-encryptor-with-decentralized-recovery-infrastructure/)
- [Entra News #161](https://entra.news/p/entra-news-161-this-week-in-microsoft)
- [macOS ClickFix](https://www.microsoft.com/en-us/security/blog/2026/08/05/macos-clickfix-campaign-learned-hide/)
- [The Dead Zone](https://patchmypc.com/blog/the-dead-zone/)
- [128 Seconds to disruption](https://www.microsoft.com/en-us/security/blog/2026/08/04/129-seconds-disruption-microsoft-defender-stops-ransomware-qnet/)
- [Entra News #160](https://entra.news/p/entra-news-160-this-week-in-microsoft)
- [Why Active Directory alone is no longer enough](https://techcommunity.microsoft.com/t5/microsoft-entra-blog/why-active-directory-alone-is-no-longer-enough/ba-p/4546402)
- [Active Directory is 10x harder to defend than Entra](https://entra.news/p/microsoft-security-architect-active)

---
layout:
  width: wide
domain: m365-e7
title: "Microsoft 365 E7 — Översikt"
created: 2026-05-30
updated: 2026-06-27
type: concept
tags: ["#m365-e7", "#microsoft-365"]
sources:
  - "https://blogs.microsoft.com/blog/2026/03/09/introducing-the-first-frontier-suite-built-on-intelligence-trust/"
  - "raw/Reports/notebooklm/m365-e7-ciso-briefing-2026-06-06.md"
---

# Microsoft 365 E7 — Översikt

Microsoft 365 E7 ("Step-up") är Microsofts premium-svit, lanserad mars 2026, som bygger på E5 och lägger till nästa generations AI-agenter, avancerad identitetsgovernance och djupgående AI-säkerhet.

## Ingående moduler

### Agent 365
Agentramverket för att bygga, hantera och säkra AI-agenter i Microsoft 365. Se Agent 365 Index.

### Microsoft 365 Copilot Premium
Copilot utökad med Copilot Cowork, AI Priority Access, Model Choice, Copilot Studio, och Copilot i alla Office-appar. Se Copilot Index.

### Entra Suite (add-on)
Entra ID Governance, Verified ID Premium, Internet/Private Access. Se Entra Suite Index.

## E5 vs E7 — Capability Comparison

Övergången från E5 till E7 är inte en stegvis uppgradering — den representerar ett skifte från traditionell cybersecurity till AI- och agent-governance.

| Capability | Microsoft 365 E5 | Microsoft 365 E7 |
|:---|:---|:---|
| **Primary Focus** | Human Identity & Data | AI Agent Identity & Governance |
| **Data Protection** | Standard DLP | DSPM for AI & AI-aware DLP |
| **Identity** | Entra ID P2 (Users/Devices) | Agent ID Governance & Entra Suite |
| **Access** | VPN / Standard Conditional Access | ZTNA (Private Access) & Agent-CA |
| **AI Experience** | Standard Copilot | Copilot Cowork, Tuning, & Model Choice |
| **Insider Risk** | Human-centric indicators | AI-specific indicators & Agent Audit |

**CISO-nivå:** E7 är miniminivån för organisationer där AI-agenter har access till Graph-data eller där anställda använder externa LLMs som Claude eller Codex.^[raw/Reports/notebooklm/m365-e7-ciso-briefing-2026-06-06.md]

## The Third Identity Pillar: Agent ID

I E7-arkitekturen behandlas AI-agenter som **första klassens identiteter** — vid sidan av användare och enheter. Microsoft Entra Agent ID introducerar:

| Koncept | Beskrivning |
|:--------|:------------|
| **Agent Blueprint** | Återanvändbar identitetsmall med inbyggda policyer och behörigheter |
| **Agent Identity** | Per-instans identitet med inloggningshistorik, audit trail och per-instans kill switch |
| **Agent Sponsors** | Mänsklig ansvarskedja — varje agent har en utpekad sponsor |
| **Conditional Access for Agents** | Block som standard — agenter kan inte göra MFA, så endast IP/location allowlisting fungerar |

**Key implication:** Varje agent måste ha en workload-identitet, Conditional Access-policy och livscykelhantering. Att köra AI-agenter utan Agent ID governance är som att ge alla anställda admin-credentials.^[raw/Reports/notebooklm/m365-e7-ciso-briefing-2026-06-06.md]

## Multi-Model Governance

Enterprise AI blir en multi-modell-miljö med Copilot + Claude + Codex. E7:s **Model Choice** möjliggör användning av Anthropic-modeller inom Copilot Studio, med Microsofts dataskydd som sträcker sig till dessa modeller. Detta kräver:

- **Data-Centric Security:** Dokument utan sensitivity labels behandlas som hög risk
- **Labels follows data:** Sensitivity labels måste persist när data klistras in i webbaserade AI-gränssnitt
- **Shadow AI Audit:** Purview DSPM identifierar ohanterade LLMs och kvantifierar dataläckagerisk
- **Zero Trust for AI:** Alla AI-agenter — oavsett om de är Microsofts, Anthropics eller OpenAIs — behandlas som opålitliga tills verifierade^[raw/Reports/notebooklm/m365-e7-ciso-briefing-2026-06-06.md]

## License Decision Matrix

| Feature | Required License/Add-on |
|:--------|:-----------------------|
| **Conditional Access for Agents** | Microsoft Entra ID P1 |
| **ID Protection for Agents** | Microsoft Entra ID P2 |
| **ID Governance for Agents** | Microsoft Entra ID P1 |
| **Network Controls (GSA)** | Entra Internet Access |
| **Agent Registry Management** | Microsoft Agent 365 (E7) |

## Nyckelområden

### Agenter
- 18 agent-specifika funktioner: Conditional Access, Identity Governance, Comm Compliance, DLP, DSPM, Insider Risk, Lifecycle Management, Registry Sync, med mera
- Agent 365 är navet — alla Purview- och Entra-integrationer för agenter

### Säkerhet
- Entra Internet Access (SASE/SSE)
- Entra Private Access (ZTNA)
- Conditional Access för agenter
- Defender for Cloud Apps för agenter
- Global Secure Access för AI-traffic
- DSPM för AI-data

### Compliance / Efterlevnad
- Communication Compliance för AI-interaktioner
- Data Lifecycle Management för agentdata
- Data Loss Prevention för AI-prompter/svar
- Insider Risk Management för agentanvändning
- Information Protection för agentkontext

## Källa
- [Microsoft blog: Introducing the first frontier suite built on intelligence-trust](https://blogs.microsoft.com/blog/2026/03/09/introducing-the-first-frontier-suite-built-on-intelligence-trust/)
- [M365 Maps E7](https://m365maps.com/files/Microsoft-365-E7.htm)
- raw/Reports/notebooklm/m365-e7-ciso-briefing-2026-06-06.md

---
domain: m365-e7
title: "Identity Protection & Zero Trust — M365 E7"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#solutions-architecture", "#ciso", "#identity", "#zero-trust"]
sources: []
---

# Identity Protection & Zero Trust

## E7:s identitetsförmågor

E7 utökar Entra ID P2 med AI-specifika identitetskontroller som inte finns i E5:

| Förmåga | E5 | E7 |
|---------|----|----|
| Entra ID P2 (PIM, ID Protection) | ✅ Ja | ✅ Ja |
| Entra ID Governance | ❌ Add-on | ✅ Inkluderat |
| Entra Verified ID Premium | ❌ Nej | ✅ Inkluderat |
| Entra Internet Access | ❌ Nej | ✅ Inkluderat |
| Entra Private Access | ❌ Nej | ✅ Inkluderat |
| Agent Conditional Access | ❌ Nej | ✅ Ja |
| Agent ID Governance | ❌ Nej | ✅ Ja |
| Agent ID Protection | ❌ Nej | ✅ Ja |

## Zero Trust for AI — nytt paradigm

Traditionell Zero Trust handlar om **users, devices, networks**. Zero Trust for AI lägger till:

### 1. Agent-identiteter som first-class citizens
AI-agenter har egna workload-identiteter i Entra. Varje agent:
- Har en unik agent identity (service principal)
- Kan ha Conditional Access-policyer specifika för agenten
- Hanteras via Agent Registry Sync
- Har en blueprint som definierar dess livscykel och governance-modell

### 2. Agent Conditional Access — verifiera varje anrop
Precis som en användare måste verifieras vid inloggning, måste varje agent som anropar en resurs verifieras:
- **Agent-identitetens risknivå** — är den komprometterad?
- **Agentens ursprung** — kommer den från rätt blueprint?
- **Agentens access-mönster** — beter den sig normalt eller avvikande?
- **Attribute-baserad policy** — agenthierarki, datasensitivity, ursprung

### 3. Agent ID Protection — riskbedömning för agenter
Entra ID Protection utökas till att täcka agent-identiteter:
- Ovanliga agent-anropsmönster
- Agent credentials som kan ha läckts
- Risk-baserad åtkomstkontroll för agenter

## Skydda identiteter i en multi-AI-miljö

| Scenario | Åtgärd |
|----------|--------|
| Copilot Studio-agent som behöver läsa SharePoint | Agent Conditional Access: verifiera blueprint + datasensitivity |
| Utvecklare använder Codex med GitHub-inloggning | Entra ID Protection övervakar inloggningsmönster. Session Control begränsar vad Codex når |
| Claude Enterprise med SSO | Entra blir IdP. Conditional Access kräver compliant device + MFA |
| Anonym agent som försöker nå Microsoft Graph | Blockeras av Agent ID Protection + Agent Registry (finns inte i registryt) |

## Rekommenderad arkitektur

```
Entra ID P2 (bas)
├── Identity Protection — riskbedömning users + agents
├── PIM — just-in-time admin access
├── Conditional Access — policyer för users + agents
│
├── Entra ID Governance (add-on i E7)
│   ├── Lifecycle Workflows
│   ├── Entitlement Management
│   └── ML Assisted Access Reviews
│
├── Agent 365 Identity
│   ├── Agent ID Verification
│   ├── Agent Registry Sync
│   ├── Agent Conditional Access Integration
│   └── Agent ID Protection
│
└── Entra Suite (add-on i E7)
    ├── Internet Access (AI-gateway)
    ├── Private Access (ZTNA)
    ├── Verified ID Premium
    └── Face Check
```

## CISO-insikt: AI-agenter som tredje identitetspelaren

Den största förändringen i identitetsarkitektur 2025-2026 är att **AI-agenter blir en tredje identitetstyp** — vid sidan av users och devices. Microsoft, IBM och andra etablerar nu ramverk för agent-identiteter som first-class citizens i Entra:

Reza Sahebis video ["AI Agents: The Third Pillar of Identity in Microsoft Entra"](https://youtu.be/NDa3Jcsi2go) fångar skiftet: "Vi har haft user identities och device identities i årtionden. Nu tillkommer agent identities — och de kräver en helt ny governance-modell."

**Vad detta betyder praktiskt:**
- Varje agent måste ha en blueprint som definierar dess livscykel — från provisioning till offboarding
- Agent Registry Sync blir lika kritisk som Active Directory-sync var
- Non-human identity (NHI) governance är en ny kompetens som säkerhetsteam måste bygga

> Microsoft Cloud IT Pro Podcast episode ["Non-Human Identities in Microsoft Entra"](https://youtu.be/rLN7WoDLT4U) (Mar 2026) ger en utmärkt introduktion till NHI i Entra — governance, lifecycle, och hur det skiljer sig från traditionell IAM.

## Video-resurser (curated)

| Video | Kanal | Datum | Varför? |
|-------|-------|-------|---------|
| [How Microsoft Agent 365 works](https://youtu.be/yWwYLbMvc3s) | Microsoft Mechanics ✓ | Dec 2025 | **68.9K views** — mest sedda videon om Agent 365. Start här |
| [Explore Agent 365 security and governance \| BRK269](https://youtu.be/RsCz57M2SMc) | Microsoft Events | Nov 2025 | 40-min Ignite-deepdive i Agent governance |
| [AI Agents: The Third Pillar of Identity in Microsoft Entra](https://youtu.be/NDa3Jcsi2go) | Reza Sahebi | Mar 2026 | Varför agenter kräver en tredje identitetskategori |
| [Non-Human Identities in Microsoft Entra](https://youtu.be/rLN7WoDLT4U) | Microsoft Cloud IT Pro Podcast | Mar 2026 | NHI-governance och lifecycle i Entra — praktiskt |
| [How to Automate AI Agent Offboarding in Entra ID](https://youtu.be/FJxgFuj_CTk) | Identity Digest | Maj 2026 | Agent lifecycle — offboarding automation (lab) |

## Relaterade notes
- Agent Conditional Access Integration
- Agent Identity Governance
- Agent ID Protection Integration
- Agent Registry Sync
- Agent Global Secure Access Integration
- Entra Suite Index
- Entra Internet Access
- Entitlement Management

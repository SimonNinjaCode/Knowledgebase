---
layout:
  width: wide
domain: m365-e7
title: "DSPM for AI — Data Security Posture Management"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#solutions-architecture", "#ciso", "#dspm", "#data-security"]
sources: []
---

# DSPM for AI — Data Security Posture Management

## Vad är DSPM?

Data Security Posture Management (DSPM) är **synlighet + riskanalys** för data i AI-åldern. Det är inte ytterligare en DLP-motor — det är ett upptäcktslager som svarar på frågorna:

- Var finns vår känsliga data?
- Vem har tillgång till den?
- Vilka AI-tjänster har fått data från oss?
- Vilka risker har vi missat?

## Vilka hål täpper DSPM till?

### 1. Shadow AI — ohanterade AI-tjänster
Anställda använder ChatGPT Free, Claude Free, Gemini, Perplexity — ofta utan ITs vetskap. DSPM upptäcker:
- Domäner som används (chat.openai.com, claude.ai, perplexity.ai)
- Mängden data som skickas till varje tjänst
- Vilka användare som är högrisk-konsumenter

### 2. Överexponerad data i AI-flöden
Klassiska DLP-regler missar data som:
- Finns i SharePoint men är felklassificerad
- Delas via Copilot med "Everyone except external users"
- Finns i en Teams-chat där en AI-agent har access

DSPM hittar överexponering och flaggar den som risk.

### 3. Agentdata — dataflöden från AI-agenter
Agent 365-agenter kan nå data via Graph API. DSPM för AI:
- Kartlägger vilka agenter som har access till vad
- Identifierar over-privileged agents (en agent som kan läsa allt men bara behöver läsa ett team)
- Rekommenderar minsta-privilegium-åtkomst

### 4. Känslig data i uppladdningar till AI
DSPM skannar vilka dokument som laddats upp till externa AI-plattformar:
- Har ett kontrakt med sensitive label laddats upp till Claude?
- Har en källkod med API-nycklar gått till ChatGPT?
- Har en .md-fil med arkitekturbeskrivning gått till en ohanterad AI?

## Shadow AI — den verkliga risken

Shadow AI är oftast större än IT-ledningen tror. DSPM avslöjar:

- **Ohanterade AI-domäner** — ChatGPT Free, Claude Free, Gemini, Perplexity, Poe, You.com
- **Volym och frekvens** — hur mycket data skickas, av vem, till vilken tjänst
- **Högrisk-användare** — personer som regelbundet laddar upp klassificerade dokument till externa AI-tjänster
- **Trendförändringar** — nya AI-tjänster dyker upp. DSPM fångar dem oavsett om IT har en policy

> Netwovens video ["Managing Shadow AI with Microsoft Purview DSPM"](https://youtu.be/-kHhaE_Nn3Y) (6.7K views, 6.43x engagement) är den bästa praktiska genomgången — visar hur DSPM upptäcker ChatGPT, Claude, Gemini och Perplexity-användning i realtid.

## Nytt i Purview DSPM: Data Security Agent (Maj 2026)

Microsoft släppte nyligen en **data security agent** inbyggd i Purview DSPM. Det här ändrar spelplanen:

- Agenten **scannar kontinuerligt** data i M365 (SharePoint, OneDrive, Teams, Exchange)
- **Automatisk riskprioritering** — agenten flaggar inte bara exponerad data, den föreslår åtgärder
- **Integrerad med DLP** — från upptäckt (DSPM) till blockering (DLP) i en pipeline

Detta betyder att gapet mellan DSPM (upptäckt) och DLP (blockering) håller på att slutas — DSPM blir inte längre bara en rapport utan en aktiv del av försvarskedjan.

## DSPM vs DLP — skillnaden (och varför du behöver båda)

|                          | DLP                                    | DSPM                                    |
|--------------------------|----------------------------------------|-----------------------------------------|
| **Primär funktion**      | Blockera data i realtid                | Upptäcka och visualisera risk           |
| **Reagerar**             | På handlingen ("någon laddar upp")     | På tillståndet ("data är exponerad")    |
| **Tidsaspekt**           | Realtid / nära-realtid                 | Kontinuerlig scanning / batch           |
| **Användning**           | Prevention                             | Risk identification + prioritering      |
| **Shadow AI**            | Blockera vid användning                | Upptäcka + kvantifiera                  |
| **Agentövervakning**     | Blockera agentens handlingar           | Visa agentens dataåtkomstmönster        |
| **Agent i kedjan** (nytt) | Reagera på DSPM-agentens varningar    | Data Security Agent scannar + triggar DLP |

## Rekommendation: DSPM + DLP + Agent = komplett skydd

DSPM utan DLP är bara en rapport som ingen agerar på.
DLP utan DSPM är blint — du blockerar det du ser men ser inte det du missar.
Båda utan Purview Data Security Agent är långsamt — upptäckt och blockering är fortfarande separata silos.

```
DSPM Agent: "32 kontrakt ligger i ett öppet SharePoint — klassificerar automatiskt"
DSPM:      "Här är dataexponerad — åtgärda prioriterat"
DLP:       "Någon försöker ladda upp kontrakt till Claude — BLOCKERAT"
```

## Video-resurser (curated)

| Video | Kanal | Datum | Varför? |
|-------|-------|-------|---------|
| [Automate Data Security Triage & Posture \| Agents in Purview](https://youtu.be/BqMFzvk7T38) | Microsoft Mechanics ✓ | Mar 2026 | **Senaste**: DSPM-automatisering med Purview-agenter |
| [Secure and Protect AI Usage with DSPM for AI](https://youtu.be/WFkU9psbRb0) | Microsoft Developer ✓ | Feb 2026 | 680K subs — Microsoft Developer-kanalens DSPM-genomgång |
| [Managing Shadow AI with Microsoft Purview DSPM](https://youtu.be/-kHhaE_Nn3Y) | Netwoven | Okt 2025 | 6.7K views, 6.43x engagement — bästa Shadow AI-specifika videon |
| [Beyond Visibility: Purview Data Security Posture Mgmt \| BRK253](https://youtu.be/MqNgGkXJ5bc) | Microsoft Events | Nov 2025 | 43-min Ignite-session — strategisk och teknisk |
| [Understanding Microsoft Purview DSPM](https://youtu.be/IxEvotm5l3o) | Engage Squared | Feb 2026 | 7.02x engagement — djupteknisk, 62 min |
| [Your Data Security Just Got a Major Upgrade \| New Purview DSPM](https://youtu.be/ZEkU8KlDFrI) | Peter Rising | Jan 2026 | Praktisk walkthrough av nya DSPM-funktioner |
| [New Data Security Posture Management \| Microsoft Purview](https://youtu.be/NLfoFpFxhrA) | Microsoft Mechanics ✓ | Nov 2025 | Introduktion — start här om du är ny på DSPM |
| [Purview DSPM now includes a new data security agent](https://youtu.be/caeNCTO2MWY) | Security Nebula AI | Maj 2026 | Nyaste: Data Security Agent i DSPM |

## Relaterade notes
- Agent Data Security Posture Management
- Agent Data Loss Prevention
- Agent Insider Risk Management
- Data Security & Protection
- Enterprise AI Governance

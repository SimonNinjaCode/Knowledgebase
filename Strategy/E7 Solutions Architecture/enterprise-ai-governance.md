---
domain: m365-e7
title: "Enterprise AI Governance — Multi-Model Security"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#solutions-architecture", "#ciso", "#ai-governance", "#security"]
sources: []
---

# Enterprise AI Governance — Multi-Model Security

## Problembild

Organisationer hamnar snabbt i en **multi-modell-miljö**:

| Plattform | Typ | Dataflöde |
|-----------|-----|-----------|
| Microsoft 365 Copilot | Inbäddad i M365 | Mail, docs, meetings, SharePoint |
| Claude Enterprise (Anthropic) | Fristående SaaS | Uppladdade filer, konversationer |
| ChatGPT Enterprise / Codex (OpenAI) | Fristående SaaS | Kodfiler, dokument, konversationer |
| Copilot Studio / Agent 365 | Anpassade agenter | Företagsdata via Graph-kopplingar |

Problemet: **Varje plattform har sin egen data-boundary.** Copilot respekterar M365 DLP. Men Claude och Codex har egna säkerhetslösningar som inte automatiskt lyder Microsofts policyer.

## Hur skyddar man data över alla plattformar?

### 1. Microsoft Purview som övergripande kontrollplan

Purview fungerar som det **enda policyplanet** för data som lämnar Microsofts ekosystem:

- **DLP-policyer** : Identifierar och blockerar känslig data (PII, finansiell, IP) i realtid — även när den skickas till Copilot, Claude eller Codex via webbläsaren
- **Endpoint DLP** : Fungerar på Windows/Mac oavsett vilken AI-tjänst som används. Fångar copy-paste, filuppladdning och skärmdump
- **Communication Compliance** : Granskar interaktioner med AI-tjänster för insider-risk och policyöverträdelser
- **Information Protection** : Automatisk klassificering och märkning av känsliga dokument — följer med data även utanför M365

### 2. Entra Conditional Access som portvakt

Istället för att lita på varje AI-plattforms egen auth:

- **Session Control** för alla AI-appar — inklusive Claude Enterprise, ChatGPT, Codex, Copilot
- **App Control** : Tvinga session label-begränsningar — data klassad som "Confidential" kan inte laddas upp till externa AI-plattformar
- **Agent ID** : Varje AI-agent (Copilot Studio, anpassade) får en workload-identitet med egna policyer

### 3. Data Loss Prevention för AI-kanaler

Purview DLP har AI-specifika regler:

- **Prompts** : Blockera om prompten innehåller känslig data
- **Responses** : Blockera om AI-svaret exponerar data från känsliga källor
- **Filuppladdning** : Blockera .docx, .pdf, .md med känslig klassificering från att laddas upp till Claude/Codex
- **Copy-paste** : Förhindra kopiering från känsliga dokument till AI-webbläsar-gränssnittet

## Specifikt för dokumenttyper

| Filtyp | Risk | Skyddsmekanism |
|--------|------|-----------------|
| **DOCX** | Office-filer kan innehålla dold metadata, tracked changes, embedded objects | Purview Information Protection + Endpoint DLP + Sensitivity labels |
| **PDF** | Mycket vanlig för uppladdning till Claude/Codex. Kan innehålla PII, kontrakt, IP | Purview klassificerar PDF via auto-labeling. DLP stoppar uppladdning |
| **Markdown (.md)** | Kod-dokumentation, tekniska specar. Lätt att missa som "ofarlig" | Måste ha sensitivity label precis som DOCX/PDF. Policy: inga oklassificerade MD-filer till AI |

## Rekommenderad arkitektur (CISO-nivå)

```
┌─────────────────────────────────────────────────┐
│             Microsoft Purview                    │
│  ┌──────────┬──────────┬──────────────────┐      │
│  │   DLP    │   DSPM   │ Comm Compliance │      │
│  └────┬─────┴────┬─────┴────────┬─────────┘      │
│       │          │               │               │
│       ▼          ▼               ▼               │
│  ┌─────────┐ ┌────────┐ ┌──────────────┐        │
│  │ Endpoint │ │Sensitivity│ │ Auto-labeling│      │
│  │   DLP   │ │ Labels  │ │              │        │
│  └─────────┘ └────────┘ └──────────────┘        │
└─────────────────────┬───────────────────────────┘
                      │
          ┌───────────┴───────────┐
          │                       │
          ▼                       ▼
┌──────────────────┐   ┌──────────────────────┐
│  M365 Copilot    │   │  Claude / Codex /     │
│  (inneboende     │   │  ChatGPT Enterprise   │
│   DLP + Purview) │   │  (Endpoint DLP +      │
│                  │   │   Conditional Access)  │
└──────────────────┘   └──────────────────────┘
```

## Nyckelprincip: Data Boundary Expansion

Microsofts data boundary slutar vid Copilot + M365. För att täcka Claude och Codex krävs:

1. **Endpoint DLP** på alla klienter som når externa AI-plattformar
2. **Nätverkskontroll** (Entra Internet Access) för att styra AI-trafik via en säker gateway
3. **Agent ID / Conditional Access** för att blockera ohanterade enheter från AI-plattformar
4. **Sensitivity labels** som metadata som följer dokumentet — oavsett var det laddas upp

## Kritisk insikt: Model Training & Data Opt-Out

En risk som ofta missas i enterprise-governance: **externa AI-plattformar kan använda din data för model training om du inte explicit optar ut.**

| Plattform | Default | Opt-out | Enterprise-kontroll |
|-----------|---------|---------|---------------------|
| ChatGPT Free / Plus | Data används för training | Settings → Data Controls → opt out | ChatGPT Enterprise: ingen training per default |
| Claude Free / Pro | Data används för training | Account Settings → opt out | Claude Enterprise: ingen training, SOC 2 |
| Gemini | Data används för training | Workspace Admin Console → AI settings | Google Workspace Enterprise: kan stängas av |
| Copilot / M365 | Data används **inte** för training | Krävs inget — inbyggt | Microsofts dataskydd är kontrakterat |

**CISO-rekommendation:** Gör en **opt-out audit** av alla AI-plattformar som används i organisationen. Det räcker inte att ha ett enterprise-avtal — du måste verifiera att model training är avstängd per plattform. Videon [Your Data is training their models — disable this in 5 Minutes](https://youtu.be/926XK2glVo4) visar exakt var inställningarna sitter för varje plattform.

## Video-resurser (curated)

| Video | Kanal | Datum | Varför? |
|-------|-------|-------|---------|
| [AI Assistants Compared: Claude, ChatGPT Enterprise & Copilot](https://youtu.be/GHY2hGrr-9k) | ECI | Apr 2026 | Direkt jämförelse av alla tre — säkerhet, compliance, funktioner |
| [Enterprise AI Compliance: Stop Shadow IT \| Copilot vs ChatGPT vs Claude vs Perplexity](https://youtu.be/a9F48jK6Vhs) | Millennium Business Solutions | Okt 2025 | Praktisk: hur man stoppar Shadow AI i multi-modell-miljö |
| [Is ChatGPT Safe for Work? Enterprise AI Compliance Explained](https://youtu.be/ZvrBNO4VDUk) | CBT Nuggets ✓ | Feb 2026 | 368K subs — compliance-checklista för ChatGPT på jobbet |
| [Is Your AI Stealing Business Secrets? ChatGPT, Claude & Copilot Privacy](https://youtu.be/b7Mz7ZNLoA8) | Profit Minds | Nov 2025 | 6.11x engagement — hur insider-risk ser ut i AI-era |
| [Your Data is training their models — disable this in 5 Minutes](https://youtu.be/926XK2glVo4) | WorkModern | Jan 2026 | **Måste-veta**: hur man optar ut från model training på ChatGPT, Claude, Gemini |
| [Data Security & Compliance for Azure Foundry AI Apps & Agents](https://youtu.be/j3lgwtAOnZU) | Microsoft Security Community | Jan 2026 | Azure Foundry — för utvecklargrupper som rullar egna AI-appar |

## Relaterade notes
- Agent 365 Index
- Copilot Index
- Entra Suite Index
- Agent Comm Compliance
- Agent Data Loss Prevention
- Agent Insider Risk Management
- Agent Conditional Access Integration
- Agent Data Security Posture Management
- Agent ID Protection Integration

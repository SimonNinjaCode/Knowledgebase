---
layout:
  width: wide
domain: m365-e7
title: "Data Security & Protection — M365 E7"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#solutions-architecture", "#ciso", "#data-security", "#purview"]
sources: []
---

# Data Security & Protection

## Förmågor i E7

Microsoft 365 E7 ger tre lager av dataskydd som bygger på varandra:

### 1. Information Protection (klassificering + märkning)
- **Sensitivity labels** — automatisk eller manuell klassificering av dokument baserat på innehåll
- **Auto-labeling** — AI som upptäcker känslig data (PII, finansiell, IP) och märker dokument i realtid
- **Analysdriven** — trainable classifiers som lär sig organisationens unika datatyper

### 2. Data Loss Prevention (blockering)
- **Endpoint DLP** — blockerar på klientnivå: copy-paste, filuppladdning, USB, skärmdump
- **AI-kanal-DLP** — specifika regler för Copilot-prompter, Claude-uppladdningar, ChatGPT-konversationer
- **Klientlös DLP** för moln-appar via Defender for Cloud Apps

### 3. DSPM (synlighet + risk)
- **Data Security Posture Management** — identifierar var känslig data finns, vem som har access, och vilka risker som finns
- **Shadow AI-identifiering** — upptäcker ohanterade AI-appar som anställda använder
- **Data map** — visualiserar dataflöden mellan M365, SaaS-appar och AI-tjänster

## Vad E7 lägger till jämfört med E5

| Förmåga | E5 | E7 |
|---------|----|----|
| Sensitivity labels | ✅ Grundläggande | ✅ Med auto-labeling + trainable classifiers |
| Endpoint DLP | ✅ Ja | ✅ Ja (utökad AI-medveten) |
| DSPM | ❌ Nej | ✅ Fullt DSPM för AI |
| Shadow AI-detektion | ⚠️ Via Defender | ✅ Inbyggt i Purview DSPM |
| Agent DLP | ❌ Nej | ✅ DLP för AI-agent-interaktioner |
| Insider Risk för AI | ❌ Nej | ✅ AI-specifika insider-risk-indikatorer |

## Strategi för CISO: Data-Centric Security

I en AI-värld där data rör sig mellan Copilot, Claude och Codex är perimeter-säkerhet meningslös. Lösningen är **data-centric security**:

1. **Klassificera allt** — om data inte har en sensitivity label, behandlas den som högsta risk
2. **Labeln följer data** — oavsett om den är i OneDrive, uppladdad till Claude, eller inklistrad i ChatGPT
3. **DLP på varje exit-point** — varje kanal där data kan lämna organisationens kontroll måste ha DLP
4. **DSPM ger upptäckt** — DSPM hittar gapen innan de blir läckor

## Video-resurser (curated)

| Video | Kanal | Datum | Varför? |
|-------|-------|-------|---------|
| [Agent 365 \| Controls for Data Security & Compliance](https://youtu.be/CrAJZy7ne3Q) | Microsoft Mechanics ✓ | Maj 2026 | **Senaste**: Purview-styrning av Agent 365-agenter — krävs för att förstå data-boundary för agenter |
| [Data security and governance in the age of AI \| BRK251](https://youtu.be/7FpeYx0f1ck) | Microsoft Events | Nov 2025 | 46 min deep-dive från Ignite: hur Purview anpassas för AI-flöden |
| [Secure Your AI Apps and Agents via Microsoft Purview](https://youtu.be/QiJBK3dqeCs) | Microsoft SLED | Jan 2026 | 49 min med demo — praktisk Purview-konfiguration för AI |
| [Proactive Security with Microsoft Purview (Myth-Busting)](https://youtu.be/cIz9J_7COh8) | Microsoft SLED | Mar 2026 | Myter om dataskydd i AI-eran — bra för att övertyga ledning |
| [New Data Security Posture Management \| Microsoft Purview](https://youtu.be/NLfoFpFxhrA) | Microsoft Mechanics ✓ | Nov 2025 | Introduktion till Purview DSPM |

## Relaterade notes
- Agent Data Loss Prevention
- Agent Data Security Posture Management
- Agent Information Protection Integration
- Agent Insider Risk Management
- Copilot Index

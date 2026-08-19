---
domain: m365-e7
title: "Device & Endpoint Protection — M365 E7"
created: 2026-05-30
updated: 2026-06-17
type: concept
tags: ["#m365-e7", "#solutions-architecture", "#ciso", "#device", "#defender"]
sources: []
corrected: 2026-06-17 — Entra Internet Access och SharePoint Advanced Management är inte E7-specifika; se anmärkning
---

# Device & Endpoint Protection

## Rollen i E7

I en AI-tät organisation är **slutanvändarens enhet** ofta den svagaste punkten. E7 inkluderar Defender-sviten fullt ut samt utökad endpoint-övervakning specifik för AI-interaktioner.

> **⚠️ Anmärkning om licensjämförelser:** MSLearn publicerar ingen officiell E5 vs E7-jämförelsetabell. Tabellen nedan är en **konceptuell analys** baserad på tillgänglig dokumentation. Flera förmågor som ofta associeras med E7 (Entra Internet Access, SharePoint Advanced Management) är i själva verket separata tillägg eller del av Microsoft Entra Suite — inte E7-exklusiva funktioner. Se källhänvisningarna för varje rad.

## Vad E7 ger utöver E5 för endpoint

| Förmåga | E5 | E7 / Tillägg |
|---------|----|-------------|
| Defender for Endpoint P2 | ✅ Ja | ✅ Ja |
| Defender for Office 365 P2 | ✅ Ja | ✅ Ja |
| Endpoint DLP för AI | ⚠️ Grundläggande | ✅ Utökad med AI-kanaler |
| Defender for Cloud Apps | ✅ Ja | ✅ Utökad för agenter |
| Entra Internet Access (klient) | ❌ Nej | ✅ Ingår i Entra Suite (kräver Entra ID P1) — inte E7-specifik |
| SharePoint Advanced Management | ❌ Nej | ✅ Separat add-on (SAM Plan 1) eller ingår i M365 Copilot-licens — inte E7-specifik |

## Strategi: Enheten som sista försvarslinje

DLP i molnet stoppar data vid uppladdning till Copilot. **Endpoint DLP** stoppar data som redan är på väg ut:

### 1. Copy-paste-skydd
När en användare kopierar text från ett klassificerat dokument till Claude eller ChatGPT:

- Endpoint DLP upptäcker att källan har sensitivity label "Confidential"
- Blockering: meddelande till användaren + logg till compliance
- Alternativ: allow with justification (audited)

### 2. Filuppladdningskontroll
När en användare drar en .docx eller .pdf till claude.ai:

- Endpoint DLP läser filens sensitivity label
- Om Confidential eller högre: blockera uppladdning
- Om Internal: logga och tillåt

### 3. Skärmdumpskontroll
- Identifierar när användare tar skärmdump av AI-konversationer
- Blockera om konversationen innehåller klassificerad data

## AI-klientövervakning

Defender for Endpoint + Defender for Cloud Apps ger synlighet på klientnivå:

| Aktivitet | Detekteras |
|-----------|-----------|
| Åtkomst till ChatGPT/Claude från ohanterad enhet | Defender for Cloud Apps |
| Stor datamängd inklistrad i AI-tjänst | Endpoint DLP |
| AI-agent som körs lokalt på enheten | Defender for Endpoint (ovanliga processer) |
| Anslutning till okänd AI-tjänst | Entra Internet Access (AI-gateway) |

## CISO-insikt: Mac-stöd är inte valbart för AI-arbeten

Om din organisation har utvecklare som använder Claude/Codex på Mac (vilket är standard för AI-utveckling) måste **Endpoint DLP på macOS** vara på plats. Defender for Endpoint för Mac har nu fullt DLP-stöd — inklusive copy-paste- och filuppladdningskontroll.

> Videon [Microsoft Defender For Endpoint For Mac OS](https://youtu.be/tqhM4q1Iph8) (Maj 2026, 198K subs) visar hur Mac-kanalen fungerar — inklusive DLP-policyer som appliceras identiskt på Windows och Mac.

**Rekommendation:** Sätt upp en minimum-standard för alla enheter som når AI-plattformar:
- Intune-ansluten (MDM)
- Defender healthy (senaste definitioner, EDR aktiv)
- Endpoint DLP aktiverad
- Conditional Access som blockerar enheter som inte uppfyller kraven

## Rekommendation: Compliant device som gate

**All AI-åtkomst från icke-compliant devices ska blockeras.**

```
User → Compliant device (Intune enrolled + Defender healthy)
  → Conditional Access: kräver compliant device
  → Entra Internet Access: AI-gateway policy
  → AI-tjänst: Copilot / Claude / Codex
```

Utan compliant device:
```
User → Ohanterad enhet
  → Conditional Access: BLOCKERA (eller begränsa till readonly)
  → Inget AI-tillträde
```

## Video-resurser (curated)

| Video | Kanal | Datum | Varför? |
|-------|-------|-------|---------|
| [M365 E7, Intune and Purview Updates](https://youtu.be/F054yF45tRg) | Cloudy with a Chance of Insights | Mar 2026 | Intune + Purview-updates för AI-enheter |
| [E7 vs E5: Which Microsoft License Do You Actually Need?](https://youtu.be/XN-gM86tOh0) | CRTL+LOL | Mar 2026 | Licens-jämförelse för endpoint-skillnader |
| [Microsoft Defender For Endpoint For Mac OS](https://youtu.be/tqhM4q1Iph8) | JOYATRES TECHNOLOGY | Maj 2026 | **Viktig**: Mac-stöd för endpoint DLP |
| [Data Loss Prevention in Microsoft 365 – Easy Guide](https://youtu.be/VWYeiJ48tQg) | Jonathan Edwards | Jun 2025 | 458K subs, 65.8K views — grundlig DLP-introduktion |
| [Insights from Microsoft Ignite: Your Kick-Start for 2026](https://youtu.be/ZH0umh1T83U) | water IT Security | Jan 2026 | Strategisk — vad Ignite 2025 betyder för endpoint-säkerhet |

## Relaterade notes
- Agent Tool Controls
- Agent Lifecycle Management
- Entra Suite Index
- Entra Internet Access
- Enterprise AI Governance
- Data Security & Protection
- Identity Protection & Zero Trust

---
layout:
  width: wide
domain: agent-365
title: "Defender for AI agents"
type: reference
status: preview
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [security, soc, platform, compliance]
tags: ["#agent-365", "#defender", "#ai-security", "#incident-response"]
sources:
  - https://learn.microsoft.com/en-us/defender-xdr/security-for-ai/ai-agent-detection-protection
  - https://learn.microsoft.com/en-us/defender-xdr/security-for-ai/ai-agent-real-time-protection
---

# Defender for AI agents

Microsoft Defender dokumenterar detektion och utredning av hot mot AI-agenter
som en **Preview**-funktion. Täckningen är scenarioberoende. Microsofts sida
anger bland annat krav på publicerade Foundry-agenter och observability för den
aktuella integrationen. Läs därför inte sidan som ett löfte om att alla
Copilot-, Copilot Studio- eller tredjepartsagenter har samma skydd.

## Vad som ska verifieras

| Kontrollpunkt | Fråga |
|---|---|
| Plattform | Är agenten byggd på och publicerad i en dokumenterad plattform? |
| Telemetri | Kommer nödvändiga agent- och tool-events till Defender? |
| Licens | Är Agent 365 och övriga förutsättningar uppfyllda för tenant och användare? |
| Funktion | Gäller detektion, utredning eller separat runtime protection för scenariot? |
| Process | Vem triagerar alerten och hur stoppas eller återkallas agenten? |

## Säkerhetsflöde

1. Anslut den dokumenterade agentplattformen och aktivera nödvändig telemetri.
2. Kontrollera att agent, ägare, användarkontext och verktyg kan identifieras.
3. Testa en kontrollerad attack- eller policyhändelse i testmiljö.
4. Bekräfta att alert, incident, evidens och eventuell blockering syns i rätt
   Defender-vy.
5. Följ upp täckningsluckor och previewbegränsningar innan produktion.

Detektions- och utredningsfunktioner ska inte blandas ihop med runtime-skydd.
Ett fynd efter en händelse är inte samma sak som en blockering före verkställan.
När runtime protection används, följ den separata Microsoft Learn-sidan och
verifiera exakt vilka agent- och verktygsflöden som stöds.

## Incidentfrågor

- Vilken agentidentitet och vilken användare var inblandad?
- Vilket verktyg, vilken datakälla och vilken åtkomstväg användes?
- Kan agenten blockeras, stoppas eller avvecklas utan att radera bevis?
- Finns audit och retention som täcker utredningens behov?
- Vilka delar av händelsen ligger utanför Microsofts dokumenterade täckning?

## Relaterade knowledgebase-sidor

- [ID Protection](ID-Protection.md)
- [Agent observability](Observability.md)
- [Agent tool controls](Tool-Controls.md)
- [Purview data security and compliance](Purview-AI-Compliance.md)

## Microsoft Learn

- [Detect and investigate threats to AI agents](https://learn.microsoft.com/en-us/defender-xdr/security-for-ai/ai-agent-detection-protection)
- [Protect AI agents in real time](https://learn.microsoft.com/en-us/defender-xdr/security-for-ai/ai-agent-real-time-protection)

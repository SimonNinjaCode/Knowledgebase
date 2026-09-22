---
layout:
  width: wide
domain: agent-365
title: "Agent Map"
type: reference
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [security, platform, compliance, ciso]
tags: ["#agent-365", "#agent-map", "#inventory", "#agent-governance"]
sources:
  - https://learn.microsoft.com/en-us/microsoft-365/admin/manage/agent-map
  - https://learn.microsoft.com/en-us/microsoft-agent-365/overview
---

# Agent Map

Agent Map ger en visuell vy över agentinventeringen i Microsoft 365 admin
center. Använd den för att hitta agent-sprawl, saknade ägare och plattformar
som behöver olika styrning. Det är en inventeringsvy, inte ett bevis på att en
agent är säker eller att dess dataåtkomst är korrekt.

## Användning

1. Öppna **Agents** i Microsoft 365 admin center och välj **All agents** och
   **Map** när funktionen finns i tenantens vy.
2. Filtrera på tillgängliga metadata, till exempel status, publisher, plattform,
   kanal eller datakälla.
3. Öppna agentens detaljer och kontrollera identitet, ägare, åtkomst, verktyg
   och publiceringsstatus.
4. Exportera eller dokumentera fynd med åtgärdsägare och slutdatum.

Microsoft Learn anger att Agent Map är tillgänglig för Copilot-administratörer
med E7 (Agent 365)-licens och rollen Global Administrator eller AI Administrator.
Usage/observability-filter är begränsade av tenantens storlek. **Single Agent
Map** är markerad som Preview och bygger på Agent 365-observability.

## Governancefrågor

- Finns varje agent i ett godkänt användningsfall?
- Har varje autonom agent ägare, sponsor och återkallningsplan?
- Kan inventoryposten kopplas till Entra-identitet, Purview-data och audit?
- Vilka registrerade agenter saknar telemetry, owner eller aktuell review?
- Vilka tredjepartsplattformar ligger utanför Agent Maps täckning?

Funktioner, filter, roller och licensförutsättningar kan ändras. Bekräfta dem i
den aktuella adminvyn och Microsoft Learn innan en procedur blir standard.

## Relaterade knowledgebase-sidor

- [Agent observability](Observability.md)
- [Agent registry sync](Registry-Sync.md)
- [Agent lifecycle management](Lifecycle-Management.md)
- [Agent identity governance](Identity-Governance.md)

## Microsoft Learn

- [Agent Map in the Microsoft 365 admin center](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/agent-map)
- [Overview of Microsoft Agent 365](https://learn.microsoft.com/en-us/microsoft-agent-365/overview)

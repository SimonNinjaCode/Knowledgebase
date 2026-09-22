---
layout:
  width: wide
domain: agent-365
title: "Graph API för Agent 365-registret"
type: reference
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [platform, security, compliance, developers]
tags: ["#agent-365", "#microsoft-graph", "#agent-registry", "#automation"]
sources:
  - https://learn.microsoft.com/en-us/microsoft-agent-365/admin/graph-api
  - https://learn.microsoft.com/en-us/microsoft-agent-365/overview
---

# Graph API för Agent 365-registret

Microsoft dokumenterar Graph API för agentregistret och agentdetaljer. Använd
API:t för att hämta inventering och metadata till governanceflöden, men
behandla registret som en källa bland flera. Ett API-resultat visar inte
automatiskt agentens fulla runtime-, data- eller tool-täckning.

## Lämpliga användningar

- Inventeringsrapport med agent, plattform, ägare och status.
- Kontroll av ownerless eller förändrade poster.
- Underlag till åtkomst-, lifecycle- och riskgranskning.
- Koppling till ett internt register med riskacceptans och slutdatum.

## Säker användning

1. Använd minsta nödvändiga Graph-behörighet och en separat appidentitet.
2. Skydda secrets och rotera dem enligt organisationens standard.
3. Logga läsningar och ändringar av registrydata.
4. Hantera API-fel, fördröjning och previewstatus som kontrollbegränsningar.
5. Jämför registrydata med Entra, Purview, Defender och plattformens egna
   loggar innan en compliancebedömning görs.

Endpointnamn, permission scopes och API-status kan ändras. Läs den aktuella
Graph-referensen innan kod eller automatisering låses.

## Relaterade knowledgebase-sidor

- [Agent Map](agent-map.md)
- [Agent registry sync](Registry-Sync.md)
- [Agent observability](Observability.md)
- [Agent lifecycle management](Lifecycle-Management.md)

## Microsoft Learn

- [Graph API for Agent 365 registry and agent details](https://learn.microsoft.com/en-us/microsoft-agent-365/admin/graph-api)
- [Overview of Microsoft Agent 365](https://learn.microsoft.com/en-us/microsoft-agent-365/overview)

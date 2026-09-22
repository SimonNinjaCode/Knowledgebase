---
layout:
  width: wide
domain: agent-365
title: "Connected platforms: agent registry sync"
type: reference
status: preview
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [security, platform, compliance, procurement]
tags: ["#agent-365", "#agent-registry", "#third-party", "#governance", "#preview"]
sources:
  - https://learn.microsoft.com/en-us/microsoft-agent-365/admin/agent-registry
  - https://learn.microsoft.com/en-us/microsoft-agent-365/overview
---

# Connected platforms: agent registry sync

Connected platforms är en **Preview**-funktion för att ansluta externa
agentplattformar till Agent 365-registret. Den kan ge centralare synlighet, men
importerad metadata är inte samma sak som full säkerhets-, data- eller
runtime-täckning.

## Före anslutning

- Verifiera att plattformen och regionen finns i den aktuella Microsoft-listan.
- Använd en separat service identity och minsta möjliga read/manage-scope.
- Dokumentera secrets, rotation, ägare, incidentkontakt och avtal.
- Bestäm om agenter importeras manuellt eller enligt aktuell syncmodell.
- Kontrollera vilka attribut som faktiskt synkroniseras och hur fel rapporteras.

Microsoft har dokumenterat anslutningar för bland annat AWS Bedrock, Google
Vertex AI, Salesforce Agentforce, Databricks och andra plattformar. Listan och
autentiseringsmetoderna kan ändras; använd admincentrets aktuella val som källa.

## Kontroll efter sync

1. Matcha importerad agent mot plattformens eget register.
2. Lägg till intern ägare, sponsor, dataklass, risk och slutdatum.
3. Kontrollera identitet, tools, datakällor, scopes och telemetri separat.
4. Hantera delvis lyckade eller uteblivna importer som ett governancefynd.
5. Ta bort anslutningen och återkalla credentials när behovet upphör.

Previewstatus och supplemental terms gör funktionen olämplig som enda
produktionskontroll. Använd den tillsammans med plattformens egna loggar,
Entra, Purview, Defender och ett manuellt kontrollspår.

## Relaterade knowledgebase-sidor

- [Agent Map](agent-map.md)
- [Graph API för Agent 365-registret](Graph-API.md)
- [Agent lifecycle management](Lifecycle-Management.md)
- [Agent observability](Observability.md)

## Microsoft Learn

- [Connected platforms and agent registry](https://learn.microsoft.com/en-us/microsoft-agent-365/admin/agent-registry)
- [Overview of Microsoft Agent 365](https://learn.microsoft.com/en-us/microsoft-agent-365/overview)

---
layout:
  width: wide
domain: agent-365
title: "Agent tool controls"
type: reference
status: preview
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [security, platform, identity, soc]
tags: ["#agent-365", "#mcp", "#agent-tools", "#least-privilege", "#governance"]
sources:
  - https://learn.microsoft.com/en-us/microsoft-365/admin/manage/manage-tools-for-agent
  - https://learn.microsoft.com/en-us/defender-xdr/security-for-ai/ai-agent-detection-protection
---

# Agent tool controls

Agent Tools i Microsoft 365 admin center ger en samlad vy över verktyg som
agenter kan använda. Det är ett governance- och åtkomstlager, inte ett bevis
på att varje verktygsanrop är säkert eller att varje MCP-server har samma
telemetri.

## Kontrollpunkter

| Kontroll | Fråga |
|---|---|
| Inventering | Vilka verktyg, plugins och MCP-servrar finns registrerade? |
| Publisher och ägare | Vem publicerar, äger och supportar verktyget? |
| Scopes och secrets | Vilka data och handlingar kan verktyget nå? Hur roteras credentials? |
| Beslut | Vem godkänner, blockerar eller återaktiverar verktyget? |
| Telemetri | Kan anrop, resultat och fel kopplas till agent och användare? |
| Avveckling | Hur tas ett verktyg bort och hur återkallas åtkomst? |

## Microsoft- och egna MCP-servrar

Microsoft dokumenterar stöd för Microsofts verktyg och ett Bring Your Own MCP-
scenario. BYO MCP är markerat som **Preview** och omfattas av supplemental
terms. Behandla varje server som en separat leverantörs- och åtkomstgranskning.

En rimlig beslutsordning är:

1. Registrera verktyget i den dokumenterade processen.
2. Granska publisher, datakällor, scopes, autentisering och incidentkontakt.
3. Testa med en begränsad agent och testdata.
4. Godkänn med ägare, slutdatum och loggkrav, eller blockera.
5. Följ upp anrop, policyträffar, credentials och ändringar.

## Begränsningar

- Registrystatus betyder inte att verktyget fungerar i alla klienter eller
  agentplattformar.
- BYO MCP-preview ska inte användas som enda kontroll för produktionsdata.
- Ett blockbeslut måste kompletteras med kontroll av alternativa vägar, till
  exempel ett annat verktyg, API eller lokal integration.
- Runtime-detektion och blockering är separata funktioner. Verifiera om
  Defender stöder det aktuella agent- och tool-scenariot.

## Relaterade knowledgebase-sidor

- [Agent policy templates](Policy-Templates.md)
- [Agent lifecycle management](Lifecycle-Management.md)
- [Agent observability](Observability.md)
- [Defender for AI agents](Defender-Integration.md)

## Microsoft Learn

- [Manage tools for agents](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/manage-tools-for-agent)
- [Detect and investigate threats to AI agents](https://learn.microsoft.com/en-us/defender-xdr/security-for-ai/ai-agent-detection-protection)

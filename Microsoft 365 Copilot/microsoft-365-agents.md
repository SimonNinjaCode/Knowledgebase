---
layout:
  width: wide
domain: m365-copilot
title: "Agenter i Microsoft 365: admin- och governanceöversikt"
type: reference
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [ciso, security, m365-admin, platform, compliance]
tags: ["#microsoft-365-copilot", "#agents", "#agent-governance", "#purview", "#entra"]
sources:
  - https://learn.microsoft.com/en-us/microsoft-365/copilot/agent-essentials/m365-agents-admin-guide
  - https://learn.microsoft.com/en-us/microsoft-365/copilot/agent-essentials/m365-agents-faq
  - https://learn.microsoft.com/en-us/microsoft-agent-365/overview
---

# Agenter i Microsoft 365: admin- och governanceöversikt

Microsoft 365-agenter kan vara deklarativa agenter som använder Copilots
infrastruktur eller custom engine agents som körs utanför Microsoft 365.
Skillnaden påverkar identitet, datagräns, telemetri, publicering och vilka
kontroller som kan verkställas.

## Governance som admin ska dokumentera

- Agenttyp, plattform, ägare, sponsor och målgrupp.
- Datakällor, behörigheter, connectors, actions och verktyg.
- Publiceringskanal, delningsmodell och eventuella externa mottagare.
- Conditional Access, Purview, audit, DLP och lifecycle-kontroller.
- Test för prompt injection, överdelning, felaktiga scopes och avveckling.

Microsofts admin guide pekar på Microsoft 365 admin center, Copilot controls,
Purview och Power Platform som separata delar av governance. Agent 365 är den
centrala kontrollplanet för stödda agentidentiteter, policy och observability;
det ändrar inte ansvarsfördelningen mellan plattformarna.

## Säkerhetsprincip

En agent ska behandlas som en åtkomstväg till data och verktyg. Börja med
minsta privilegium, ägare och revisionsspår. Lägg till användarproduktivitet
först när kontrollmålet är tydligt och testat.

## Microsoft Learn

- [Agents admin guide for Microsoft 365](https://learn.microsoft.com/en-us/microsoft-365/copilot/agent-essentials/m365-agents-admin-guide)
- [Agents FAQ for Microsoft 365](https://learn.microsoft.com/en-us/microsoft-365/copilot/agent-essentials/m365-agents-faq)
- [Overview of Microsoft Agent 365](https://learn.microsoft.com/en-us/microsoft-agent-365/overview)

## Relaterade knowledgebase-sidor

- [Microsoft 365 Copilot: security and governance](copilot-index.md)
- [Microsoft Agent 365](../Agent%20365/README.md)
- [Copilot Studio: security and governance](copilot-studio-for-microsoft-365.md)

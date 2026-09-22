---
layout:
  width: wide
domain: m365-e7
title: "Enterprise AI-governance: Microsoft 365 och extern AI"
type: concept
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [ciso, security, compliance, architecture, procurement]
tags: ["#m365-e7", "#ai-governance", "#zero-trust", "#data-security", "#third-party-risk"]
sources:
  - https://learn.microsoft.com/en-us/microsoft-365/copilot/security-microsoft-365-copilot
  - https://learn.microsoft.com/en-us/microsoft-365/copilot/copilot-controls/security-governance
  - https://learn.microsoft.com/en-us/purview/ai-m365-copilot
  - https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-agent-365/microsoft-agent-365
---

# Enterprise AI-governance: Microsoft 365 och extern AI

En organisation kan ha Microsoft 365 Copilot, Copilot Studio, Agent 365 och
externa AI-tjänster samtidigt. De har olika identiteter, datagränser,
telemetri, avtalsvillkor och kontrollmöjligheter. Governance måste därför
beskriva gränserna i stället för att anta en enda universell policy.

## Kontrollmodell

| Lager | Microsoft 365 och stödda agentscenarier | Externa AI-tjänster |
|---|---|---|
| Identitet | Entra, Conditional Access, Agent ID och livscykel | SSO, federation, lokal identitet och leverantörens service principals |
| Data | M365-behörigheter, Purview labels, DLP, audit, retention och eDiscovery | Leverantörens data controls, Endpoint DLP, Cloud Apps och avtalskrav |
| Agent/verktyg | Agent 365 inventory, policy, tool controls och livscykel där stödet finns | Plattformens registry, API/MCP-behörigheter, secrets och loggar |
| Hot | Defender-detektion och utredning för dokumenterade scenarier | Leverantörens detektion plus endpoint-, nätverks- och SOC-kontroller |
| Bevis | Unified audit, Purview och dokumenterad policytestning | Avtal, adminloggar, exporttest och bevarandekrav |

Microsoft 365 Copilot använder innehåll som den inloggade användaren har rätt
att läsa och ärver relevanta M365-skydd. Det betyder inte att samma skydd
automatiskt gäller när en användare kopierar eller laddar upp innehåll till en
extern tjänst.

## Minimimodell för varje AI-tjänst

Dokumentera följande innan tjänsten tillåts för företagsdata:

1. Ägare, användningsfall, dataklasser och berörda användare.
2. Identitetsflöde, MFA, Conditional Access, service accounts och secrets.
3. Var prompts, svar, filer, embeddings och auditloggar lagras.
4. Om leverantören använder data för träning, och vilket avtal eller vilken
   inställning som styr detta.
5. DLP-, endpoint-, webbsessions- och nätverkskontroller för den faktiska
   kanalen.
6. Incidentkontakt, exportmöjlighet, retention och avvecklingsplan.

Detta är en governance-rekommendation. Leverantörens standardinställning och
avtal måste verifieras separat och får inte fyllas i från antaganden.

## Särskilda risker med agentflöden

- En delegerad agent kan få behörighet i användarens kontext. Testa OBO och
  skriv ned om Conditional Access utvärderar användaren eller agenten.
- En autonom agent behöver egen identitet, ägare, sponsor, verktygslista,
  datakällor och livscykel.
- MCP- och API-verktyg är nya åtkomstvägar. Tillåt bara definierade verktyg,
  minimala scopes och roterade credentials.
- En agentinventering eller ett dashboardvärde är inte bevis på att varje
  tredjepartsagent har telemetri eller runtime-skydd.

## Beslutsgrind

```text
Tjänst och användningsfall
  → data- och identitetsklassning
  → leverantörs- och avtalsgranskning
  → kontrolltest för åtkomst, DLP, audit och avveckling
  → godkänd scope eller blockerad tjänst
  → återkommande risk- och releasegranskning
```

## Microsoft Learn

- [Security for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/microsoft-365/copilot/security-microsoft-365-copilot)
- [Copilot controls: security and governance](https://learn.microsoft.com/en-us/microsoft-365/copilot/copilot-controls/security-governance)
- [Purview protections for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/purview/ai-m365-copilot)
- [Microsoft Agent 365 service description](https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-agent-365/microsoft-agent-365)

## Relaterade knowledgebase-sidor

- [Microsoft 365 E7: security and governance overview](../m365-e7-overview.md)
- [Data security and protection](data-security.md)
- [Identity Protection & Zero Trust](identity-protection.md)
- [Microsoft Agent 365](../../Agent%20365/README.md)
- [Microsoft 365 Copilot: security and governance](../../Microsoft%20365%20Copilot/copilot-index.md)

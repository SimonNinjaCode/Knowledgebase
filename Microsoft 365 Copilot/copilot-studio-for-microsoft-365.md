---
layout:
  width: wide
domain: m365-copilot
title: "Copilot Studio: security and governance"
type: reference
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [ciso, security, platform, compliance, power-platform-admin]
tags: ["#microsoft-365-copilot", "#copilot-studio", "#agent-governance", "#dlp", "#purview"]
sources:
  - https://learn.microsoft.com/microsoft-copilot-studio/security-and-governance
  - https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-agent-365/microsoft-agent-365
---

# Copilot Studio: security and governance

Copilot Studio har egna säkerhets- och governancekontroller i Power Platform.
Microsoft Agent 365 kan komplettera med central inventering, agentidentiteter,
observability och policy för Copilot Studio-agenter. De två kontrollplanen ska
beskrivas tillsammans, men de är inte samma tjänst.

## Kontroller att bedöma

- Data policies för autentisering, knowledge sources, connectors, actions,
  skills, HTTP requests, publiceringskanaler och triggers.
- Maker- och admin-audit i Purview och Sentinel.
- Säkerhetsskanning och riskbedömning före publicering.
- Environment routing och separerade miljöer för utveckling och produktion.
- Sensitivity labels för SharePoint-källor och user credentials där det stöds.
- Customer-managed keys (CMK), data residency och kontroll över data movement.
- Agent 365 för Entra-identitet, Conditional Access, access governance och
  central observability där organisationen har tjänsten.

## Rekommenderad releasegrind

1. Klassificera användningsfall, datakällor, verktyg och publiceringskanaler.
2. Lägg restriktiva data policies på miljö- och tenantnivå.
3. Kör security scan och manuella test för prompt injection, dataexfiltration,
   felaktiga behörigheter och tool calls.
4. Kräv ägare, sponsor, loggning och återställningsplan.
5. Publicera först efter godkänd test, begränsad målgrupp och definierat
   slutdatum.
6. Följ upp audit, connector dependencies, policyändringar och användning.

## Viktig begränsning

Customer Lockbox täcker inte all utgående telemetri från Copilot Studio.
Microsoft anger att vissa Purview-audit- och Agent 365-governancehändelser
hanteras i separata pipelines. Dokumentera därför var revisionsbevis och
retention faktiskt finns.

## Microsoft Learn

- [Key concepts: Copilot Studio security and governance](https://learn.microsoft.com/microsoft-copilot-studio/security-and-governance)
- [Microsoft Agent 365 overview](https://learn.microsoft.com/en-us/microsoft-agent-365/overview)
- [Microsoft Agent 365 service description](https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-agent-365/microsoft-agent-365)

## Relaterade knowledgebase-sidor

- [Microsoft 365 Copilot: security and governance](copilot-index.md)
- [Microsoft Agent 365](../Agent%20365/README.md)
- [Enterprise AI Governance](../Strategy/E7%20Solutions%20Architecture/enterprise-ai-governance.md)

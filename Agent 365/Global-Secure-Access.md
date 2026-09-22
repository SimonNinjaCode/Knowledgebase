---
layout:
  width: wide
domain: agent-365
title: "Global Secure Access för Copilot Studio-agenter"
type: reference
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [security, network, platform, identity]
tags: ["#agent-365", "#global-secure-access", "#copilot-studio", "#network-security"]
sources:
  - https://learn.microsoft.com/en-us/entra/global-secure-access/concept-secure-web-ai-gateway-agents
  - https://learn.microsoft.com/en-us/microsoft-agent-365/overview
---

# Global Secure Access för Copilot Studio-agenter

Microsoft dokumenterar Secure Web and AI Gateway för **Copilot Studio-agenter**.
Det är en nätverkskontroll för ett specifikt trafikscenario, inte en generell
gateway för alla Agent 365-agenter eller externa AI-tjänster.

## Kontrollflöde

1. Kontrollera att agentens Power Platform-miljö och trafiktyp stöds.
2. Konfigurera den dokumenterade trafikforwardingen och nätverkspolicyn.
3. Testa åtkomst till webbresurser, connectors och MCP där de ingår.
4. Följ upp blockeringar, tillåtanden och loggar i nätverks- och
   säkerhetsprocessen.

## Arkitekturbeslut

- Vilken agent, miljö och utgående trafik omfattas?
- Vilken identitet och vilket nätverksattribut används i beslutet?
- Hur kombineras gatewayregeln med Entra Conditional Access, Purview och
  leverantörens egna kontroller?
- Vad händer när agenten använder en annan connector eller ett annat verktyg?

Entra Suite och Agent 365 har separata licens- och förutsättningsfrågor. Bekräfta
aktuell entitlement och regionstöd i Microsoft Learn och Product Terms; lägg
inte in ett statiskt licenslöfte i en design.

## Relaterade knowledgebase-sidor

- [Conditional Access för agentidentiteter](Conditional-Access.md)
- [Agent tool controls](Tool-Controls.md)
- [Defender for AI agents](Defender-Integration.md)
- [Enterprise AI Governance](../Strategy/E7%20Solutions%20Architecture/enterprise-ai-governance.md)

## Microsoft Learn

- [Secure Web and AI Gateway for Copilot Studio agents](https://learn.microsoft.com/en-us/entra/global-secure-access/concept-secure-web-ai-gateway-agents)
- [Overview of Microsoft Agent 365](https://learn.microsoft.com/en-us/microsoft-agent-365/overview)

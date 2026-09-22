---
layout:
  width: wide
domain: agent-365
title: "Purview: data security and compliance for AI agents"
type: reference
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [compliance, security, data-governance, ciso]
tags: ["#agent-365", "#purview", "#dlp", "#audit", "#eDiscovery", "#ai-governance"]
sources:
  - https://learn.microsoft.com/en-us/purview/ai-m365-copilot
  - https://learn.microsoft.com/en-us/purview/ai-microsoft-purview
  - https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-agent-365/microsoft-agent-365
---

# Purview: data security and compliance for AI agents

Microsoft Purview samlar dataskydd och compliancekontroller för Microsoft 365
Copilot och dokumenterade agentscenarier. Agent 365:s tjänstebeskrivning listar
Purviewfunktioner som kan användas för agentstyrning. Stöd och licens ska
verifieras per workload; skriv inte att alla externa LLM:er eller varje lokal
agent omfattas automatiskt.

## Kontrollområden

- Sensitivity labels och encryption för klassificering och rättighetsstyrning.
- DLP för stödda Copilot- och agentinteraktioner.
- Unified audit för prompt-, svar-, åtkomst- och policyhändelser där de loggas.
- Retention, eDiscovery och legal hold för relevant AI-innehåll.
- Communication Compliance och Insider Risk Management där policy och lagkrav
  kräver granskning.
- DSPM och rekommendationer för att hitta data- och åtkomstgap.

## Säkerhetsordning

1. Rensa oversharing och gamla behörigheter i datakällorna.
2. Definiera labels, encryption och administratörsroller.
3. Konfigurera DLP och audit för valda Copilot- och agentscenarier.
4. Lägg till retention, eDiscovery, Communication Compliance och Insider Risk
   efter dokumenterat behov.
5. Testa prompt, svar, skyddat innehåll, OBO och agentens tool calls.
6. Följ upp fynd, undantag och previewstatus.

## Gränser

- Purview tar inte bort befintliga användar- eller agentbehörigheter.
- DSPM är inte samma sak som realtidsblockering i DLP.
- En label följer inte automatiskt med varje copy/paste eller uppladdning till
  en extern tjänst.
- Auditbevis, retention och Lockbox-täckning kan ligga i olika pipelines.

## Relaterade knowledgebase-sidor

- [Agent observability](Observability.md)
- [Agent tool controls](Tool-Controls.md)
- [Data security and protection in Microsoft 365 E7](../Strategy/E7%20Solutions%20Architecture/data-security.md)
- [Microsoft 365 Copilot: security and governance](../Microsoft%20365%20Copilot/copilot-index.md)

## Microsoft Learn

- [Microsoft Purview protections for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/purview/ai-m365-copilot)
- [Microsoft Purview for AI](https://learn.microsoft.com/en-us/purview/ai-microsoft-purview)
- [Microsoft Agent 365 service description](https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-agent-365/microsoft-agent-365)

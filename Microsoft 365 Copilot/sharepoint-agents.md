---
layout:
  width: wide
domain: m365-copilot
title: "Agents in SharePoint: access and governance"
type: reference
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [security, m365-admin, sharepoint-admin, compliance]
tags: ["#microsoft-365-copilot", "#sharepoint", "#agents", "#permissions", "#governance"]
sources:
  - https://learn.microsoft.com/en-us/sharepoint/get-started-sharepoint-agents
  - https://learn.microsoft.com/en-us/sharepoint/manage-access-agents-in-sharepoint
  - https://learn.microsoft.com/en-us/microsoft-365/copilot/security-microsoft-365-copilot
---

# Agents in SharePoint: access and governance

SharePoint-agenter använder SharePoint- och Microsoft 365-behörigheter när de
hämtar innehåll. En användare ska därför inte kunna få mer data genom en agent
än vad användaren redan får läsa. Det gör behörighets- och delningshygien till
den centrala säkerhetskontrollen.

## Tillgänglighet och kostnad

Agenter blir tillgängliga för användare med Microsoft Copilot-licens. En tenant
kan också använda pay-as-you-go för SharePoint-agenter. Billingmodellen ändrar
inte kravet på att granska datakällor, delning och åtkomst.

## Admin-checklista

1. Inventera vilka sajter, bibliotek, sidor och filer agenten får använda.
2. Granska externa länkar, breda grupper och ägare innan agenten delas.
3. Bekräfta att användarens åtkomst ger förväntat resultat i ett testkonto.
4. Följ agentanvändning och audit i SharePoint, Purview och kostnadsrapportering
   där respektive källa stöds.
5. Ta bort eller begränsa agenten när datakällan, ägaren eller användningsfallet
   upphör.

SharePoint-agenten är inte ett frikort runt Purview, Conditional Access eller
organisationens regler för känsligt innehåll. Den är inte heller samma sak som
Agent 365; Agent 365 kan ge central agentinventering och governance för stödda
scenarier.

## Microsoft Learn

- [Get started with agents in SharePoint](https://learn.microsoft.com/en-us/sharepoint/get-started-sharepoint-agents)
- [Manage access to SharePoint agents](https://learn.microsoft.com/en-us/sharepoint/manage-access-agents-in-sharepoint)
- [Security for Microsoft Copilot](https://learn.microsoft.com/en-us/microsoft-365/copilot/security-microsoft-365-copilot)

## Relaterade knowledgebase-sidor

- [Microsoft 365 Copilot: security and governance](copilot-index.md)
- [Data security and protection in Microsoft 365 E7](../Strategy/E7%20Solutions%20Architecture/data-security.md)

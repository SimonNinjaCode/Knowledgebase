---
layout:
  width: wide
domain: agent-365
title: "Agent policy templates"
type: reference
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [security, identity, compliance, platform]
tags: ["#agent-365", "#policy", "#entra", "#governance", "#access-packages"]
sources:
  - https://learn.microsoft.com/en-us/microsoft-agent-365/admin/agent-template
  - https://learn.microsoft.com/en-us/entra/id-governance/agent-id-governance-overview
---

# Agent policy templates

Policy templates samlar återanvändbara governanceinställningar för agenter.
Microsoft skiljer mellan standardtemplates och egna templates. Kontrollera
alltid vilka mallar som finns i den aktuella tenantens admincenter; namn,
förhandsversioner och förutsättningar kan ändras.

## Standardtemplates

Standardtemplates ger en utgångspunkt för återkommande styrning. De ska
granskas och konfigureras innan de behandlas som en säkerhetsbaslinje. Kontroll-
områden kan omfatta agentåtkomst, identitetsattribut, access packages,
lifecycle, data- och compliancekontroller samt kopplingar till Defender och
Purview där Microsoft stöder scenariot.

En standardtemplate betyder inte att varje policy är aktiverad för varje agent
eller att en extern agentplattform omfattas.

## Egna templates

Egna templates kan användas när organisationen behöver en definierad kombination
av exempelvis:

- Conditional Access för en grupp agentidentiteter.
- Access packages och godkännande för agentåtkomst.
- Custom security attributes för att skilja agentklasser åt.

Skapa och testa underliggande Entra-policyer först. Använd separata roller för
policyförvaltning, attributtilldelning och godkännande av åtkomst.

## Livscykel för en template

1. Beskriv kontrollmål, målgrupp, datakällor och undantag.
2. Skapa eller välj underliggande policyer.
3. Testa mot autonom, delegerad och användarliknande agent.
4. Tilldela templaten med minsta möjliga scope.
5. Följ upp träffar, tillåtanden, ägare, ändringar och avveckling.
6. Ändra eller ta bort templaten först efter dokumenterad påverkanstest.

## Granskningsfrågor

- Vilken risk reducerar templaten och vilket bevis visar det?
- Är kontrollen förebyggande, detekterande eller återställande?
- Vilka agenter och plattformar ligger utanför scope?
- Hur hanteras previewfunktioner, undantag och ägarbyte?

## Relaterade knowledgebase-sidor

- [Conditional Access för agentidentiteter](Conditional-Access.md)
- [Agent identity governance](Identity-Governance.md)
- [Agent lifecycle management](Lifecycle-Management.md)
- [Agent observability](Observability.md)

## Microsoft Learn

- [Create and manage agent policy templates](https://learn.microsoft.com/en-us/microsoft-agent-365/admin/agent-template)
- [Microsoft Entra ID Governance for agents](https://learn.microsoft.com/en-us/entra/id-governance/agent-id-governance-overview)

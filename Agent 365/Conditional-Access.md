---
layout:
  width: wide
domain: agent-365
title: "Conditional Access för agentidentiteter"
type: reference
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [security, identity, platform, compliance]
tags: ["#agent-365", "#entra", "#conditional-access", "#agent-id", "#zero-trust"]
sources:
  - https://learn.microsoft.com/en-us/entra/identity/conditional-access/agent-id
  - https://learn.microsoft.com/en-us/entra/agent-id/what-is-microsoft-entra-agent-id
---

# Conditional Access för agentidentiteter

Conditional Access kan användas för agentidentiteter i Microsoft Entra. Den
kontrollerar åtkomst utifrån agentens identitet och definierade signaler, men
beslutet beror på åtkomstmönster och resurs. En policy för en autonom agent kan
inte antas gälla på samma sätt för en delegerad OBO-förfrågan.

## Tre designfrågor

1. Är agenten autonom, delegerad eller användarliknande?
2. Vilken identitet utvärderar resursen: agenten, användaren eller båda?
3. Vilka attribut, risker, scopes, enhets- och nätverkskrav ska leda till
   allow, block eller separat granskning?

Microsoft beskriver blueprint och custom security attributes som sätt att rikta
policyer mot agentidentiteter. Börja med en liten testgrupp och använd minst
privilegium; rikta inte en bred blockpolicy mot ett attribut som inte är
kontrollerat.

## Rekommenderad policystruktur

| Policy | Syfte |
|---|---|
| Baseline | Blockera eller begränsa oregistrerade och ownerless agenter |
| Autonom | Kräv godkänd identitet, scopes, nätverk och dataklass |
| Delegerad | Testa OBO, användarrisk och agentens tillåtna handlingar tillsammans |
| Privilegierad | Separat kontroll för admin- och känsliga datakällor |
| Undantag | Tidsbegränsat, ägt och testat undantag med kompensationskontroll |

Licens- och rollkrav varierar per Conditional Access-, Entra- och Agent 365-
funktion. Använd aktuell dokumentation och Product Terms i stället för en
statisk tabell i knowledgebasen.

## Testfall

- Oregistrerad agent nekas.
- Högriskagent blockeras eller isoleras enligt incidentprocess.
- OBO-anrop får förväntat beslut när användaren är högrisk.
- Blueprint- eller attributändring slår igenom utan oavsiktlig bred åtkomst.
- Återkallad agentidentitet kan inte fortsätta använda sin gamla token eller
  sina verktyg.

## Relaterade knowledgebase-sidor

- [ID Protection för agentidentiteter](ID-Protection.md)
- [Agent identity governance](Identity-Governance.md)
- [Agent policy templates](Policy-Templates.md)
- [Agent lifecycle management](Lifecycle-Management.md)

## Microsoft Learn

- [Conditional Access for agent identities](https://learn.microsoft.com/en-us/entra/identity/conditional-access/agent-id)
- [What is Microsoft Entra Agent ID?](https://learn.microsoft.com/en-us/entra/agent-id/what-is-microsoft-entra-agent-id)

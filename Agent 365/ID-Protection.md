---
layout:
  width: wide
domain: agent-365
title: "ID Protection för agentidentiteter"
type: reference
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [security, identity, soc, compliance]
tags: ["#agent-365", "#entra", "#id-protection", "#conditional-access"]
sources:
  - https://learn.microsoft.com/en-us/entra/id-protection/concept-risky-agents
  - https://learn.microsoft.com/en-us/entra/identity/conditional-access/agent-id
---

# ID Protection för agentidentiteter

Microsoft Entra ID Protection for risky agents is a risk-signal capability for
agent identities in the Entra Agent ID model. The Microsoft Learn article
currently describes the agent detections as **offline**. Treat the result as a
risk input for investigation and Conditional Access, not as a promise of
real-time prevention.

## Viktiga begränsningar

- Entra Agent ID-plattformen är tillgänglig för Entra-kunder.
- Microsofts dokumentation markerar den utökade ID Protection-funktionen för
  agenter som "Starting soon" och anger Agent 365 som förutsättning. Kontrollera
  aktuell Product Terms, featurestatus och tenantens licens före implementation.
- I OBO-flöden kan risken tillskrivas användaren eftersom åtkomsten sker i
  användarens kontext.
- Detections, roller, API-scheman och previewstatus kan ändras. Verifiera mot
  Microsoft Learn före produktionssättning.

## Riskdetektioner

Microsoft listar bland annat bekräftad kompromettering, tidig skadlig aktivitet,
Entra directory reconnaissance, misslyckade åtkomstförsök, sign-in spikes,
suspicious credential usage och ovanlig resursåtkomst. Alla är inte realtids-
detektioner. Läs den aktuella listan och bygg inte en SLA på ett detektionsnamn.

## Använd risk i åtkomstbeslut

1. Definiera vilka agentidentiteter och åtkomstmönster som ingår.
2. Koppla riskfynd till Conditional Access där scenariot stöds.
3. Testa autonom åtkomst och delegerad OBO-åtkomst separat.
4. Blockera eller isolera högriskfall enligt en godkänd incidentprocess.
5. Dokumentera undantag, ägare och hur en agent återställs eller avvecklas.

Ett bra kontrolltest är att visa vilken identitet, riskkälla, policy och
resurs som ledde till beslutet. Ett grönt resultat betyder inte att agenten är
ofarlig eller att databehörigheten är minimal.

## Relaterade knowledgebase-sidor

- [Conditional Access för agentidentiteter](Conditional-Access.md)
- [Agent identity governance](Identity-Governance.md)
- [Agent lifecycle management](Lifecycle-Management.md)
- [Defender integration](Defender-Integration.md)

## Microsoft Learn

- [Risky agents in Microsoft Entra ID Protection](https://learn.microsoft.com/en-us/entra/id-protection/concept-risky-agents)
- [Conditional Access for agent identities](https://learn.microsoft.com/en-us/entra/identity/conditional-access/agent-id)

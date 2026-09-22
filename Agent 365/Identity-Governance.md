---
layout:
  width: wide
domain: agent-365
title: "Identity governance för agenter"
type: reference
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [identity, security, compliance, platform, ciso]
tags: ["#agent-365", "#entra", "#identity-governance", "#lifecycle", "#least-privilege"]
sources:
  - https://learn.microsoft.com/en-us/entra/id-governance/agent-id-governance-overview
  - https://learn.microsoft.com/en-us/entra/agent-id/what-is-microsoft-entra-agent-id
  - https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-license-feature-overview
---

# Identity governance för agenter

Microsoft Entra ID Governance kan användas för agentidentiteter genom Agent ID-
modellen. Governance ska ge en agent samma grunddisciplin som annan
icke-mänsklig identitet: ägare, sponsor, minsta privilegium, access review,
lifecycle och revisionsspår.

## Objekt och ansvar

Microsoft beskriver blueprint, blueprint principal, agent identity och ett
eventuellt agent user-objekt. Mappa varje objekt till en konkret plattform,
ägare och resurs innan åtkomst beviljas. En sponsor ska kunna svara för varför
agenten finns och när den ska tas bort.

## Governancekontroller

- **Entitlement Management:** paketera och godkänn agentens åtkomst.
- **Access Reviews:** ompröva ägare, scopes och datakällor.
- **Lifecycle Workflows:** automatisera onboarding, ändring och offboarding där
  arbetsflödet stöds.
- **Conditional Access:** villkora åtkomst efter agenttyp, attribut och risk.
- **PIM:** hantera tidsbegränsad privilegierad åtkomst där scenariot stöds.

## Licens och scope

Entra Agent ID-plattformen är tillgänglig för Entra-kunder. Microsoft anger att
Microsoft Agent 365 krävs för att utöka Entra-säkerhetsfunktioner till agenter;
E7 innehåller Agent 365 och Entra Suite. Kontrollera tenantens Product Terms,
roller och featurestatus i stället för att använda en statisk E5/E7-tabell.

## Kontrolltest

1. Ny agent saknar sponsor och ska inte nå produktionsdata.
2. Åtkomstpaket kräver rätt godkännare och har slutdatum.
3. Access review tar bort en gammal scope och testet visar att åtkomsten
   verkligen upphör.
4. Ägarbyte, stop och radering lämnar audit och återkallar credentials.
5. Delegerad och autonom åtkomst testas var för sig.

## Relaterade knowledgebase-sidor

- [Conditional Access för agentidentiteter](Conditional-Access.md)
- [ID Protection för agentidentiteter](ID-Protection.md)
- [Agent lifecycle management](Lifecycle-Management.md)
- [Agent policy templates](Policy-Templates.md)

## Microsoft Learn

- [Microsoft Entra ID Governance for agents](https://learn.microsoft.com/en-us/entra/id-governance/agent-id-governance-overview)
- [What is Microsoft Entra Agent ID?](https://learn.microsoft.com/en-us/entra/agent-id/what-is-microsoft-entra-agent-id)
- [Microsoft 365 E3, E5 and E7 feature comparison](https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-license-feature-overview)

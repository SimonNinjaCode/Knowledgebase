---
layout:
  width: wide
domain: m365-e7
title: "Identitetsskydd och Zero Trust i Microsoft 365 E7"
type: concept
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [ciso, security, identity, compliance, architecture]
tags: ["#m365-e7", "#entra", "#agent-id", "#conditional-access", "#zero-trust"]
sources:
  - https://learn.microsoft.com/en-us/entra/agent-id/what-is-microsoft-entra-agent-id
  - https://learn.microsoft.com/en-us/entra/identity/conditional-access/agent-id
  - https://learn.microsoft.com/en-us/entra/id-protection/concept-risky-agents
  - https://learn.microsoft.com/en-us/entra/id-governance/agent-id-governance-overview
  - https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-license-feature-overview
---

# Identitetsskydd och Zero Trust i Microsoft 365 E7

Microsoft Entra Agent ID gör agentidentiteter och blueprints till en del av
Entra-modellen. Plattformen är tillgänglig för Entra-kunder; Microsoft Agent
365 krävs för att utöka Entra-säkerhetsfunktioner till agenter enligt Microsofts
dokumentation. E7 innehåller Agent 365 och Entra Suite, men licensen aktiverar
inte automatiskt någon policy.

## Tre åtkomstmönster

| Mönster | Vad som måste verifieras |
|---|---|
| Autonom agent | Egen identitet, ägare, sponsor, scopes, verktyg, datakällor och slutdatum |
| Delegerad agent | OBO-flöde, användarens risk och behörighet samt agentens tillåtna handlingar |
| Användarliknande agent | Hur agenten presenteras, vilken identitet Conditional Access utvärderar och hur åtkomsten återkallas |

Conditional Access för agentidentiteter har egna begränsningar och villkor.
Microsoft beskriver bland annat att OBO-förfrågningar i vissa flöden bedöms i
användarens kontext. Testa därför både agentens och användarens policyväg.

## Kontrollkedja

1. **Inventera.** Hitta agenter och koppla varje rad till plattform, identitet,
   ägare, sponsor och datakällor.
2. **Minimera.** Ge bara de Graph-, API- och verktygsscopar som användningsfallet
   kräver.
3. **Villkora.** Använd Conditional Access, attribut och access packages där
   scenariot stöds.
4. **Övervaka.** Använd ID Protection och audit för risk, ovanliga mönster och
   policyändringar. Dokumentera previewstatus och offline-detektioner.
5. **Avveckla.** Blockera, stoppa eller ta bort agenten och återkalla secrets
   när ägare, syfte eller avtal upphör.

## Vad E7 faktiskt ändrar

E7 samlar E5, Microsoft 365 Copilot, Agent 365 och Entra Suite. Det gör paketet
intressant när samma population behöver Copilot, agentstyrning och Entra-nät-
eller governancefunktioner. Det är inte bevis på att varje agent, extern SaaS-
tjänst eller Graph-integration får samma skydd. Matcha kontroll mot identitet,
plattform och licens.

## Testfall före produktion

- Autonom agent utan sponsor ska nekas eller hamna i undantagsflöde.
- Delegerad OBO-förfrågan ska ge förväntat beslut när användaren är högrisk.
- Agenten ska inte kunna använda ett verktyg eller en datakälla utanför sina
  dokumenterade scopes.
- Blockering, ägarbyte, stop/start och radering ska lämna revisionsspår.
- En agent med inaktuell blueprint eller credential ska kunna isoleras snabbt.

## Microsoft Learn

- [What is Microsoft Entra Agent ID?](https://learn.microsoft.com/en-us/entra/agent-id/what-is-microsoft-entra-agent-id)
- [Conditional Access for agent identities](https://learn.microsoft.com/en-us/entra/identity/conditional-access/agent-id)
- [Risky agents in Microsoft Entra ID Protection](https://learn.microsoft.com/en-us/entra/id-protection/concept-risky-agents)
- [Microsoft Entra ID Governance for agents](https://learn.microsoft.com/en-us/entra/id-governance/agent-id-governance-overview)
- [Microsoft 365 E3, E5 and E7 feature comparison](https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-license-feature-overview)

## Relaterade knowledgebase-sidor

- [Microsoft Agent 365](../../Agent%20365/README.md)
- [Microsoft 365 E7: security and governance overview](../m365-e7-overview.md)
- [Enterprise AI Governance](enterprise-ai-governance.md)

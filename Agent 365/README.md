---
layout:
  width: wide
domain: agent-365
title: "Microsoft Agent 365"
type: index
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [ciso, security, identity, compliance, platform]
tags: ["#agent-365", "#agent-governance", "#entra", "#purview", "#defender"]
sources:
  - https://learn.microsoft.com/en-us/microsoft-agent-365/overview
  - https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-agent-365/microsoft-agent-365
  - https://learn.microsoft.com/en-us/entra/agent-id/what-is-microsoft-entra-agent-id
---

# Microsoft Agent 365

Microsoft Agent 365 är Microsofts centrala kontrollplan för AI-agenter. Den
samlar inventering, styrning och säkerhetsintegrationer för Microsoft-agenter och
stödda agenter från andra plattformar.

Microsoft beskriver tjänsten i tre funktioner:

- **Observe:** inventering, aktivitet och hälsa i ett centralt register.
- **Govern:** livscykel, åtkomst, policy och compliance.
- **Secure:** Entra, Purview, Defender och Intune för identitet, data, nätverk
  och stödda runtime-scenarier.

Agent 365 gör inte en agent tillförlitlig av sig själv. Tenantens ägare måste
fortfarande definiera minsta privilegium, datagränser, övervakning och
avveckling.

## Agent 365 och Microsoft Entra Agent ID

De hänger ihop men är olika delar:

| Del | Roll |
|---|---|
| Microsoft Entra Agent ID | Identitetsramverk för agentidentiteter och blueprints. Plattformen är tillgänglig för Entra-kunder. |
| Microsoft Agent 365 | M365-kontrollplan med agentinventering, governance och säkerhetsintegrationer. Ingår i Microsoft 365 E7 och finns även som separat tjänst för berättigade prenumerationer. |
| Microsoft 365 admin center | Yta för Agent Registry, livscykelåtgärder, policytemplates och Agent Tools. |
| Entra- och Purview-portaler | Ytor för identitet, åtkomst, data, compliance och livscykel. |

Microsoft anger att ett kvalificerat Agent 365-entitlement krävs för att utöka
Entra-säkerhets- och governancefunktioner till agentidentiteter. Kontrollera
aktuell tjänstebeskrivning och Product Terms före inköp eller design.

## Förmågekarta

| Kontrollområde | Förmåga | Vad som ska dokumenteras |
|---|---|---|
| Inventering | Agent Registry och Agent Map | Agent, publisher, plattform, ägare och status |
| Livscykel | Install, uninstall, block, unblock, delete, ägarbyte och distribution | Scope, godkännare, slutdatum och återkallning |
| Policy | Policytemplates och villkorsstyrda livscykelregler | Underliggande policy, undantag och testfall |
| Identitet | Agentidentiteter, blueprints, sponsorer och auditdata | Identitetsmönster och minsta scopes |
| Åtkomst | Conditional Access, riskvillkor, access packages och security attributes | Autonom, delegerad eller användarliknande åtkomst |
| Hot | Defender-detektion och utredning samt previewbaserat runtime-skydd | Plattform, publicering, telemetri och begränsningar |
| Data | Purview labels, DLP, audit, eDiscovery, retention och riskkontroller | Datakällor, policyer och revisionsbevis |
| Nätverk | Secure Web and AI Gateway för stödd Copilot Studio-trafik | Trafikmodell, region och policy |
| Verktyg | Register för Microsoft- och BYO MCP-servrar | Publisher, scopes, secrets, beslut och loggar |
| Externa plattformar | Connected platforms för stödda agentregister | Autentisering, synkstatus och plattformens egna loggar |
| Automation | Graph-åtkomst till registrymetadata | API-version, scopes, felhantering och ändringsspår |

Tjänstebeskrivningen skiljer mellan grundläggande inventering och mer avancerade
funktioner. Policytemplates, observability, Agent Tools, Graph, access packages,
Entra-, Purview- och Defender-kontroller listas för Microsoft 365 E7 och den
separata Agent 365-tjänsten. Verifiera alltid den aktuella funktionsmatrisen.

## Säkerhets- och governanceprocess

### 1. Upptäck

Använd Agent Registry och Agent Map för att hitta agenter, publishers,
plattformar, ägare, identiteter, verktyg, datakällor och publiceringskanaler.
Ta med anslutna externa register där stödet finns.

### 2. Utse ansvar

Varje agent ska ha en mänsklig ägare eller sponsor som kan svara för syfte,
data, testning, åtkomst och avveckling. Ownerless är ett governancefynd.

### 3. Begränsa identitet och åtkomst

Använd Agent ID, Conditional Access, riskvillkor, access packages och custom
security attributes där scenariot stöds. Modellera åtkomstmönstret först:

- En autonom agent agerar som sig själv.
- En delegerad agent använder användarens behörighet och kan bedömas i
  användarens kontext i OBO-flöden.
- En användarliknande agent har en annan identitets- och policygräns.

En Conditional Access-policy för en modell täcker inte automatiskt de andra.

### 4. Skydda data

Använd Purview för labels, encryption, DLP, audit, retention, eDiscovery,
Communication Compliance och Insider Risk Management där stödet finns. Rätta
oversharing och gamla behörigheter innan agentens åtkomst breddas.

### 5. Detektera och hantera

Använd Defender för dokumenterade agentdetektioner och utredningar. Separera
runtime-skydd från efterhandsdetektion. Incidentprocessen ska kunna blockera en
agent, återkalla åtkomst, rotera credentials och bevara bevis.

### 6. Avveckla

Sätt review- eller expiry-datum. Ta bort oanvända agenter, verktyg, anslutningar
och identiteter. Dokumentera om audit- eller affärsdata måste bevaras.

## Microsoft 365 E7

Microsoft 365 E7 innehåller Microsoft 365 Copilot, Microsoft Agent 365 och
Microsoft Entra Suite ovanpå Microsoft 365 E5. Licensen ersätter inte
konfiguration, testning eller separat verifiering av workloads och användare.

Agent 365 finns också separat. Prerequisite-licenser för fristående köp kan
ändras; kontrollera [tjänstebeskrivningen](https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-agent-365/microsoft-agent-365)
och [Product Terms](https://www.microsoft.com/licensing/terms/) för aktuell
tenant och inköpskanal.

## Relaterade artiklar

| Ämne | Artikel |
|---|---|
| Inventering | [Agent Map](agent-map.md) |
| Conditional Access | [Conditional Access för agentidentiteter](Conditional-Access.md) |
| Identitetsrisk | [ID Protection för agentidentiteter](ID-Protection.md) |
| Identity governance | [Identity governance för agenter](Identity-Governance.md) |
| Livscykel | [Agent lifecycle management](Lifecycle-Management.md) |
| Detektion och utredning | [Defender for AI agents](Defender-Integration.md) |
| Nätverk | [Global Secure Access](Global-Secure-Access.md) |
| Data och compliance | [Purview för AI-agenter](Purview-AI-Compliance.md) |
| Observability | [Agent observability](Observability.md) |
| Policy | [Agent policy templates](Policy-Templates.md) |
| Externa plattformar | [Connected platforms](Registry-Sync.md) |
| Verktyg och MCP | [Agent tool controls](Tool-Controls.md) |
| Graph | [Graph API för registret](Graph-API.md) |

## Microsoft Learn

- [Overview of Microsoft Agent 365](https://learn.microsoft.com/en-us/microsoft-agent-365/overview)
- [Microsoft Agent 365 service description](https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-agent-365/microsoft-agent-365)
- [What is Microsoft Entra Agent ID?](https://learn.microsoft.com/en-us/entra/agent-id/what-is-microsoft-entra-agent-id)
- [Agent management in the Microsoft 365 admin center](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/agent-365-overview)
- [Microsoft Entra Agent ID best practices](https://learn.microsoft.com/en-us/entra/agent-id/best-practices-agent-id)
- [Secure and govern Microsoft Copilot agents](https://learn.microsoft.com/en-us/purview/deploymentmodels/depmod-sc-agents-deployment)

## Kontrollfrågor före implementation

- Finns alla agentplattformar och anslutna register i inventeringen?
- Har varje autonom agent ägare, sponsor, syfte och expiry-datum?
- Vilket åtkomstmönster används: autonomt, delegerat eller användarlikt?
- Vilka data, verktyg, MCP-servrar och utgående destinationer nås?
- Vilka Purview- och Defenderkontroller täcker faktiskt plattformen?
- Vem kan blockera, avinstallera, återkalla och utreda agenten?
- Vilka previewfunktioner är förbjudna i produktion?

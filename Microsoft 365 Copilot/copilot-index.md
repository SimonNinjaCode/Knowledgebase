---
layout:
  width: wide
domain: m365-copilot
title: "Microsoft 365 Copilot: säkerhet och governance"
type: index
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [ciso, security, compliance, identity, m365-admin]
tags: ["#microsoft-365-copilot", "#copilot", "#ai-governance", "#purview", "#security"]
sources:
  - https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-architecture
  - https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-architecture-data-protection-auditing
  - https://learn.microsoft.com/en-us/microsoft-365/copilot/copilot-controls/security-governance
  - https://learn.microsoft.com/en-us/purview/ai-m365-copilot
---

# Microsoft 365 Copilot: säkerhet och governance

Microsoft 365 Copilot använder användarens prompt, aktuell M365-kontext och
data som den inloggade användaren redan har rätt att läsa. Tjänstegränsen ger
inte tenant-omfattande åtkomst och reparerar inte överdelat innehåll.

Säkerhetsfrågan är därför:

1. Vilken identitet frågar?
2. Vilka data får identiteten läsa?
3. Vilka data får Copilot bearbeta, returnera eller behålla?
4. Vilka interaktioner och adminhändelser ska upptäckas, granskas och utredas?

## Säkerhetsgränser

| Gräns | Microsofts dokumentation | Governancekonsekvens |
|---|---|---|
| Identitet | Copilot följer M365-identitet, Conditional Access och MFA. | Säkra användare, enhet och session före AI-åtkomst. |
| Auktorisering | Copilot hämtar bara innehåll som den inloggade användaren får läsa. | SharePoint-, OneDrive-, Exchange-, Teams- och Graph-behörigheter är avgörande. |
| Dataskydd | Labels, encryption och usage rights gäller i stödda groundingflöden. | `VIEW` och `EXTRACT` behövs för krypterat innehåll. |
| Tjänstegräns | Kunddata hanteras inom Microsoft Copilots dokumenterade tjänstegräns. | Generalisera inte gränsen till externa modeller, connectors eller agenter. |
| Compliance | Prompt, svar, refererade filer och labels kan ge audit- och complianceposter. | Definiera retention, åtkomst till bevis och utredning före utrullning. |
| Output | Copilot genererar sannolikhetsbaserat innehåll som kan vara fel eller ofullständigt. | Mänsklig granskning krävs för viktiga beslut och extern kommunikation. |

Se [Copilot-arkitekturen](https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-architecture)
och [dataskydd och audit](https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-architecture-data-protection-auditing).

## Purview-kontroller för Copilot

Microsoft Purview dokumenterar följande kapabiliteter för Microsoft 365 Copilot
och Copilot Chat:

| Purview-kapabilitet | Säkerhets- och governanceanvändning |
|---|---|
| DSPM och DSPM for AI (classic) | Hitta AI-användning, överdelning och risk; använd rekommendationer där de passar. |
| Sensitivity labels | Klassificera innehåll och föra skyddskontext till stödda Copilotinteraktioner. |
| Encryption och usage rights | Hindra användning av krypterat innehåll när rättigheter som `VIEW` eller `EXTRACT` saknas. |
| DLP | Inspektera och begränsa känsliga prompts, svar och Copilot-relaterade dataplaceringar där policyn stöds. |
| Audit | Logga Copilotinteraktioner och relaterade händelser i unified audit. |
| Data classification | Identifiera känslig information i stödda AI-prompts och svar. |
| Insider Risk Management | Knyta AI-användning till insider-risk-signaler och utredningar. |
| Communication Compliance | Granska interaktioner mot kommunikationspolicyer där workloaden stöds. |
| eDiscovery | Bevara, söka och utreda Copilotdata där workload och casebehörighet stöds. |
| Data Lifecycle Management | Behålla eller radera interaktionsdata enligt beslutade retentionkrav. |
| Compliance Manager | Följa upp relevanta kontroll- och regelverksmallar. |

En listad kontroll är inte automatiskt aktiverad, rätt scopead eller tillgänglig
i varje licens och workload. Verifiera policyplats, roller, actions och
licens före implementation.

Se [Purview protections for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/purview/ai-m365-copilot)
och [Purview permissions](https://learn.microsoft.com/en-us/purview/purview-permissions).

## Copilot controls-ramverket

Microsoft delar Copilot controls i tre pelare:

1. **Security and governance:** dataskydd, AI-säkerhet, compliance och privacy.
2. **Management controls:** tenantinställningar, åtkomst och rollout.
3. **Measurement and reporting:** användning, adoption, påverkan och risk.

Den här knowledgebasen prioriterar den första pelaren. Adoption och ROI är
sekundärt till en försvarbar identitets-, data- och compliancegräns.

Se [Copilot controls: security and governance](https://learn.microsoft.com/en-us/microsoft-365/copilot/copilot-controls/security-governance).

## Säker utrullning

Det här är en implementationstolkning av Microsofts secure-foundation guidance.

### 1. Scope och ansvar

- Utse service owner, security owner och data owners.
- Bestäm vilka användare, enheter, workloads och miljöer som ingår i piloten.
- Definiera tillåtna, begränsade och förbjudna Copilot- och agentfunktioner.
- Ge varje undantag en beslutsägare och ett slutdatum.

### 2. Rätta datagrunden

- Hitta överdelade SharePoint-sajter, OneDrive-filer och Teams-platser.
- Granska anonyma länkar, breda grupper, gamla gäster och ownerless sites.
- Använd labels och encryption där verksamheten behöver en verklig
  skyddsgräns.
- Prioritera åtgärder med SharePoint Advanced Management och Purview.

### 3. Konfigurera kontroller

- Kräv stark identitet, Conditional Access och compliant device enligt policy.
- Aktivera Purview audit och definiera vem som får se prompts, svar och bevis.
- Konfigurera DLP för stödda Copilot- och Copilot Chat-locations.
- Definiera retention, eDiscovery, Communication Compliance och Insider Risk.
- Sätt separata guardrails för agenter, connectors och externa AI-appar.

### 4. Pilota med evidens

- Använd representativa känsliga sajter, användare, appar och enheter.
- Testa allow och deny, krypterat och label-skyddat innehåll, DLP och audit.
- Logga falska positiva, saknad telemetri och workloads utan stöd.
- Ett lyckat svar från Copilot är inte bevis på en säker datamodell.

### 5. Driv och granska

- Följ Copilot security dashboard och dataexponering på fast frekvens.
- Utred avvikande eller policystridiga interaktioner.
- Bevaka ändringar i permissions, labels, connectors och agentpublicering.
- Läs release notes, licensvillkor och workloadstöd inför varje större våg.

Se [Configure a secure and governed foundation for Microsoft Copilot](https://learn.microsoft.com/en-us/microsoft-365/copilot/configure-secure-governed-data-foundation-microsoft-365-copilot).

## Licensorientering

Licensbeslutet är separat från säkerhetsdesignen:

| Prenumeration | Copilotposition |
|---|---|
| Microsoft 365 E3 | Microsoft Copilot kan köpas som add-on, med förutsättningar. |
| Microsoft 365 E5 | Microsoft Copilot kan köpas som add-on; E5 har säkerhets- och compliancebasen. |
| Microsoft 365 E7 | Microsoft Copilot ingår tillsammans med Entra Suite och Agent 365. |
| M365 utan Copilot-entitlement | Copilot Chat och agentåtkomst beror på tenant, licens och billingmodell. |

Detta är orientering, inte kontrakt. Kontrollera [Copilot-licenser](https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-licensing),
[service description](https://learn.microsoft.com/en-us/office365/servicedescriptions/office-365-platform-service-description/microsoft-365-copilot)
och tenantens Product Terms.

## Copilot, agenter och connectors

| Objekt | Primär kontrollplan | Huvudfråga |
|---|---|---|
| Microsoft 365 Copilot | M365, Entra, Purview och SharePoint | Får användaren mer data än avsett? |
| M365 prebuilt/declarative agents | M365 admin center, Copilot och Purview | Vem godkände publicering, knowledge och expiry? |
| Copilot Studio-agenter | Power Platform, Agent 365, Entra, Purview och Defender | Vilka identiteter, connectors, verktyg och miljöer används? |
| Synced Copilot connectors | Graph external items och connector permissions | Vad kopieras och indexeras, och bevaras externa ACL? |
| Federated connectors | Connector- eller MCP-tjänst vid runtime | Vilka data lämnar källan och hur styrs tjänsten? |

Se [Graph och connectors](graph-and-connector-access.md), [M365-agenter](microsoft-365-agents.md),
[SharePoint-agenter](sharepoint-agents.md) och [Agent 365](../Agent%20365/README.md).

## Governancekarta

| Ämne | Knowledgebase-artikel |
|---|---|
| Dataåtkomst och permissions | [Copilotarkitektur och dataskydd](https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-architecture-data-protection-auditing) |
| Begränsa datadiscovery | [Restrict Microsoft 365 Copilot](../Purview/Restrict-M365Copilot.md) |
| Agentlivscykel | [M365-agenter](microsoft-365-agents.md) och [Agent 365](../Agent%20365/README.md) |
| Connectors och extern data | [Graph och connectors](graph-and-connector-access.md) |
| Copilot usage | [Copilot Dashboard](copilot-dashboard.md) |

Appspecifika notes om Word, Excel, Teams och Outlook ligger kvar som
referensmaterial. De ersätter inte säkerhets- och governancekontrollerna ovan.

## Microsoft Learn

- [Microsoft 365 Copilot documentation](https://learn.microsoft.com/en-us/microsoft-365/copilot/)
- [Microsoft Copilot architecture](https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-architecture)
- [Data protection and auditing](https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-architecture-data-protection-auditing)
- [Security for Microsoft Copilot](https://learn.microsoft.com/en-us/microsoft-365/copilot/security-microsoft-365-copilot)
- [Copilot controls: security and governance](https://learn.microsoft.com/en-us/microsoft-365/copilot/copilot-controls/security-governance)
- [Secure and governed data foundation](https://learn.microsoft.com/en-us/microsoft-365/copilot/configure-secure-governed-data-foundation-microsoft-365-copilot)
- [Purview protections for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/purview/ai-m365-copilot)
- [Microsoft Copilot license options](https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-licensing)
- [Microsoft 365 Copilot service description](https://learn.microsoft.com/en-us/office365/servicedescriptions/office-365-platform-service-description/microsoft-365-copilot)

## Kontrollfrågor

- Kan varje pilotanvändare bara läsa den data som faktiskt behövs?
- Vilka SharePoint- och OneDrive-platser är överdelade eller saknar ägare?
- Vilka labels och encryption rights måste fungera under grounding?
- Vem får se prompts, svar och utredningsbevis?
- Vilka DLP-, retention-, eDiscovery-, Communication Compliance- och Insider
  Risk-policyer är aktiverade, testade och scopeade?
- Hur godkänns och avvecklas agenter, connectors och externa AI-tjänster?
- Vad är responsen om Copilot exponerar data genom en gammal behörighet?

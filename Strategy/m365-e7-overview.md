---
layout:
  width: wide
domain: m365-e7
title: "Microsoft 365 E7: säkerhet och governance"
type: concept
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [ciso, security, compliance, identity, procurement]
tags: ["#m365-e7", "#microsoft-365", "#ai-governance", "#security", "#entra", "#purview"]
sources:
  - https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-license-feature-overview
  - https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-agent-365/microsoft-agent-365
  - https://learn.microsoft.com/en-us/partner-center/announcements/2026-may#microsoft-365-e7-and-agent-365-are-now-generally-available
---

# Microsoft 365 E7

Microsoft 365 E7, Frontier Suite, samlar Microsoft 365 E5, Microsoft 365
Copilot, Microsoft Agent 365 och Microsoft Entra Suite i ett enterprise-paket.

Microsoft anger **1 maj 2026** som datum då Microsoft 365 E7 och Agent 365 blev
generally available. Marsmeddelandet var produktlanseringen, inte GA-datumet.

E7 är ett licensentitlement, inte en färdig säkerhetsarkitektur. Paketet
klassificerar inte data, rensar inte SharePoint-behörigheter, registrerar inte
alla agenter och bevisar inte regelefterlevnad utan kundens konfiguration och
kontrollarbete.

## Vad E7 lägger till jämfört med E5

| Område | Microsoft 365 E5 | Microsoft 365 E7 |
|---|---|---|
| Microsoft Copilot | Tillgänglig som add-on | Ingår |
| Microsoft Agent 365 | Ingår inte i E5 | Ingår |
| Microsoft Entra | Entra ID Plan 2 | Entra ID Plan 2 plus Entra Suite |
| Agent identity governance | Separat Agent 365-entitlement och konfiguration | Agent 365 och Entra Suite ingår, med scope- och setupkrav |
| Agent security | E5:s säkerhetsstack för användare, enheter och data | Lägger till dokumenterade Agent 365-kontroller för identitet, säkerhet och governance |
| Purview för Copilot och agenter | E5-kontroller och Copilot-add-on | Copilot och Agent 365-relaterade kontroller enligt aktuell jämförelse |
| Security Copilot | Ingår | Ingår |

Tabellen är en kapabilitetsöversikt, inte ett avtal. Produktnamn,
förutsättningar och entitlement kan ändras oberoende av paketet. Använd den
aktuella [funktionsjämförelsen för Microsoft 365](https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-license-feature-overview)
och [Agent 365:s tjänstebeskrivning](https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-agent-365/microsoft-agent-365)
vid inköp.

## Säkerhetsmodellen

E7 är mest relevant när organisationen behöver styra AI och agenter i större
skala. Kontrollmodellen har fem lager.

### Identitet

Microsoft Entra Agent ID tillhandahåller agentidentiteter och blueprints. Agent
365 och Entra-kontroller kan sedan styra åtkomst, sponsoransvar, livscykel och
risk. Modellera autonoma, delegerade och användarliknande agenter separat.

### Åtkomst

Conditional Access, riskvillkor, access packages, lifecycle workflows och
custom security attributes kan ge minst privilegium för användare och agenter.
OBO-flöden kan bedöma användaren i stället för agenten, så en policy för
autonoma agenter är inte automatiskt rätt för delegerad åtkomst.

### Data

Microsoft Purview tillhandahåller labels, encryption, DLP, audit, retention,
eDiscovery, Communication Compliance, Insider Risk Management och DSPM-
relaterade kontroller för stödda Copilot- och agentscenarier. Befintliga
behörigheter är fortfarande den första datagränsen.

### Hot och runtime

Microsoft Defender kan ge detektion, utredning och, i stödda scenarier,
runtime-kontroller för agentaktivitet. Täckningen beror på plattform,
publiceringsstatus, telemetri och previewstatus. E7 lovar inte samma skydd för
varje tredjepartsagent.

### Nätverk och endpoint

Entra Suite innehåller nätverksfunktioner som Entra Internet Access och Entra
Private Access. Använd dem efter faktisk trafikmodell och dokumenterat stöd.
Intune och Defender ansvarar fortsatt för den enhetsstatus som Conditional
Access utvärderar.

## E7 är inte ett universellt minimikrav

Beskriv inte E7 som minsta licens för alla Copilot-, Graph- eller externa AI-
scenarier. Microsoft 365 Copilot, Purview och Entra har egna licenskombinationer,
och Agent 365 finns även som separat tjänst för berättigade prenumerationer. E7
är ett enkelt paket att utvärdera när samma scope behöver E5-bas, Copilot, Entra
Suite och Agent 365.

Den riktiga frågan är: vilken kontroll behövs, för vilken identitet, data,
enhet och workload, och vilken licens ger den kontrollen?

## Rekommenderad införandeordning

Detta är Exobes rekommendation, inte ett Microsoft-licenskrav.

1. **Definiera kontrollmålet.** Är problemet Copilot-data, agentidentitet,
   nätverk, hotdetektion, compliancebevis eller en kombination?
2. **Kartlägg entitlement.** Bekräfta SKU, add-ons, tilldelning, cloudmiljö och
   Product Terms. Separera inkluderade funktioner från separat licensierade.
3. **Bygg databaslinjen.** Granska SharePoint- och OneDrive-oversharing,
   extern delning, gamla grupper, labels och encryption-rättigheter.
4. **Bygg identitetsbaslinjen.** Inventera människor, workloads och agenter.
   Kräv ägare, sponsor, access packages och reviewdatum för autonoma agenter.
5. **Sätt policygränser.** Konfigurera Conditional Access, Purview DLP,
   retention, eDiscovery, Communication Compliance, Insider Risk och Defender
   för faktiska workloads.
6. **Pilota med negativa test.** Testa nekad åtkomst, labelskydd, DLP, OBO,
   tool calls, audit och återkallning. Ett bra svar från Copilot är inte bevis
   på att designen är säker.
7. **Driv tjänsten.** Följ agentinventering, risk, dataexponering, policyändring,
   alerts och undantag. Avveckla oanvända agenter och gammal åtkomst.

## Beslutsstöd: E5 med tillägg eller E7

| Situation | Trolig riktning |
|---|---|
| E5-säkerhet och compliance behövs, men inte Copilot eller agent-governance | E5 kan räcka. Validera kontroll och användare. |
| Microsoft 365 Copilot behövs för utvalda användare | E3 eller E5 plus Copilot-add-on kan vara mer riktat än E7. |
| Copilot, full Entra Suite och Agent 365 behövs för samma enterprisepopulation | E7 är det naturliga paketet att utvärdera. |
| Endast agent-governance behövs för en mindre eller blandad population | Jämför separat Agent 365 och dess prerequisite-licenser med E7. |
| Extern AI-governance behövs | E7 ger Microsoft-kontroller, men styr inte automatiskt varje extern SaaS eller modell. Validera endpoint, nätverk, identitet och avtal separat. |

## Governance-register

Innan en E7-deployment beskrivs som styrd ska följande evidens finnas:

- Licensentitlement och tilldelningsscope.
- Agentinventering, ägare, sponsor, syfte och expiry.
- Entra-identitet och åtkomstmönster för varje autonom eller delegerad agent.
- Behörighetshygien i SharePoint, OneDrive, Exchange och Teams.
- Label- och encryption-täckning.
- Purview DLP, audit, retention, eDiscovery och Insider Risk-konfiguration.
- Conditional Access, compliant-device- och nätverkspolicyer.
- Defenderdetektion, runtime-skydd och telemetritäckning.
- Undantagsägare, slutdatum och kompensationskontroll.
- Månatlig granskning av Microsoft release notes och Product Terms.

## Relaterade knowledgebase-artiklar

- [Microsoft Agent 365](../Agent%20365/README.md)
- [Microsoft 365 Copilot: security och governance](../Microsoft%20365%20Copilot/copilot-index.md)
- [E7 lösningsarkitektur](E7%20Solutions%20Architecture/README.md)
- [Entra Suite](../Entra/Entra-Suite.md)
- [Purview: restrict Microsoft 365 Copilot](../Purview/Restrict-M365Copilot.md)

## Microsoft Learn

- [Funktionsjämförelse för Microsoft 365 E3, E5 och E7](https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-license-feature-overview)
- [Microsoft Agent 365 service description](https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-agent-365/microsoft-agent-365)
- [Overview of Microsoft Agent 365](https://learn.microsoft.com/en-us/microsoft-agent-365/overview)
- [What is Microsoft Entra Agent ID?](https://learn.microsoft.com/en-us/entra/agent-id/what-is-microsoft-entra-agent-id)
- [Security for Microsoft Copilot](https://learn.microsoft.com/en-us/microsoft-365/copilot/security-microsoft-365-copilot)
- [Copilot controls: security och governance](https://learn.microsoft.com/en-us/microsoft-365/copilot/copilot-controls/security-governance)
- [Purview protections for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/purview/ai-m365-copilot)
- [Microsoft 365 E7 och Agent 365: general availability](https://learn.microsoft.com/en-us/partner-center/announcements/2026-may#microsoft-365-e7-and-agent-365-are-now-generally-available)

## Kontrollfrågor

- Drivs inköpet av ett dokumenterat kontrollgap i stället för en featurelista?
- Vilka E7-funktioner behövs för alla användare och vilka ska ha smalare scope?
- Vilka kontroller är konfigurerade och vilka är bara licensierade?
- Vilka agentplattformar och externa AI-tjänster ligger utanför Microsofts
  dokumenterade skyddsgräns?
- Vilken evidens visar att organisationen kan upptäcka, begränsa och utreda en
  AI- eller agentincident?

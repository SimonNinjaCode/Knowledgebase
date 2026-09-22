---
layout:
  width: wide
domain: m365-e7
title: "Enhets- och endpointskydd i Microsoft 365 E7"
type: concept
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [ciso, security, endpoint, identity, compliance]
tags: ["#m365-e7", "#endpoint", "#intune", "#defender", "#conditional-access"]
sources:
  - https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-license-feature-overview
  - https://learn.microsoft.com/en-us/mem/intune/protect/device-compliance-get-started
  - https://learn.microsoft.com/en-us/entra/identity/conditional-access/policy-all-users-device-compliance
  - https://learn.microsoft.com/en-us/purview/endpoint-dlp-learn-about
---

# Enhets- och endpointskydd i Microsoft 365 E7

E7 ersätter inte endpoint-baslinjen. Intune, Defender for Endpoint,
Conditional Access och Purview Endpoint DLP måste fortfarande vara rätt
konfigurerade för de plattformar och användare som ingår i scope. E7:s
licensskillnad är främst att Copilot, Agent 365 och Entra Suite ingår utöver
E5, inte att varje klientkontroll blir en ny AI-funktion.

## Kontrollkedjan

```text
Enhet
  → Intune compliance och konfigurationskrav
  → Defender health, EDR och incidenttelemetri
  → Conditional Access beslutar om åtkomst
  → Purview Endpoint DLP hanterar valda datautförselkanaler
  → audit, alert och incidentprocess
```

Conditional Access utvärderar bland annat enhetens compliance. Det gör en
compliant device till en möjlig spärr, inte till ett bevis på att data eller
AI-åtkomst är säker.

## Designbeslut

| Beslut | Fråga att besvara |
|---|---|
| Enhetsstatus | Vilka plattformar och compliance-signaler måste vara uppfyllda? |
| Åtkomst | Ska Copilot, agentportaler och externa AI-tjänster ha samma eller olika policies? |
| Datautförsel | Vilka copy, paste, filuppladdningar eller webbsessioner ska övervakas eller blockeras? |
| Telemetri | Vilka Defender-, Intune- och Purview-loggar behöver SOC och compliance? |
| Undantag | Vem godkänner undantag, hur länge gäller de och vilket test bevisar risken? |

## Praktisk baslinje

1. Registrera och hantera stödda klienter med Intune.
2. Kräv en definierad compliance-nivå för högriskresurser, till exempel
   agentadministration och känsliga datakällor.
3. Aktivera Defender-skydd och kontrollera att signaler kommer fram till rätt
   incidentprocess.
4. Använd Purview Endpoint DLP där kanalen, operativsystemet och licensen
   stöds. Testa faktiska webbläsare och applikationer; anta inte identiskt stöd
   mellan Windows, macOS och mobila plattformar.
5. Separera läsning av M365-data från uppladdning till externa AI-tjänster.
   Den senare kräver egen leverantörs-, nätverks- och endpointbedömning.
6. Mät blockeringar, motiverade tillåtanden, policyundantag och klienter utan
   telemetri.

## Vad sidan inte lovar

- E7 blockerar inte automatiskt all AI-trafik från en ohanterad enhet.
- En compliant device stoppar inte en användare som redan har för bred
  behörighet till SharePoint eller andra datakällor.
- Endpoint DLP täcker inte automatiskt varje extern modell, webbläsare,
  terminal eller lokal agent.
- Entra Internet Access och Entra Private Access är Entra Suite-funktioner;
  använd dem bara där den aktuella trafikmodellen och dokumentationen stöder
  scenariot.

## Microsoft Learn

- [Microsoft 365 E3, E5 and E7 feature comparison](https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-license-feature-overview)
- [Get started with device compliance in Intune](https://learn.microsoft.com/en-us/mem/intune/protect/device-compliance-get-started)
- [Require device compliance with Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/policy-all-users-device-compliance)
- [Learn about Microsoft Purview Endpoint DLP](https://learn.microsoft.com/en-us/purview/endpoint-dlp-learn-about)

## Relaterade knowledgebase-sidor

- [Identity Protection & Zero Trust](identity-protection.md)
- [Data security and protection](data-security.md)
- [Enterprise AI Governance](enterprise-ai-governance.md)

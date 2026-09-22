---
layout:
  width: wide
domain: m365-e7
title: "Microsoft 365 E7: lösningsarkitektur"
type: concept
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [ciso, security, compliance, identity, architecture]
tags: ["#m365-e7", "#solutions-architecture", "#ai-governance", "#zero-trust", "#security"]
sources:
  - https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-license-feature-overview
  - https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-agent-365/microsoft-agent-365
  - https://learn.microsoft.com/en-us/entra/agent-id/what-is-microsoft-entra-agent-id
  - https://learn.microsoft.com/en-us/microsoft-365/copilot/copilot-controls/security-governance
---

# Microsoft 365 E7: lösningsarkitektur

Det här är en säkerhets- och governanceorienterad arkitekturguide för
Microsoft 365 E7. E7 är ett licenspaket. Sidorna beskriver hur de ingående
kontrollerna kan sättas ihop till ett arbetssätt; de är inte en garanti för att
en kontroll är aktiverad eller gäller för varje agentplattform.

## Arkitektur i korthet

```text
E5-baslinje
  ├─ identitet och Conditional Access
  ├─ enheter och Defender
  └─ data och Purview
          │
E7-tillägg
  ├─ Microsoft 365 Copilot
  ├─ Microsoft Agent 365
  └─ Microsoft Entra Suite
          │
Operativ styrning
  ├─ inventering, ägare och livscykel för agenter
  ├─ åtkomst, data och verktyg med minsta privilegium
  ├─ detektion, utredning och revisionsspår
  └─ återkommande risk- och licensgranskning
```

Microsofts jämförelse beskriver E7 som E5 plus Microsoft 365 Copilot, Agent
365 och Entra Suite. Agent 365:s tjänstebeskrivning visar sedan vilka
governancekontroller som faktiskt finns för inventering, policy, identitet,
Purview, Defender och Intune. Läs därför alltid funktionsmatrisen tillsammans
med respektive produkts dokumentation.

## Domäner

| Domän | Vad som ska beslutas |
|---|---|
| [Data Security & Protection](data-security.md) | Vilka data- och compliancekontroller gäller för Copilot och stödda agentflöden? |
| [Identity Protection & Zero Trust](identity-protection.md) | Hur skiljer vi på användare, delegerade agenter och autonoma agenter? |
| [DSPM for AI](dspm-ai.md) | Hur hittar vi överexponering och prioriterar åtgärder innan en incident? |
| [Enterprise AI Governance](enterprise-ai-governance.md) | Hur styr vi M365 och externa AI-tjänster med tydliga gränser? |
| [Device & Endpoint Protection](device-protection.md) | Vilken enhets- och nätverksstatus krävs före AI-åtkomst? |

## Designprinciper

- **Licens är inte konfiguration.** Dokumentera vad som är köpt, tilldelat,
  aktiverat och testat.
- **Identitet före funktion.** Varje agent behöver ägare, syfte, identitet,
  åtkomstmönster och slutdatum innan den får produktionsdata.
- **Dataåtkomst är första spärren.** Copilot och agenter kan inte göra en
  användares eller agents befintliga behörigheter säkrare.
- **Separera upptäckt från blockering.** DSPM och observability visar risk;
  Conditional Access, DLP, Intune och Defender verkställer valda spärrar.
- **Skriv ned gränserna.** Stöd för tredjepartsplattformar, previewfunktioner,
  telemetri och OBO-flöden måste framgå av designen.

## Rekommenderat arbetssätt

1. Beskriv kontrollmålet: dataexponering, agentåtkomst, nätverk, endpoint eller
   incidentförmåga.
2. Inventera användare, workload identities, agenter, verktyg, datakällor och
   externa AI-tjänster.
3. Tilldela ägare och sponsorer. Välj autonomt, delegerat eller användarliknande
   åtkomstmönster per agent.
4. Konfigurera minst privilegium, Conditional Access, Purview och Defender för
   de plattformar som verkligen ingår i scope.
5. Testa nekad åtkomst, skyddade dokument, DLP, audit, OBO och avveckling.
6. Följ upp agentinventering, undantag, incidenter, release notes och Product
   Terms på en fast frekvens.

## Relaterade knowledgebase-sidor

- [Microsoft Agent 365](../../Agent%20365/README.md)
- [Microsoft 365 Copilot: security and governance](../../Microsoft%20365%20Copilot/copilot-index.md)
- [Microsoft 365 E7: security and governance overview](../m365-e7-overview.md)
- [Entra Suite](../../Entra/Entra-Suite.md)
- [Purview: restrict Microsoft 365 Copilot](../../Purview/Restrict-M365Copilot.md)

## Microsoft Learn

- [Microsoft 365 E3, E5 and E7 feature comparison](https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-license-feature-overview)
- [Microsoft Agent 365 service description](https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-agent-365/microsoft-agent-365)
- [What is Microsoft Entra Agent ID?](https://learn.microsoft.com/en-us/entra/agent-id/what-is-microsoft-entra-agent-id)
- [Copilot controls: security and governance](https://learn.microsoft.com/en-us/microsoft-365/copilot/copilot-controls/security-governance)

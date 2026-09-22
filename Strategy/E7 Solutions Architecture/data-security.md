---
layout:
  width: wide
domain: m365-e7
title: "Datasäkerhet och skydd i Microsoft 365 E7"
type: concept
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [ciso, security, compliance, data-governance, m365-admin]
tags: ["#m365-e7", "#data-security", "#purview", "#dlp", "#information-protection"]
sources:
  - https://learn.microsoft.com/en-us/purview/ai-m365-copilot
  - https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-architecture-data-protection-auditing
  - https://learn.microsoft.com/en-us/microsoft-365/copilot/configure-secure-governed-data-foundation-microsoft-365-copilot
  - https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-agent-365/microsoft-agent-365
---

# Datasäkerhet och skydd i Microsoft 365 E7

E7 samlar Microsoft 365 Copilot, Agent 365 och Entra Suite med E5:s
säkerhets- och compliancebas. Dataskyddet måste fortfarande konfigureras per
datakälla, identitet, klient och agentplattform.

## Datagränsen

Microsoft 365 Copilot arbetar inom Microsoft 365:s tjänstegräns och använder
innehåll som den inloggade användaren har behörighet att läsa. Befintliga
SharePoint-, OneDrive-, Exchange- och Teams-behörigheter är därför den första
kontrollen. Copilot upphäver inte en användares åtkomst, och en label eller
kryptering ersätter inte behörighetsgranskning.

För Agent 365 beskriver Microsoft även Purview-kontroller för stödda
agentscenarier. Kontrollera alltid agentplattform, publiceringsstatus,
telemetri och aktuell licens innan ett krav skrivs som en garanti.

## Kontrollkarta

| Kontroll | Säkerhetsfråga | Exempel på evidens |
|---|---|---|
| Permissions | Kan Copilot eller agenten läsa mer än arbetsuppgiften kräver? | Behörighetsrapport, ägare och åtgärdad oversharing |
| Sensitivity labels och encryption | Är känsligt innehåll klassificerat och rättigheter testade? | Labelpolicy, skyddad testfil och resultat för VIEW/EXTRACT |
| DLP | Vad ska varnas, blockeras eller kräva motivering? | Policy, testfall, incident och undantag |
| Audit | Kan prompt, svar, åtkomst och policyändring följas upp? | Unified audit-logg och bevarandekrav |
| Retention/eDiscovery | Kan organisationen bevara och hitta relevant AI-innehåll? | Retention policy, case och exporttest |
| Insider Risk/Communication Compliance | Vilka signaler kräver granskning med rätt process? | Policy, rollseparation och utredningslogg |
| DSPM | Vilka data- och åtkomstgap ska prioriteras? | Riskrapport, ägare och stängd åtgärd |

Microsoft Purview dokumenterar stöd för bland annat DSPM, auditing,
klassificering, labels, encryption, DLP, retention, eDiscovery, Communication
Compliance och Insider Risk Management för Microsoft 365 Copilot. Agent 365:s
tjänstebeskrivning listar motsvarande Purview-kapabiliteter för agentstyrning.

## DLP och DSPM har olika jobb

| | DLP | DSPM |
|---|---|---|
| Fråga | Ska den här handlingen tillåtas? | Var är vår exponering och varför? |
| Åtgärd | Warn, block, allow with justification eller logga | Prioritera risk och tilldela åtgärd |
| Bevis | Policyträff, användarval och incident | Riskfynd, ägare, deadline och status |

Det här är en operativ modell, inte ett påstående om att varje DSPM-fynd kan
blockeras automatiskt. Använd båda där de stöds och dokumentera luckorna.

## Säker grund för Copilot och agenter

1. Rensa överdelning i SharePoint, OneDrive, Teams och Exchange.
2. Definiera informationsklasser, labels, encryption och vem som får ändra
   eller dekryptera skyddat innehåll.
3. Skapa DLP- och auditpolicyer för de datakällor och Copilot-/agentscenarier
   som ingår i scope.
4. Lägg till retention, eDiscovery, Communication Compliance och Insider Risk
   där lagkrav och riskbild motiverar det.
5. Pilotera med skyddade dokument, nekad åtkomst, OBO-flöden, DLP-matchningar
   och återkallad behörighet.
6. Följ upp policyundantag, dataexponering, agentåtkomst och release notes.

## Gräns mot externa AI-tjänster

Microsoft 365:s Copilot- och Purviewkontroller ska inte beskrivas som en
automatisk policy för varje extern SaaS-tjänst eller modell. För externa
AI-tjänster behöver arkitekturen normalt kompletteras med leverantörens
enterprise-kontroller, Entra-åtkomst, Endpoint DLP, Defender for Cloud Apps,
nätverkskontroller och avtalskrav. Verifiera stödet för varje kanal; anta inte
att en sensitivity label ensam stoppar uppladdning eller promptinnehåll.

## Microsoft Learn

- [Purview protections for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/purview/ai-m365-copilot)
- [Microsoft 365 Copilot architecture: data protection and auditing](https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-architecture-data-protection-auditing)
- [Configure a secure and governed data foundation for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/microsoft-365/copilot/configure-secure-governed-data-foundation-microsoft-365-copilot)
- [Microsoft Agent 365 service description](https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-agent-365/microsoft-agent-365)

## Relaterade knowledgebase-sidor

- [Microsoft 365 Copilot: security and governance](../../Microsoft%20365%20Copilot/copilot-index.md)
- [DSPM for AI](dspm-ai.md)
- [Enterprise AI Governance](enterprise-ai-governance.md)

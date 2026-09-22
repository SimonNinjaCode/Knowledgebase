---
layout:
  width: wide
domain: agent-365
title: "Agent observability"
type: reference
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [security, soc, platform, compliance, ciso]
tags: ["#agent-365", "#observability", "#audit", "#agent-governance"]
sources:
  - https://learn.microsoft.com/en-us/microsoft-agent-365/admin/monitor-agents
  - https://learn.microsoft.com/en-us/defender-xdr/security-for-ai/ai-agent-detection-protection
---

# Agent observability

Observability gör agentens identitet, åtkomst och beteende möjligt att följa
upp. Det är en förutsättning för säkerhet och governance, men inte ett
ersättningsord för audit, DLP eller incidenthantering.

## Vad som bör kunna följas

| Signal | Säkerhets- och governancefråga |
|---|---|
| Agent, ägare och plattform | Vet vi vem som ansvarar och var agenten körs? |
| Sign-in och delegation | Var användes identiteten, och skedde OBO? |
| Tool calls | Vilket verktyg kallades med vilket scope och resultat? |
| Dataåtkomst | Vilka datakällor lästes eller ändrades? |
| Policy- och lifecycle-händelser | Vem skapade, ändrade, blockerade eller tog bort agenten? |
| Fel och avvikelser | Finns ett mönster som kräver triage eller avstängning? |

Microsofts täckning varierar mellan agentplattformar. Microsoft-byggda agenter
kan ha inbyggd telemetri, medan andra plattformar kan kräva anslutning,
instrumentering eller ett SDK. Verifiera datakällor och retention innan
observability används som revisionsbevis.

## Operativ modell

1. Definiera minsta signalpaket för varje agentklass.
2. Koppla signalerna till Agent Map, Defender, Entra och Purview där stödet
   finns.
3. Sätt trösklar för ovanlig åtkomst, verktygsanrop, fel och ägarförändring.
4. Skapa triage, eskalering och avveckling för saknad eller misstänkt telemetri.
5. Spara bevis enligt organisationens retention- och eDiscovery-krav.

## Mätetal som är relevanta för säkerhet

- Agenter utan ägare, sponsor eller slutdatum.
- Agenter utan verifierad identitet, audit eller tool-telemetri.
- Oväntade scopes, datakällor, verktygsanrop och OBO-händelser.
- Tid från riskfynd till blockering, ägarbyte eller avveckling.
- Previewfunktioner och undantag som saknar kompenserande kontroll.

Produktivitets- och ROI-mått kan vara användbara, men de ersätter inte dessa
kontroller.

## Relaterade knowledgebase-sidor

- [Agent Map](agent-map.md)
- [Defender integration](Defender-Integration.md)
- [ID Protection](ID-Protection.md)
- [Agent lifecycle management](Lifecycle-Management.md)

## Microsoft Learn

- [Monitor agents with Microsoft Agent 365](https://learn.microsoft.com/en-us/microsoft-agent-365/admin/monitor-agents)
- [Detect and investigate threats to AI agents](https://learn.microsoft.com/en-us/defender-xdr/security-for-ai/ai-agent-detection-protection)

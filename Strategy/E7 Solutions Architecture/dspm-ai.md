---
layout:
  width: wide
domain: m365-e7
title: "DSPM for AI: datasäkerhetsstatus"
type: concept
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [ciso, security, compliance, data-governance]
tags: ["#m365-e7", "#dspm", "#purview", "#ai-governance", "#data-security"]
sources:
  - https://learn.microsoft.com/en-us/purview/ai-m365-copilot
  - https://learn.microsoft.com/en-us/microsoft-365/copilot/configure-secure-governed-data-foundation-microsoft-365-copilot
  - https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-agent-365/microsoft-agent-365
---

# DSPM for AI: datasäkerhetsstatus

DSPM är ett synlighets- och risklager för data, behörigheter och
skyddsbrister. Det kompletterar DLP. DSPM svarar på var exponeringen finns och
vilken åtgärd som bör prioriteras; DLP avgör vad som ska tillåtas eller
blockeras när en handling sker.

## Frågor som DSPM ska hjälpa till att besvara

- Var finns känsliga data och vilka behörigheter når dem?
- Vilka datakällor är dåligt klassificerade, överdelade eller saknar skydd?
- Vilka Copilot- och agentscenarier behöver åtgärd eller mer telemetri?
- Vilka fynd har en ägare, deadline och dokumenterad riskacceptans?

Microsoft Purview beskriver DSPM och DSPM for AI tillsammans med
rekommendationer, rapporter och andra dataskyddskontroller. Exakt täckning
beror på workload, roll, region, previewstatus och licens. Skriv därför inte
"DSPM hittar all Shadow AI" eller "DSPM skannar alla externa uppladdningar"
som generella garantier.

## DSPM kontra DLP

| | DSPM | DLP |
|---|---|---|
| Primär fråga | Var är data eller åtkomst felkonfigurerad? | Ska den här handlingen tillåtas? |
| Typisk utdata | Riskfynd, rekommendation, prioritering | Warn, block, motivering eller logg |
| När den verkar | På tillstånd, relationer och mönster | När en definierad datahantering sker |
| Operativt krav | Ägare, åtgärd och uppföljning | Testfall, incidentflöde och undantag |

Kombinationen är användbar, men ett DSPM-fynd blir inte automatiskt en
blockering. Säkerställ att den valda DLP-policyn och kanalen faktiskt stöds.

## Rekommenderad arbetsmodell

1. Definiera vilka datakällor, identiteter, agentplattformar och AI-kanaler som
   ingår i analysen.
2. Kör en baslinje för behörigheter, labels, encryption, delning och
   skyddspolicyer.
3. Prioritera fynd efter datakänslighet, åtkomstens bredd, agentens autonomi,
   exponeringsväg och regulatorisk betydelse.
4. Tilldela varje fynd en ägare, deadline och verifieringsmetod.
5. Åtgärda med behörighetsändring, label, DLP, Conditional Access,
   lifecycle-åtgärd eller ändrad agentdesign.
6. Mät kvarvarande exponering och stäng inte ett fynd förrän kontrollen är
   testad.

## Vanliga feltolkningar

- **DSPM är inte DLP.** Synlighet utan åtgärd lämnar risken kvar.
- **E7 är inte ett automatiskt DSPM-resultat.** Licensen ger åtkomst till
  funktioner; den skapar inte dataklassificering eller rätt behörigheter.
- **En agentinventering är inte samma sak som datainventering.** Koppla varje
  agent till identitet, datakällor, verktyg och åtkomstmönster.
- **Externa AI-tjänster ligger inte automatiskt i Purviews täckning.** Lägg till
  endpoint-, nätverks-, leverantörs- och avtalskontroller där det behövs.

## Microsoft Learn

- [Purview protections for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/purview/ai-m365-copilot)
- [Configure a secure and governed data foundation for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/microsoft-365/copilot/configure-secure-governed-data-foundation-microsoft-365-copilot)
- [Microsoft Agent 365 service description](https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-agent-365/microsoft-agent-365)

## Relaterade knowledgebase-sidor

- [Data security and protection](data-security.md)
- [Microsoft Agent 365](../../Agent%20365/README.md)
- [Enterprise AI Governance](enterprise-ai-governance.md)

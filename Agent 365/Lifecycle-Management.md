---
layout:
  width: wide
domain: agent-365
title: "Agent lifecycle management"
type: reference
status: current
created: 2026-09-15
updated: 2026-09-15
last_verified: 2026-09-15
audience: [platform, security, identity, compliance]
tags: ["#agent-365", "#lifecycle", "#agent-governance", "#access-control"]
sources:
  - https://learn.microsoft.com/en-us/microsoft-365/admin/manage/agent-actions
  - https://learn.microsoft.com/en-us/entra/id-governance/agent-id-governance-overview
---

# Agent lifecycle management

Microsoft 365 admin center har åtgärder för att styra agenters tillgänglighet,
distribution och retirement. Använd dem som verkställande steg i en längre
livscykel med ägare, sponsor, åtkomstgranskning och bevarandekrav.

## Åtgärder

| Åtgärd | Governancefråga |
|---|---|
| Install / publish | Är målgrupp, permissions och publiceringskanal godkända? |
| Uninstall / block | Försvinner användarens åtkomst och alternativa vägar? |
| Start / stop | Kan underliggande Foundry-resurs stoppas utan att bevis försvinner? |
| Assign new owner | Finns en namngiven ansvarig och sponsor? |
| Delete | Är data, secrets, audit och retention hanterade före borttagning? |
| Export / inventory | Kan vi bevisa vilken version och status som gällde? |

Vilka åtgärder som visas beror på agenttyp, plattform, roll och tenant. Följ
admincentrets aktuella behörighetskrav. Använd Global Administrator sparsamt och
separera godkännande från verkställande när det är möjligt.

## Livscykelgrind

1. **Intake:** syfte, data, verktyg, identitet, ägare och slutdatum.
2. **Build:** isolerad miljö, begränsade scopes och testdata.
3. **Approve:** säkerhets-, data- och compliancekrav är testade.
4. **Publish:** begränsad målgrupp, loggning och återkallningsplan.
5. **Review:** återkommande owner, access, risk, usage och licens.
6. **Retire:** blockera, stoppa, radera eller avinstallera; återkalla credentials
   och bevara nödvändiga bevis.

## Relaterade knowledgebase-sidor

- [Agent Map](agent-map.md)
- [Agent identity governance](Identity-Governance.md)
- [Agent registry sync](Registry-Sync.md)
- [Agent observability](Observability.md)

## Microsoft Learn

- [Governance and lifecycle actions for agents](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/agent-actions)
- [Microsoft Entra ID Governance for agents](https://learn.microsoft.com/en-us/entra/id-governance/agent-id-governance-overview)

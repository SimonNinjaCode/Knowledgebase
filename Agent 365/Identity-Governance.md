---
layout:
  width: wide
source: https://learn.microsoft.com/entra/id-governance/agent-id-governance-overview
last_verified: 2026-08-19
ms_learn_updated: 2026-06-24
status: current
---

# Agent Identity Governance

## Overview

Microsoft Entra ID Governance extends to agent identities, applying the same lifecycle and access management that governs human identities. Agent identities are accounts in Microsoft Entra ID that provide unique identification and authentication for AI agents.

## Agent Identity Object Model

Agent ID introduces four new object types in Microsoft Entra:

| Object | Description |
|---|---|
| Agent Identity Blueprint | Defines configuration and governance model; agents create identities from this |
| Agent Identity Blueprint Principal | Enables multi-tenant scenarios; brought into resource tenant like a service principal |
| Agent Identity | Per-instance identity with distinct access rights, sign-in history, and audit trail |
| Agent User | Optional per-identity user object for delegated access scenarios |

### Single-Tenant Architecture

```
Agent Identity Blueprint
  └── Agent Identity 1 (with optional Agent User)
  └── Agent Identity 2 (with optional Agent User)
```

### Multi-Tenant Architecture

```
Home Tenant: Agent Identity Blueprint
  └── Resource Tenant: Agent Identity Blueprint Principal
        └── Agent Identity 1
        └── Agent Identity 2
```

## Sponsor Accountability

Every agent identity must have a human sponsor — a user accountable for:

- Decisions about the agent's lifecycle (creation, access changes, deactivation)
- Access review responses
- Governance oversight

Sponsors are assigned after agent identity creation and can be changed as organizational responsibility shifts.

## Governance Capabilities

| Capability | Description |
|---|---|
| Access Reviews | Periodic certification that agent access remains appropriate |
| Entitlement Management | Package-based access assignment for agent identities |
| Lifecycle Workflows | Automated onboarding/offboarding workflows |
| PIM (Privileged Identity Management) | Just-in-time elevation for agent identities requiring privileged access |

## Licensing

| Feature | Required License |
|---|---|
| Agent ID platform | Any Microsoft Entra (free) |
| Agent 365 integration | Microsoft Agent 365 (M365 E7) |
| Conditional Access for agents | Microsoft Entra ID P1 |
| ID Protection for agents | Microsoft Entra ID P2 |
| ID Governance for agents | Microsoft Entra ID P1 |

## Related Documentation

- [Conditional Access](Conditional-Access.md) — Access policies for agent identities
- [ID Protection](ID-Protection.md) — Risk detection for agents
- [Lifecycle Management](Lifecycle-Management.md) — Admin center agent management

## Source

- [Governing Agent Identities — MS Learn](https://learn.microsoft.com/entra/id-governance/agent-id-governance-overview)

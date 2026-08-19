---
source: https://learn.microsoft.com/entra/identity/conditional-access/agent-id
last_verified: 2026-08-19
status: current
---

# Conditional Access for Agent Identities

## Overview

Conditional Access extends to agent identities in Microsoft Entra, allowing organizations to control how AI agents access corporate resources using the same policy engine that governs user access. It evaluates real-time signals — context, location, and session risk — to allow, block, or limit agent access.

## Key Concepts

| Concept | Description |
|---|---|
| Agent Identity | Per-instance identity with sign-in history, audit trail, and kill switch |
| Agent Identity Blueprint | Reusable identity template defining configuration and governance model |
| Agent Sponsor | Human user accountable for the agent's lifecycle and access decisions |
| Custom Security Attributes | Key-value metadata on agent identities enabling attribute-based CA targeting |

## Licensing

| Feature | Required License |
|---|---|
| Conditional Access for agents | Microsoft Entra ID P1 |
| ID Protection for agents | Microsoft Entra ID P2 |
| ID Governance for agents | Microsoft Entra ID P1 |
| Network controls for agents | Microsoft Entra Internet Access |

## Attribute-Driven Conditional Access

Individually targeting each agent identity in CA policies does not scale. Use custom security attributes for attribute-based targeting instead.

### Recommended Attribute Schema

| Attribute | Type | Example Values |
|---|---|---|
| AgentClassification | String | Orchestrator, SubAgent, Connector |
| DataSensitivity | String | Public, Internal, Confidential, Restricted |
| AgentOrigin | String | Copilot Studio, MicrosoftFoundry, non-Microsoft |
| ForPublicUse | Boolean | True, False |

### How It Works

1. Define custom security attributes in Microsoft Entra ID
2. Assign attributes to agent identities (and optionally to target resources)
3. Create CA policies using attribute filters instead of manually selecting agents
4. Policies automatically apply to current and future agent identities matching the attributes

**Example rule:** "If DataSensitivity = Confidential, then block access" — automatically applies to every agent with that attribute.

## Blueprint-Level Targeting

An alternative to attribute-based targeting: apply CA policies at the agent identity blueprint level. Every agent identity is derived from a blueprint, so targeting the blueprint covers all current and future derived agent identities.

**Note:** Blueprint-level targeting does not cover agents' user accounts — only the agent identities.

## Policy Templates

Microsoft provides built-in CA policy templates for agents:

- Block high-risk agent identities
- Configure policy for autonomous agent access
- Configure policy for on-behalf-of agent access

## Related Documentation

- [ID Protection](ID-Protection.md) — Risk detection for agent identities
- [Identity Governance](Identity-Governance.md) — Lifecycle management for agent identities
- [Policy Templates](Policy-Templates.md) — Bundled governance policies

## Source

- [Conditional Access for Agent Identities — MS Learn](https://learn.microsoft.com/entra/identity/conditional-access/agent-id)

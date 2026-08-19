---
source: https://learn.microsoft.com/entra/id-protection/concept-risky-agents
last_verified: 2026-08-19
status: current
---

# ID Protection for Agent Identities

## Overview

Microsoft Entra ID Protection automatically detects and responds to identity-based risks on AI agents using the Microsoft Entra Agent ID platform. The system establishes a baseline for each agent's normal activity and continuously monitors for anomalies.

## Prerequisites

### Required Roles

| Role | Permissions |
|---|---|
| Security Administrator | Full access to risky agent reports and configuration |
| Security Operator | View and act on risky agent reports |
| Security Reader | Read-only access to risky agent reports |
| Conditional Access Administrator | Configure policies using agent risk as a condition |

### Licensing

| Feature | Required License |
|---|---|
| Agent ID platform | Any Microsoft Entra (free) |
| ID Protection for agents | Microsoft Entra ID P2 |
| Conditional Access for agents | Microsoft Entra ID P1 |

## Risk Detections

All risk detections for risky agents are currently **offline** (not real-time).

| Detection | Type | Description |
|---|---|---|
| Unfamiliar resource access | Offline | Agent targeted resources outside its normal pattern — may indicate an attacker trying to access sensitive resources beyond the agent's intended scope |
| Sign-in spike | Offline | Agent made significantly more sign-ins than its usual frequency — may indicate automated attack or toolkit usage |
| Failed access attempt | Offline | Agent attempted access to unauthorized resources — may indicate token replay against resources the agent shouldn't reach |
| Sign-in by risky user | Offline | Agent signed in on behalf of a user flagged as risky — may indicate a compromised user leveraging agent access |

## How It Works

1. Agent identity is created and begins operating normally
2. ID Protection establishes a behavioral baseline for the agent
3. Continuous monitoring compares activity against the baseline
4. Anomalous behavior triggers a risk flag on the agent identity
5. Risk signals feed into Conditional Access for automated response (e.g., block high-risk agents)

## Integration with Conditional Access

Use agent risk level as a condition in Conditional Access policies:

- **Block** agents flagged as high risk
- **Require re-evaluation** for agents with medium risk
- **Allow** agents with no detected risk

## Related Documentation

- [Conditional Access](Conditional-Access.md) — Use agent risk as a CA condition
- [Identity Governance](Identity-Governance.md) — Sponsor accountability for risky agents
- [Defender Integration](Defender-Integration.md) — Real-time threat protection

## Source

- [ID Protection for Agents — MS Learn](https://learn.microsoft.com/entra/id-protection/concept-risky-agents)

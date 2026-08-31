---
layout:
  width: wide
source: https://learn.microsoft.com/entra/id-protection/concept-risky-agents
last_verified: 2026-08-19
ms_learn_updated: 2026-06-17
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

All risk detections for risky agents are currently **offline** (not real-time). In OBO flows, risky activity is attributed to the **user**, not the agent.

| Detection | Type | riskEventType | Description |
|---|---|---|---|
| Confirmed compromised | Admin | adminConfirmedAgentCompromised | Admin manually confirmed agent is compromised |
| Early life malicious activity | Offline | earlyLifeMaliciousActivity | Newly created agent immediately exhibited multiple suspicious patterns |
| Entra Directory Reconnaissance | Offline | entraDirectoryReconnaissance | Agent performed suspicious reconnaissance or high-risk directory operations |
| Failed access attempt | Offline | failedAccessAttempt | Agent attempted access to unauthorized resources — possible token replay |
| Microsoft Entra threat intelligence | Offline | threatIntelligenceAccount | Activity consistent with known attack patterns from internal/external threat intel |
| Sign-in spike | Offline | signInSpike | Significantly more sign-ins than usual — possible automation or toolkit |
| Suspicious credential usage | Offline | suspiciousCredentialUsage | New credentials added to agent blueprints and then actually used |
| Unfamiliar resource access | Offline | unfamiliarResourceAccess | Agent targeted resources outside its normal pattern |

**Learning Mode** automatically suppresses behavioral alerts for agents lacking sufficient activity history, preventing false positives during onboarding. A parallel detection runs to catch genuinely malicious early-life behavior.

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

## Graph API

Query risky agents programmatically:

- `riskyAgents` — list of flagged agents
- `agentRiskDetections` — detection events

Risk data can be exported via diagnostic settings to Log Analytics, storage accounts, Event Hub, or SIEM solutions.

## Related Documentation

- [Conditional Access](Conditional-Access.md) — Use agent risk as a CA condition
- [Identity Governance](Identity-Governance.md) — Sponsor accountability for risky agents
- [Defender Integration](Defender-Integration.md) — Real-time threat protection

## Source

- [ID Protection for Agents — MS Learn](https://learn.microsoft.com/entra/id-protection/concept-risky-agents)

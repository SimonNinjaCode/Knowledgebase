---
source: https://learn.microsoft.com/microsoft-agent-365/admin/monitor-agents
last_verified: 2026-08-19
status: current
---

# Agent Observability

## Overview

Agent 365 provides advanced observability for enterprise-grade agent governance across agents built in Microsoft Copilot Studio, Azure Foundry, and third-party runtimes. Developers are required to implement observability — it is not optional.

## Benefits

| Area | Value |
|---|---|
| **Security and threat detection** | Integrates with Microsoft Defender to identify anomalies, misuse, and risky behaviors; reduces exposure and strengthens agent security posture |
| **Governance and compliance** | Monitors agent identity, tool usage, and AI model interactions to enforce policies and streamline audit readiness |
| **Lifecycle control** | Ensures agents meet Agent 365 certification standards through traceability from development to deployment |
| **Business impact metrics** | Provides insights into agent productivity, time savings, and interaction quality for ROI measurement |

## Key Monitoring Areas

| What | Why |
|---|---|
| Agent sign-in activity | Detect unauthorized access or token replay |
| Tool invocations | Track which tools agents call and at what frequency |
| Data access patterns | Identify agents accessing sensitive resources |
| User delegation events | Monitor on-behalf-of agent interactions |
| Error rates and failures | Detect agents failing repeatedly (may indicate misconfiguration or attack) |
| Business metrics | Measure time savings and task completion rates |

## Integration Points

| Product | Integration |
|---|---|
| Microsoft Defender XDR | Agent alerts appear in the unified incident queue |
| ID Protection | Risky agent detections feed observability dashboards |
| Purview | AI interaction audit logs and compliance reporting |
| Agent Map | Visual correlation of observability data with agent inventory |

## Related Documentation

- [Agent Map](Agent-Map.md) — Visual agent inventory with observability data overlay
- [Defender Integration](Defender-Integration.md) — Runtime threat detection
- [Purview for AI Agents](Purview-AI-Compliance.md) — Compliance monitoring

## Source

- [Agent Observability — MS Learn](https://learn.microsoft.com/microsoft-agent-365/admin/monitor-agents)

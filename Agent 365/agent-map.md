---
source: https://learn.microsoft.com/microsoft-365/admin/manage/agent-map
last_verified: 2026-08-19
ms_learn_updated: 2026-08-18
status: current
---

# Agent Map

## Overview

Agent Map provides a visual inventory of AI agents in the tenant, grouping agents by platform. It complements the list-based Agent Registry with a scalable, visual approach for environments with large numbers of agents.

## Access Requirements

| Requirement | Details |
|---|---|
| License | M365 E7 (Agent 365) |
| Role | Global Administrator or AI Administrator |

## Navigation

1. Sign in to the Microsoft 365 admin center
2. Select **Agents** > **All Agents** > **Map**

## Capabilities

| Feature | Description |
|---|---|
| Platform clustering | Agents grouped by creation platform (Copilot Studio, Azure Foundry, third-party) |
| Built-in filters | Filter by Status, Publisher type, Platform, Channel, Data source, or Usage |
| Key metrics | High-level counters and agent-level indicators at a glance |
| Agent drill-down | Review publisher, type, platform, version, and connectivity for individual agents |
| Dependency visualization | View relationships and interactions between agents |

> **Note:** Usage filtering is supported via Agent 365 observability data for tenants with fewer than 4,000 agents.

## Available Filters

| Filter | Options |
|---|---|
| Status | Available, Blocked, Ownerless |
| Publisher type | Microsoft, Third-party, Custom |
| Platform | Copilot Studio, Azure Foundry, etc. |
| Channel | Teams, Outlook, SharePoint, etc. |
| Data source | SharePoint, Graph, Custom connectors |
| Usage | Active, Inactive, Never used |

## Use Cases

- **Spot ownerless agents** — filter to "Ownerless" and assign sponsors
- **Audit by platform** — identify agent sprawl across creation platforms
- **Track adoption** — use usage filters to find inactive agents for retirement
- **Dependency mapping** — understand agent-to-agent interactions before making changes

## Related Documentation

- [Lifecycle Management](Lifecycle-Management.md) — Install, block, delete agents
- [Observability](Observability.md) — Agent activity monitoring
- [Registry Sync](Registry-Sync.md) — Import agents from external platforms

## Source

- [Agent Map in the Microsoft 365 Admin Center — MS Learn](https://learn.microsoft.com/microsoft-365/admin/manage/agent-map)

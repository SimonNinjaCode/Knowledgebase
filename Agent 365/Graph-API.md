---
source: https://learn.microsoft.com/microsoft-agent-365/admin/graph-api
last_verified: 2026-08-19
ms_learn_updated: 2026-08-04
status: current
---

# Agent Graph API

## Overview

The Agent Graph API provides programmatic access to the Agent 365 registry, enabling administrators to automate bulk agent management, streamline onboarding, and integrate governance into existing workflows.

> **Preview** — These endpoints are currently in preview.

## Available Endpoints

| Endpoint | Description | Use Case |
|---|---|---|
| List packages API | Retrieve a complete list of agents in the tenant | Compliance reporting, inventory audits |
| Get Copilot package details API | Retrieve detailed metadata for an individual agent | Agent auditing, configuration review |

## Required Roles

| Role | Access |
|---|---|
| AI Administrator | Full access to agent registry APIs |
| Global Administrator | Full access to agent registry APIs |

## Use Cases

- **Inventory reporting** — Pull a full agent list for compliance and audit purposes
- **Bulk management** — Automate onboarding and configuration changes across many agents
- **Governance integration** — Connect agent registry data to existing IT governance workflows
- **Automated monitoring** — Build custom alerting on agent inventory changes

## Related Documentation

- [Lifecycle Management](Lifecycle-Management.md) — UI-based agent management
- [Registry Sync](Registry-Sync.md) — Import agents from external platforms
- [Observability](Observability.md) — Agent activity monitoring

## Source

- [Graph API for Agent Registry — MS Learn](https://learn.microsoft.com/microsoft-agent-365/admin/graph-api)

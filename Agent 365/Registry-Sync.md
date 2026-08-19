---
source: https://learn.microsoft.com/microsoft-agent-365/admin/agent-registry
last_verified: 2026-08-19
status: preview
---

# Agent Registry Sync

> **Preview feature** — not intended for production use. Subject to supplemental terms of use.

## Overview

Registry Sync enables administrators to connect external AI agent environments and synchronize agents into the Agent 365 registry for centralized visibility and governance. Without it, agents deployed across multiple platforms must be tracked manually.

## Supported Platforms

| Platform | Authentication |
|---|---|
| Amazon Bedrock | AWS credentials (IAM) |
| Google Vertex AI | GCP service account |
| Salesforce Agentforce | OAuth / API token |
| Databricks Genie | Databricks PAT |

Microsoft is actively expanding platform support.

## Capabilities

- Connect supported third-party AI platforms
- Authenticate once per environment
- Synchronize agents into the Agent 365 registry
- Perform management actions supported by each platform's APIs

## Create a Platform Connection

1. Open the [Microsoft 365 admin center](https://admin.microsoft.com)
2. Navigate to **Agents** > **All Agents**
3. In the **Registry sync** web part, select **Manage**
4. Select **+ Connect a platform**
5. Enter a connection name and description
6. Select the external platform and region
7. Choose whether to import agents automatically
8. Enter authentication credentials
9. Validate credentials
10. Save the connection

After setup, trigger a sync via the **Sync agents** button. Scheduled synchronization is planned for a future release.

## Connection Details

After a sync, view:

| Detail | Description |
|---|---|
| Platform provider | AWS, GCP, Salesforce, Databricks |
| Regions | Connected regions |
| Last run date | When the last sync completed |
| Last sync status | Success, partial, or failed |
| Total synced agents | Number of agents imported |
| Sync results | Per-agent import status |

## Management Actions

From the Registry Sync page:

- Create new platform connections
- View connection sync status
- Monitor last sync activity
- Review sync errors
- Delete existing connections

## Related Documentation

- [Agent Map](Agent-Map.md) — Visual inventory including synced agents
- [Lifecycle Management](Lifecycle-Management.md) — Manage imported agents
- [Graph API](Graph-API.md) — Programmatic registry access

## Source

- [Registry Sync — MS Learn](https://learn.microsoft.com/microsoft-agent-365/admin/agent-registry)

---
layout:
  width: wide
source: https://learn.microsoft.com/microsoft-365/admin/manage/agent-actions
last_verified: 2026-08-19
ms_learn_updated: 2026-08-18
status: current
---

# Agent Lifecycle Management

## Overview

The Microsoft 365 admin center provides governance and lifecycle management for agents through the Agent Registry. Administrators can manage agent visibility, access, distribution, and retirement across the tenant.

## Agent Actions

| Action | Description |
|---|---|
| **Install** | Deploy an agent to all users or specific users/groups — makes it available without manual end-user installation |
| **Uninstall** | Remove a previously installed agent from users/groups |
| **Block / Unblock** | Restrict or restore access to an agent across the organization |
| **Delete** | Permanently remove an agent and all associated files from the inventory |
| **Start / Stop** | Start or stop underlying Azure infrastructure for Foundry agents (requires Azure AI Owner role) |
| **Assign new owner** | Transfer ownership of ownerless or active agents (Agent Builder and Copilot Studio only) |
| **Publish to store** | Make a requested agent available via the Agent Store |
| **Reject submission** | Prevent a requested agent from becoming available |

Additional registry actions: **Export to Excel**, **Upload custom agent**, **Manage pinned agents**.

## Install an Agent

1. Sign in to the [Microsoft 365 admin center](https://admin.microsoft.com)
2. Navigate to **Agents** > **All agents**
3. Select **Registry** tab, filter by **Status: Available**
4. Select an agent that is not already installed
5. In the agent details pane, select **Install**
6. Choose deployment scope: all users or specific users/groups
7. Review requested permissions and select **Grant admin consent**
8. In the permissions dialog, select **Accept**
9. Select **Finish deployment**

Installing an agent affects its availability in Copilot, Outlook, Teams, and other M365 host products.

## Uninstall an Agent

Follow the same navigation path, select an installed agent, and choose **Uninstall**. Scope the removal to all users or specific users/groups.

## Government Cloud Support

Microsoft 365 GCC High (GCCH) and GCC Moderate (GCCM) environments support publishing agents to the organization.

## Related Documentation

- [Agent Map](Agent-Map.md) — Visual agent inventory
- [Registry Sync](Registry-Sync.md) — Synchronize agents from external platforms
- [Identity Governance](Identity-Governance.md) — Governance for agent identities

## Source

- [Governance and Lifecycle Actions for Agents — MS Learn](https://learn.microsoft.com/microsoft-365/admin/manage/agent-actions)

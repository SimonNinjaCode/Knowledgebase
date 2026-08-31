---
layout:
  width: wide
source: https://learn.microsoft.com/microsoft-365/admin/manage/manage-tools-for-agent
last_verified: 2026-08-19
ms_learn_updated: 2026-07-30
status: current
---

# Agent Tool Controls

## Overview

Agent Tools in the Microsoft 365 admin center provides a centralized view of all AI-powered tools and MCP servers available in the tenant. These tools define how AI models interact with user data, tools, and workflows.

## Navigation

1. Sign in to the [Microsoft 365 admin center](https://admin.microsoft.com)
2. Select **Agents** > **Tools** > **Registry**

## Available Actions

| Action | Description |
|---|---|
| Block | Prevents the selected tool from being used by agents or workflows |
| Unblock | Restores access to a previously blocked tool |

## Registry Columns

| Column | Description |
|---|---|
| Name | Tool display name (e.g., "Microsoft Teams MCP Server") |
| Status | Available or Blocked |
| Type | Tool category (e.g., MCP Server) |
| Publisher | Microsoft for first-party, or third-party publisher name |

## Filters

| Filter | Options |
|---|---|
| Status | Available, Blocked |
| Publisher | Microsoft, Third-party |

## Common MCP Servers

| Server | Description |
|---|---|
| Dataverse MCP Server | Access Dataverse data and operations |
| Windows 365 for Agents | Agent access to Cloud PC resources |
| Microsoft MCP Management | Management and control of MCP infrastructure |
| Admin Tools MCP Server | Administrative operations via M365 admin center |

## Bring Your Own (BYO) MCP Server

> **Preview feature** — Subject to supplemental terms of use.

Organizations can register their own remote MCP servers with Agent 365 for centralized governance and observability. This enables:

- Custom tool integration with full governance controls
- Centralized visibility into all tools (Microsoft + custom) in one registry
- Consistent security policy enforcement across all MCP servers

## BYO MCP Server Workflow

The developer-to-admin flow for Bring Your Own MCP servers:

1. **Developer registers** server via Agent 365 CLI (`a365 develop-mcp register-external-mcp-server`)
2. **Admin reviews** in admin center under **Tools** > **Requests** tab
3. **Admin approves** and grants Microsoft Entra permissions
4. **Server becomes available** in Copilot Studio, VS Code, Claude Code, GitHub Copilot CLI
5. **Security team monitors** via Defender Advanced Hunting (`CloudAppEvents` table)

Supported auth types: NoAuth, APIKey (Header/Query), ExternalOAuth, EntraOAuth.

## Plugins and Skills

In addition to MCP servers, admins can upload and manage plugins (API-based integrations) and skills through the same Tools interface. Actions include install/uninstall, block/unblock, and delete.

## Requests Tab

Use the **Requests** tab to review and approve tool requests from developers. This provides a governed workflow for expanding the tool ecosystem:

1. Developer registers a tool (e.g., BYO MCP server)
2. Admin reviews the request in the Requests tab
3. Admin approves or rejects, then grants Entra consent
4. Approved tools appear in the Registry

## Related Documentation

- [Lifecycle Management](Lifecycle-Management.md) — Agent deployment management
- [Defender Integration](Defender-Integration.md) — Runtime protection for tool invocations
- [Global Secure Access](Global-Secure-Access.md) — Network controls for agent traffic

## Source

- [Manage Tools for Agents — MS Learn](https://learn.microsoft.com/microsoft-365/admin/manage/manage-tools-for-agent)

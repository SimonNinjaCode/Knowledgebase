---
domain: m365-e7
id: "M365-AGENT-TC-001"
title: "Manage tools for agents in Microsoft 365 admin center - Microsoft 365 admin"
sources: ["m365maps E7"]
ms-learn: "https://learn.microsoft.com/microsoft-365/admin/manage/manage-tools-for-agent"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#agents", "#management"]
group: "management"
---

# Manage tools for agents in Microsoft 365 admin center - Microsoft 365 admin

## Översikt

Agent Tool Controls — en del av Microsoft 365 E7. Se [Microsoft Learn](https://learn.microsoft.com/microsoft-365/admin/manage/manage-tools-for-agent) för full dokumentation.

## Innehåll

Agent Tools in the [Microsoft 365 admin center] provides a centralized view of all AI-powered tools and Model Context Protocol (MCP) servers available in your organization. These tools define how an AI model interacts with user data, tools, and workflows. Agent Tools allows you to handle requests, responses, and actions in a consistent, safe, secure, and transparent manner.

Each tool listed represents a service that supports Copilot experiences across Microsoft 365 apps. You can monitor availability, manage access, and ensure compliance with organizational policies. Use the **Registry** tab to view and manage tools available in your tenant, and the **Requests** tab to review and approve tool requests from users in your organization.

The Bring Your Own (BYO) MCP server feature enables organizations to register their own remote MCP servers with Agent 365 for centralized governance and observability. For more information, see [Bring your own (BYO) MCP server].

## View the Agent Tools registry

1.  Sign in to the [Microsoft 365 admin center].

2.  In the left navigation pane, select **Agents** \> **Tools** \> **Registry**.

    [
    [![Screenshot showing a list of available agent tools for a tenant.]][3]

## Key components of Agent Tools

Agent Tools list under the **Registry** tab and **Request** tab provides filter, columns, and actions to help you manage your agent tools.

### Actions

You can select the available actions directly from the list, or select the listed agent to display an overview of an agent tool. Agent tools include the following actions:

  Action    Description
  --------- --------------------------------------------------------------------
  Block     Prevents the selected tool from being used by agents or workflows.
  Unblock   Restores access to a previously blocked tool.

### Filters

The agent tools registry can contain a large and diverse inventory of tools. You can filter the list to help you narrow the view to the agent tools that you want to focus on at the moment.

Filters are based on the following criteria:

  Filter      Description
  ----------- ----------------------------------------------------------------------------
  Status      Filter tools by their current state, such as **Available** or **Blocked**.
  Publisher   View tools published by Microsoft or other providers.

### Columns

The following table describes the columns that are available in the agent tools registry:

  Column      Description
  ----------- -------------------------------------------------------------------
  Name        The tool\'s display name, such as **Microsoft Teams MCP Server**.
  Status      Shows whether the tool is **Available** or **Blocked**.
  Type        Shows the tool category, such as **MCP Server**.
  Publisher   Shows the publisher, such as Microsoft for first-party tools.

## Common MCP servers

You use an MCP servers as a service to expose data, actions, and business logic to agents.

The following are examples of MCP servers:

- [Dataverse MCP Server]
- [Windows 365 for Agents MCP server]
- [Microsoft MCP management MCP server]
- [Admin tools MCP Server for Microsoft 365 admin center]

For related information, see [Microsoft Agent 365 SDK and CLI].

## Bring your own (BYO) MCP server

The Bring Your Own (BYO) MCP server feature enables organizations to register their own remote MCP servers with Microsoft Agent 365 for centralized governance and observability.

Important

- This is a preview feature.
- Preview features aren\'t meant for production use and might have restricted functionality. These features are subject to [supplemental terms of use], and are available before an official release so that customers can get early access and provide feedback.

*Se MS Learn för full dokumentation.*

## MS Learn-källa
[Agent Tool Controls](https://learn.microsoft.com/microsoft-365/admin/manage/manage-tools-for-agent)

## Relaterade notes
- Agent 365 Index

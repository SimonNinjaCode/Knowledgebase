---
domain: m365-e7
id: "M365-AGENT-RS-001"
title: "Registry sync in the Microsoft 365 agent registry (preview)"
sources: ["m365maps E7"]
ms-learn: "https://learn.microsoft.com/microsoft-agent-365/admin/agent-registry"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#agents", "#management"]
group: "management"
---

# Registry sync in the Microsoft 365 agent registry (preview)

## Översikt

Agent Registry Sync — en del av Microsoft 365 E7. Se [Microsoft Learn](https://learn.microsoft.com/microsoft-agent-365/admin/agent-registry) för full dokumentation.

## Innehåll

Important

- This is a preview feature.
- Preview features aren\'t meant for production use and might have restricted functionality. These features are subject to [supplemental terms of use], and are available before an official release so that customers can get early access and provide feedback.

Registry sync in Microsoft Agent 365 agent registry, in the Microsoft 365 admin center, enables you, as an administrator, to securely connect external AI agent environments and synchronize agents into the Agent 365 agent registry for centralized visibility and governance.

AI agents are often deployed across multiple environments such as Amazon Bedrock, Google Vertex AI, Salesforce, and Databricks. Without a centralized agent registry, you must manually track agents across disconnected platforms.

By using the registry sync, you can:

- Connect supported third‑party AI platforms.
- Authenticate once per environment.
- Synchronize agents from external environments into Microsoft Agent 365 agent registry.
- Perform agent management actions supported by the AI platform APIs.

## Manage external platform connections

You can create and manage external platform connections from the **Registry sync** page in the Microsoft 365 admin center.

[![Screenshot of Registry sync page in Microsoft 365 admin center showing Google Cloud connection details pane with sync status and synced agents.]][3]

From this page, you can:

- Create new platform connections.
- View connection sync status.
- Monitor last sync activity.
- Review errors associated with sync attempts.
- Delete existing connections.

## Create a platform connection

To synchronize agents from an external platform, follow these steps:

1.  Open the [Microsoft 365 admin center] in your browser.
2.  In the navigation pane, select **Agents** \> **All Agents** to see the agent registry.
3.  In the **Registry sync** web part, select **Manage**. The **Registry sync** page is displayed.
4.  Select **+ Connect a platform**.
5.  Enter a connection name for the external environment and provide a description.
6.  Select the external platform.
7.  Select the region.
8.  Indicate if you want to import agents automatically.
9.  Enter the required authentication credentials.
10. Validate credentials.
11. Save the connection.

After successful validation and setup:

- The Microsoft 365 admin can trigger a sync by using the **Sync agents** button.
- Agents from the connected environment synchronize into the agent registry.
- You can configure future synchronizations to occur on a scheduled basis, in a future release.

## View details after a sync

Select an existing connection to view sync details and monitor synchronization status.

Connection details include:

- Platform provider
- Regions
- Last run date
- Last sync status
- Total synced agents
- Synchronization results

## Supported platforms

Registry sync supports synchronization from the following platforms:

- Amazon Bedrock
- Google Vertex AI
- Salesforce Agentforce
- Databricks Genie

Microsoft product teams are actively working to expand support to more platforms. Check back frequently to learn about new platform integrations.

## Authentication requirements

This section provides platform-specific authentication requirements and setup instructions for registry sync.

### Amazon Bedrock

To set up a connection to an Amazon Bedrock environment for the registry sync, verify that you have the permission, context, and these Amazon Bedrock credentials:

*Se MS Learn för full dokumentation.*

## MS Learn-källa
[Agent Registry Sync](https://learn.microsoft.com/microsoft-agent-365/admin/agent-registry)

## Relaterade notes
- Agent 365 Index

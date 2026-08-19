---
domain: m365-e7
id: "M365-AGENT-MAP-001"
title: "Use Agent Map in the Microsoft 365 admin center - Microsoft 365 admin"
sources: ["m365maps E7"]
ms-learn: "https://learn.microsoft.com/microsoft-365/admin/manage/agent-map"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#agents", "#management"]
group: "management"
---

# Use Agent Map in the Microsoft 365 admin center - Microsoft 365 admin

## Översikt

Agent Map — en del av Microsoft 365 E7. Se [Microsoft Learn](https://learn.microsoft.com/microsoft-365/admin/manage/agent-map) för full dokumentation.

## Innehåll

Important

This feature is available within Microsoft 365 admin center based on licensed subscription. To view your licensed subscriptions in the [Microsoft 365 admin center], select **Billing** \> **Licenses** \> **Subscriptions**. For more information, see [Plans and licensing].

Agent Map in the Microsoft 365 admin center gives IT and AI admins a visual way to understand and manage the agents running in their tenant. Instead of relying only on list-based views, Agent Map groups agents by the platform they were created on, making it easier to interpret large agent estates and spot adoption patterns at a glance.

Use Agent Map to explore your organization\'s agent landscape, filter to specific subsets (such as ownerless agents), and drill into individual agents to review key details like ownership, configuration, and activity. You can also view how agents relate to each other, helping you understand dependencies and interactions as your agent footprint grows.

[![Screenshot showing the Agent Map, which provides an inventory of agents in the Microsoft 365 admin center.]][3]

You can use the Agent Map to address what needs your attention, rather than agent inventory details. Use the Agent Map accomplish the following actions:

- Spot patterns fast by identifying clusters of agents across your tenant.

- Slice the map with built-in filters to focus on the agents that matter right now. Filter by Status, Publisher type, Platform, Channel, Data source, or Usage.

  ::: NOTE

  Usage is supported via Agent365 observability data for tenants with below 4,000 agents.
  :::

- Track key signals at a glance with high-level metrics and agent-level indicators.

- Drill into any agent to review important details such as publisher, type, platform, version, and connectivity.

The Map complements the Registry by offering a more visual and scalable solution for environments with large numbers of agents.

## View Agent Map

Use the following steps to view the Agent Map:

1.  Sign in to the Microsoft 365 admin center.
2.  In the left navigation pane, select **Agents** \> **All Agents** \> **Map**.

When you select the **Map** tab, the map loads agents from your tenant and displays them as icons grouped by platform and other metrics.

Agent Map is available to all Microsoft 365 Copilot administrators with an E7 (Agent 365) license. To access the Agent Map, your role must be either a **Global Administrator** or an **AI Administrator**. For more information about agent management roles, see [Agent management roles and permissions].

## Agent Map clusters

By default, Agent Map clusters agents by the platform or by the builder the group of agents were created by. Each cluster appears as its own group on the map, so you can quickly view how agents are distributed across your environment.

*Se MS Learn för full dokumentation.*

## MS Learn-källa
[Agent Map](https://learn.microsoft.com/microsoft-365/admin/manage/agent-map)

## Relaterade notes
- Agent 365 Index

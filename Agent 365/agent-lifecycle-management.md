---
domain: m365-e7
id: "M365-AGENT-LM-001"
title: "Governance and Lifecycle actions for agents available in Microsoft 365 admin center - Microsoft 365 admin"
sources: ["m365maps E7"]
ms-learn: "https://learn.microsoft.com/microsoft-365/admin/manage/agent-actions"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#agents", "#management"]
group: "management"
---

# Governance and Lifecycle actions for agents available in Microsoft 365 admin center - Microsoft 365 admin

## Översikt

Agent Lifecycle Management — en del av Microsoft 365 E7. Se [Microsoft Learn](https://learn.microsoft.com/microsoft-365/admin/manage/agent-actions) för full dokumentation.

## Innehåll

The Microsoft 365 admin center provides governance and lifecycle management capabilities for agents through the [Agent Registry]. These capabilities enable administrators to manage agent visibility, access, distribution, and retirement across the tenant.

## Agent actions

Microsoft 365 for government Community Cloud High (GCCH) and Government Community Cloud Moderate (GCCM) environments support publishing agents to the organization.

  Agent actions                               Description
  ------------------------------------------- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  **[Install] and [uninstall]**               Install an agent for users so it\'s ready to use without manual installation by end users. Admin can uninstall a previously installed agent.
  **[Block and unblock]**                     Restrict access to an agent across the organization, preventing any user from using it.
  **[Delete]**                                Delete agents and any associated files. When you delete an agent, it permanently removes the agent from the inventory and deletes all associated files.
  **[Assign a new owner]**                    Assign a new owner to agents that are ownerless or active.
  **[Publish to store]**                      Make a requested agent available to members of your organization by publishing the agent to Agent Store. For more information, see [Actions for requested agents][Publish to store].
  **[Reject submission][Publish to store]**   Prevent a requested agent from becoming available to members of your organization. For more information, see [Actions for requested agents][Publish to store].

For information about actions related to the agent registry list, such as **Export to Excel**, **Upload custom agent**, and **Manage pinned agents**, see [Agent registry in the Microsoft 365 admin center][Agent Registry].

### Install agents

You can install agents across the whole organization or for specific users or groups by using the same controls that work for any other app in the Microsoft 365 admin center.

To install an agent via the Microsoft 365 admin center, follow these steps:

1.  Sign in to the [Microsoft 365 admin center].

2.  From the left navigation bar, select **\... Show all**, and then select **Agents** to expand it.

3.  Under **Agents**, select **All agents**.

4.  In the **All agents** page, make sure **Registry** is selected. Select the **Status** filter and then select **Available**.

5.  From the list of agents, select an agent that isn\'t already installed.

6.  In the agent details pane that opens, immediately under the agent\'s name, select **Install**.

7.  In the **Deploy agent to selected users** pane, decide whether to install the agent to all users or to specific users or groups, and then select **Next**.

    [
    [![Screenshot showing the configuration screen to deploy an agent.]][3]

8.  In the **Review permissions** pane, review the requested permissions for the agent. If the permissions are acceptable, select **Grant admin consent**. For more information, see [Agent permissions].

9.  In the **Permissions requested** window, select **Accept** to grant the permissions to the agent, and then select **Next**.

10. In the **Review & finish** pane, select **Finish deployment**.

Installing an agent affects its availability and functionality in Copilot and in the other host products, such as Outlook, Teams, or Microsoft 365.

### Uninstall agents

You can uninstall first-party or external agents across the whole organization or for specific users or groups by using the same controls that work for any other agent in the Microsoft 365 admin center.

To uninstall an agent via the Microsoft 365 admin center, follow these steps:

*Se MS Learn för full dokumentation.*

## MS Learn-källa
[Agent Lifecycle Management](https://learn.microsoft.com/microsoft-365/admin/manage/agent-actions)

## Relaterade notes
- Agent 365 Index

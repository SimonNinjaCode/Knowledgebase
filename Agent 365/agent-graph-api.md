---
domain: m365-e7
id: "M365-AGENT-GAPI-001"
title: "Graph API for agent registry and agent details"
sources: ["m365maps E7"]
ms-learn: "https://learn.microsoft.com/microsoft-agent-365/admin/graph-api"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#agents", "#management"]
group: "management"
---

# Graph API for agent registry and agent details

## Översikt

Agent Graph API — en del av Microsoft 365 E7. Se [Microsoft Learn](https://learn.microsoft.com/microsoft-agent-365/admin/graph-api) för full dokumentation.

## Innehåll

You can access agent registry data through Graph APIs, which enable scalable and programmatic control over agent management. Currently in preview, Graph API endpoints let administrators automate bulk agent management, streamline onboarding, and integrate governance into existing workflows across agents in Microsoft 365. Instead of relying on manual, UI-driven agent management, you can use the Graph APIs to accelerate agent management, maintain security and compliance, and ensure agents are available to the right users at the right time.

- **Get all agents in your inventory**: Use the [List packages API], to retrieve a complete list of agents in your tenant for compliance and reporting.

- **Get details for a specific agent**: Use the [Get Copilot package details API] to retrieve detailed metadata for an individual agent, which helps you audit and manage your agent inventory.

These APIs require the AI admin or Global admin role.

Learn more in [Agent and App Package Management API overview (preview)].

------------------------------------------------------------------------

## Feedback 

Need help with this topic?

Want to try using Ask Learn to clarify or guide you through this topic?

Suggest a fix?

------------------------------------------------------------------------

## Additional resources 

------------------------------------------------------------------------

- [
  Last updated on
  2026-05-01

  [1]: # 
  [2]: /blob//agent365-docs/admin/graph-api.md" pr_repo="" pr_branch=""}
  [signing in]: # 
  [List packages API]: /en-us/microsoft-365-copilot/extensibility/api/admin-settings/package/copilotpackages-list 
  [Get Copilot package details API]: /en-us/microsoft-365-copilot/extensibility/api/admin-settings/package/copilotpackagedetail-get 
  [Agent and App Package Management API overview (preview)]: /en-us/microsoft-365-copilot/extensibility/api/admin-settings/package/overview

## MS Learn-källa
[Agent Graph API](https://learn.microsoft.com/microsoft-agent-365/admin/graph-api)

## Relaterade notes
- Agent 365 Index

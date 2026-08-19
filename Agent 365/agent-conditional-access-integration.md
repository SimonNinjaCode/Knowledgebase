---
domain: m365-e7
id: "M365-AGENT-CA-001"
title: "Conditional Access for Agent Identities in Microsoft Entra"
sources: ["m365maps E7"]
ms-learn: "https://learn.microsoft.com/entra/identity/conditional-access/agent-id"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#agents", "#identity-access"]
group: "identity-access"
---

# Conditional Access for Agent Identities in Microsoft Entra

## Översikt

Agent Conditional Access Integration — en del av Microsoft 365 E7. Se [Microsoft Learn](https://learn.microsoft.com/entra/identity/conditional-access/agent-id) för full dokumentation.

## Innehåll

Conditional Access is an intelligent policy engine that helps organizations control how users and agent identities access corporate resources. It brings together real-time signals such as user\'s context, device, location, and session risk information to determine when to allow, block, or limit access, or require more verification steps.

Learn about Conditional Access and agent identities:

- High-level overview of Conditional Access: [What is Conditional Access?]
- Guide to managing agent identities across your organization: [Manage agent identities in your organization].
- Policy templates:
  - [Block high-risk agent identities]
  - [Configure policy for autonomous agent access]
  - [Configure policy for on-behalf-of agent access]

## Attribute-driven Conditional Access

As the number of agent identities grows, individually adding each agent identity across every Conditional Access policy becomes operationally unsustainable. Before you start creating Conditional Access policies, it\'s important to organize the agent identities, enabling consistent, scalable access control enforcement.

Custom security attributes in Microsoft Entra ID are a convenient way to organize agent identities at scale. Custom security attributes are business-specific key-value attributes that you can define and assign to Microsoft Entra objects, including users, agent identities, and enterprise applications (service principals). These attributes let you store meaningful information about each agent identity, like the sensitivity level of the data the agent handles.

The following diagram shows that agent identities with the \"Data Sensitivity\" attribute set to \"Confidential\" are blocked; all other agents are excluded and allowed. These custom security attribute values can be used as filters during Conditional Access evaluation, enabling attribute-based targeting. Instead of maintaining a manual select agent identities or target resources, you can define a rule such as: \"If the Data Sensitivity attribute is Confidential,\" then block access. The policy then automatically applies to every agent identity with those attributes, including the ones added in the future.

[![Diagram showing the Conditional Access flow for agent identities.]][3]

The following table shows a few examples of how you can categorize your agent identities:

  Attribute             Type      Example values
  --------------------- --------- -------------------------------------------------
  AgentClassification   String    Orchestrator, SubAgent, Connector
  DataSensitivity       String    Public, Internal, Confidential, Restricted
  AgentOrigin           String    Copilot Studio, MicrosoftFoundry, non-Microsoft
  ForPublicUse          Boolean   True or false

Custom security attributes aren\'t just for agent identities. You can also use them to classify the corporate resources the agents access, then use both in your Conditional Access policies for a consistent labeling system across the entire access chain. For more information, see [What are custom security attributes in Microsoft Entra ID].

## Agent identity blueprints

Another way to apply a Conditional Access policy to multiple agent identities at once is by targeting their parent agent identity blueprint. Every agent identity is derived from an agent identity blueprint, which defines its configuration and governance model. Applying a policy at the blueprint level automatically covers all agent identities derived from it, including any new ones added in the future. Targeting the agent identity blueprint does not cover agents\' user accounts.

The following diagram shows that only agent identities associated with blueprint \"A\" are granted access; all other agents are excluded and blocked.

[![Diagram showing the Conditional Access flow for agent identity blueprints.]][4]

*Se MS Learn för full dokumentation.*

## MS Learn-källa
[Agent Conditional Access Integration](https://learn.microsoft.com/entra/identity/conditional-access/agent-id)

## Relaterade notes
- Agent 365 Index

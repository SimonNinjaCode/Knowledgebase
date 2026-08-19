---
domain: m365-e7
id: "M365-AGENT-IG-001"
title: "Governing Agent Identities - Microsoft Entra ID Governance"
sources: ["m365maps E7"]
ms-learn: "https://learn.microsoft.com/entra/id-governance/agent-id-governance-overview"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#agents", "#identity-access"]
group: "identity-access"
---

# Governing Agent Identities - Microsoft Entra ID Governance

## Översikt

Agent Identity Governance — en del av Microsoft 365 E7. Se [Microsoft Learn](https://learn.microsoft.com/entra/id-governance/agent-id-governance-overview) för full dokumentation.

## Innehåll

Microsoft Entra allows you to ensure that the right people have the right access to the right apps and services at the right time. With the addition of the Microsoft agent identity platform, managing the access rights of agents in the same way is just as important in the governance lifecycle of your organization\'s identities. The Microsoft agent identity platform introduces the concept of Agent Identities (IDs). Agent identities are accounts within Microsoft Entra ID that provide unique identification and authentication capabilities for AI agents.

This allows agent identities to be governed with Microsoft Entra features in the same style as you would govern human identities. With Agent identities, you can govern and manage the identity and access lifecycle of agents, ensuring the agents have a responsible person providing oversight throughout the agent lifecycle and agent\'s access does not persist longer than it is needed. This article provides an overview of how Microsoft Entra can be utilized to govern agent identities.

## License requirements

Microsoft Entra Agent ID is a product within Microsoft Entra that provides the platform for creating and managing agent identities and agent identity blueprints. Agent ID is available for all Microsoft Entra customers.

Integration with [Microsoft Agent 365] enables agents to operate across Microsoft 365 services and enterprise workflows, which requires a **Microsoft Agent 365** license for each user. For pricing details, see [Microsoft Agent 365 plans and pricing].

Technical requirements that enable the security features for agents within Microsoft Entra require **Microsoft 365 E5** or the following licensing:

- **Conditional Access for agents**: Microsoft Entra ID P1
- **ID Protection for agents**: Microsoft Entra ID P2
- **ID Governance for agents**: Microsoft Entra ID P1
- **Network controls for agents**: Microsoft Entra Internet Access, included in Microsoft Entra Suite or licensed separately. For more information, see [What is Global Secure Access].

## Agent identities basics

Historically, AI agents would rely upon tools to interact with various applications and systems, and each of those tools would have their own identities in those applications and systems. Some of those tools would use service principals to authenticate to Microsoft services via Microsoft Graph or Microsoft Azure APIs. [Microsoft Entra Agent ID] introduces support for identities for the agents themselves, with four new types of object: agent identity blueprint, agent identity blueprint principal, agent identity, and agent user. Through the [agent identity blueprint], the agent can create one or more agent identities, and optionally an agent user for each agent identity. Each agent identity and agent user can have distinct access rights.

![Diagram of the relationship of Microsoft Entra Agent ID objects in a single tenant.]

For a multitenant-capable agent, an agent identity blueprint principal can be brought into the tenant with resources so it can create agent identities in that tenant, similar to how a multitenant application can have a service principal in each tenant.

![Diagram of the relationship of Microsoft Entra Agent ID objects in multiple tenants.]

The agent identity and the agent user allow AI agents to take on digital identities within Microsoft Entra. Once agent identities are created, these agent identities are able to be governed using lifecycle and access features. Sponsors can be assigned to agent identities after creation. Sponsors of agent identities are human users accountable for making decisions about its lifecycle and access. For more information about the role of a sponsor of agent identities, see: [Administrative relationships for agent IDs].

### Agent identities in other Microsoft products and portals

*Se MS Learn för full dokumentation.*

## MS Learn-källa
[Agent Identity Governance](https://learn.microsoft.com/entra/id-governance/agent-id-governance-overview)

## Relaterade notes
- Agent 365 Index

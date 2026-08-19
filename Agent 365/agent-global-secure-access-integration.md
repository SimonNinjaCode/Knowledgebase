---
domain: m365-e7
id: "M365-AGENT-GSA-001"
title: "Learn about Secure Web and AI Gateway for Microsoft Copilot Studio agents - Global Secure Access"
sources: ["m365maps E7"]
ms-learn: "https://learn.microsoft.com/entra/global-secure-access/concept-secure-web-ai-gateway-agents"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#agents", "#security"]
group: "security"
---

# Learn about Secure Web and AI Gateway for Microsoft Copilot Studio agents - Global Secure Access

## Översikt

Agent Global Secure Access Integration — en del av Microsoft 365 E7. Se [Microsoft Learn](https://learn.microsoft.com/entra/global-secure-access/concept-secure-web-ai-gateway-agents) för full dokumentation.

## Innehåll

As organizations adopt autonomous and interactive AI agents to perform tasks previously handled by humans, administrators need visibility and control over agent network activity. Global Secure Access for agents provides network security controls for Microsoft Copilot Studio agents, enabling you to apply the same security policies to agents that you use for users.

With Global Secure Access for agents, you can regulate how agents use knowledge, tools, and actions to access external resources. You can apply network security policies including web content filtering, threat intelligence filtering, and network file filtering to agent traffic.

## How network security for Copilot Studio agents works

To enforce network security controls on Copilot Studio agents, you forward agent traffic to Global Secure Access\'s globally distributed proxy service. You enable traffic forwarding in the Power Platform Admin Center on a per-environment or per-environment-group basis.

Agent traffic forwarding applies to multiple traffic types, including:

- HTTP Node traffic
- Custom connectors
- MCP Server Connector

Once agent traffic is forwarded to Global Secure Access, you can apply security policies to the traffic. The service evaluates agent traffic against your configured security policies, similar to how it evaluates user traffic.

![Diagram showing agent traffic flowing through Global Secure Access to protected resources.]

## Security policies for agents

Security policies for agents are configured using the baseline profile in Global Secure Access. The baseline profile applies security policies at the tenant level, ensuring consistent security controls across all agent traffic.

## How to get started

Microsoft Entra Agent ID is a product within Microsoft Entra that provides the platform for creating and managing agent identities and agent identity blueprints. Agent ID is available for all Microsoft Entra customers.

Integration with [Microsoft Agent 365] enables agents to operate across Microsoft 365 services and enterprise workflows, which requires a **Microsoft Agent 365** license for each user. For pricing details, see [Microsoft Agent 365 plans and pricing].

Technical requirements that enable the security features for agents within Microsoft Entra require **Microsoft 365 E5** or the following licensing:

- **Conditional Access for agents**: Microsoft Entra ID P1
- **ID Protection for agents**: Microsoft Entra ID P2
- **ID Governance for agents**: Microsoft Entra ID P1
- **Network controls for agents**: Microsoft Entra Internet Access, included in Microsoft Entra Suite or licensed separately. For more information, see [What is Global Secure Access].

## Next steps

- [Configure network security for Microsoft Copilot Studio agents]
- [Learn about Global Secure Access]
- [Learn about traffic forwarding profiles]

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

*Se MS Learn för full dokumentation.*

## MS Learn-källa
[Agent Global Secure Access Integration](https://learn.microsoft.com/entra/global-secure-access/concept-secure-web-ai-gateway-agents)

## Relaterade notes
- Agent 365 Index

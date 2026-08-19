---
domain: m365-e7
id: "M365-AGENT-IDP-001"
title: "ID Protection for Agents - Microsoft Entra ID Protection"
sources: ["m365maps E7"]
ms-learn: "https://learn.microsoft.com/entra/id-protection/concept-risky-agents"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#agents", "#identity-access"]
group: "identity-access"
---

# ID Protection for Agents - Microsoft Entra ID Protection

## Översikt

Agent ID Protection Integration — en del av Microsoft 365 E7. Se [Microsoft Learn](https://learn.microsoft.com/entra/id-protection/concept-risky-agents) för full dokumentation.

## Innehåll

As organizations adopt, build, and deploy autonomous AI agents, the need to monitor and protect those agents becomes critical. Microsoft Entra ID Protection helps protect your organization by automatically detecting and responding to identity-based risks on agents that use the [Microsoft Entra Agent ID] platform.

## Prerequisites

### Roles

To use our Risky Agent reports, you must have one of the following administrator roles assigned.

- [Security Administrator]
- [Security Operator]
- [Security Reader]

To configure policies that use Agent Risk as a condition, you must have the [Conditional Access Administrator] role assigned.

### Licensing

Microsoft Entra Agent ID is a product within Microsoft Entra that provides the platform for creating and managing agent identities and agent identity blueprints. Agent ID is available for all Microsoft Entra customers.

Integration with [Microsoft Agent 365] enables agents to operate across Microsoft 365 services and enterprise workflows, which requires a **Microsoft Agent 365** license for each user. For pricing details, see [Microsoft Agent 365 plans and pricing].

Technical requirements that enable the security features for agents within Microsoft Entra require **Microsoft 365 E5** or the following licensing:

- **Conditional Access for agents**: Microsoft Entra ID P1
- **ID Protection for agents**: Microsoft Entra ID P2
- **ID Governance for agents**: Microsoft Entra ID P1
- **Network controls for agents**: Microsoft Entra Internet Access, included in Microsoft Entra Suite or licensed separately. For more information, see [What is Global Secure Access].

## How it works

Because agents can operate autonomously and on behalf of a user, they can display unique sign-in behavior. Agents can take initiative, interact with sensitive data, and operate at scale. Microsoft Entra ID Protection for agents is designed to identify and mitigate risks associated with these capabilities. The system determines a baseline for an agent\'s normal activity and then continuously monitors it for anomalies in Microsoft Entra ID. Once an agent exhibits suspicious behavior, ID Protection flags the activity and marks it as risky.

## Activities contributing to risk

The following table provides the anomalous activities that can contribute to the agent being flagged for risk. At this time, all risk detections for risky agents are offline.

  Agent risk detection                  Detection type   Description                                                                                                                                                                                          riskEventType
  ------------------------------------- ---------------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --------------------------------
  Unfamiliar resource access            Offline          Agent targeted resources that it doesn\'t usually access. This detection can mean that an attacker is trying to access sensitive resources beyond the agent\'s intended purpose.                     unfamiliarResourceAccess
  Sign-in spike                         Offline          Agent made a higher number of sign-ins compared to its usual sign-in frequency. This spike can be an indicator that an attacker is using automation or a toolkit.                                    signInSpike
  Failed access attempt                 Offline          Agent attempted and failed to access resources for which it isn\'t authorized. This detection can indicate an attacker is attempting to replay an agent\'s token against an unauthorized resource.   failedAccessAttempt
  Sign-in by risky user                 Offline          Agent signed in on behalf of a risky user during a delegated authentication. This detection means that an attacker might be using 

*Se MS Learn för full dokumentation.*

## MS Learn-källa
[Agent ID Protection Integration](https://learn.microsoft.com/entra/id-protection/concept-risky-agents)

## Relaterade notes
- Agent 365 Index

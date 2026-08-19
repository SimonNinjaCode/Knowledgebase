---
domain: m365-e7
id: "M365-AGENT-PT-001"
title: "Agent templates"
sources: ["m365maps E7"]
ms-learn: "https://learn.microsoft.com/microsoft-agent-365/admin/agent-template"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#agents", "#management"]
group: "management"
---

# Agent templates

## Översikt

Agent Policy Templates — en del av Microsoft 365 E7. Se [Microsoft Learn](https://learn.microsoft.com/microsoft-agent-365/admin/agent-template) för full dokumentation.

## Innehåll

Agent 365 templates provide a streamlined approach to governance and security management for agents in your organization. Templates bundle predefined policies and protections from Microsoft Entra, Purview, SharePoint Online, and Defender to ensure consistent security and compliance controls across all your agents.

This article covers how to create, update, and delete policy templates, and explains supported default and custom policies.

## What is a template?

An Agent 365 template is a collection of predefined governance and security policies that you apply to agents to enforce organizational standards. Use templates to:

- Standardize governance across all agents in your organization.
- Reduce manual configuration by applying multiple policies at one time.
- Ensure compliance with security and regulatory requirements.

## Template types

To enhance governance and security for agents, apply a template that includes predefined policies and protections.

### Default templates

Microsoft provides default templates that include essential security and compliance controls from:

- Microsoft Entra
- Microsoft Purview
- SharePoint Online
- Microsoft Defender

Your tenant has default policies for all agents. The platform automatically enables some policies, while others require more configuration based on your organization\'s setup and requirements.

  Policy name                                             Description
  ------------------------------------------------------- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Purview audit enabled                                   Audit trails log all activities and provide clear observability. For more information, see [Use Microsoft Purview to manage data security & compliance for Microsoft Agent 365].
  Detect sensitive information (DSPM) in AI interaction   Data security controls safeguard against sensitive data leaks and oversharing. For more information, about Data Security Posture Management (DSPM), see [Learn about Data Security Posture Management for AI].
  Purview AI compliance assessment                        Continuous monitoring evaluates agents for compliance gaps and identifies areas needing attention. For more information, see [Microsoft Purview Compliance Manager].
  Identity protection                                     Detect agent identity threats by flagging anomalous activities involving agents. For more information, see [ID Protection for agents].
  Network visibility                                      Enable network visibility to agents and external resources. For more information, see [Configure Secure Web and AI Gateway for Microsoft Copilot Studio agents].
  Lifecycle management for agents                         Govern Microsoft Entra agent IDs at scale with lifecycle policies. For more information, see [Governing Agent Identities].
  Agent access insights                                   Provides insights on agents accessing SharePoint and OneDrive sites. For more information, see [Microsoft Agent 365 integration with SharePoint Online and OneDrive].
  Restrict external sharing of sites and its content      Provides capability to restrict agents and Copilot from discovering specific sites and content. For more information, see [Restrict SharePoint site access with Microsoft 365 groups and Microsoft Entra security groups].
  Access control for sites and OneDrive                   For more information, see Microsoft Agent 365 integration with SharePoint Online and OneDrive.
  Content permissions insights                            For more information, see [Restrict discovery of SharePoint sites and content].
  AI real time protection and investigation               Detect and block suspicious agent activity during runtime. For more information, see [Detect, b

*Se MS Learn för full dokumentation.*

## MS Learn-källa
[Agent Policy Templates](https://learn.microsoft.com/microsoft-agent-365/admin/agent-template)

## Relaterade notes
- Agent 365 Index

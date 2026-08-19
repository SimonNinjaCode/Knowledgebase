---
source: https://learn.microsoft.com/microsoft-agent-365/admin/agent-template
last_verified: 2026-08-19
status: current
---

# Agent Policy Templates

## Overview

Agent 365 templates bundle predefined governance and security policies from Microsoft Entra, Purview, SharePoint Online, and Defender. Apply templates to agents to enforce organizational standards, reduce manual configuration, and ensure compliance.

## Template Types

### Default Templates

Microsoft provides default policies that apply to all agents in the tenant. Some are automatically enabled; others require configuration.

| Policy | Description | Source Product |
|---|---|---|
| Purview audit enabled | Audit trails log all agent activities | Purview |
| Detect sensitive information (DSPM) | Safeguard against sensitive data leaks in AI interactions | Purview |
| Purview AI compliance assessment | Continuous compliance gap monitoring | Purview |
| Identity protection | Flag anomalous agent identity activities | Entra ID Protection |
| Network visibility | Enable visibility into agent network traffic and external resources | Global Secure Access |
| Lifecycle management | Govern agent identities at scale with lifecycle policies | Entra ID Governance |
| Agent access insights | Track agents accessing SharePoint and OneDrive sites | SharePoint Online |
| Restrict external sharing | Prevent agents and Copilot from discovering specific sites and content | SharePoint Online |
| Access control for sites and OneDrive | Site-level access control for agents | SharePoint Online |
| Content permissions insights | Report on content permission exposure to agents | SharePoint Online |
| AI real-time protection | Detect and block suspicious agent activity during runtime | Defender |

### Custom Templates

Create custom templates to:

- Combine specific policies for different agent classifications
- Apply stricter controls to agents handling confidential data
- Define separate governance profiles for different business units

## Template Operations

| Action | Description |
|---|---|
| Create | Build a new template with selected policies |
| Update | Modify policies within an existing template |
| Delete | Remove a custom template (default templates cannot be deleted) |
| Apply | Assign a template to one or more agents |

## Related Documentation

- [Conditional Access](Conditional-Access.md) — Attribute-based access policies
- [Purview for AI Agents](Purview-AI-Compliance.md) — Data security and compliance
- [Lifecycle Management](Lifecycle-Management.md) — Agent deployment and retirement

## Source

- [Agent Templates — MS Learn](https://learn.microsoft.com/microsoft-agent-365/admin/agent-template)

# Agent 365

Microsoft Agent 365 is the unified platform for building, managing, and securing AI agents within Microsoft 365. Introduced with M365 E7 (March 2026), it treats AI agents as first-class identities alongside users and devices.

## Capabilities

### Identity & Access

| Capability | Description | Reference |
|---|---|---|
| [Conditional Access](Conditional-Access.md) | Attribute-driven and blueprint-level CA policies for agent identities | [MS Learn](https://learn.microsoft.com/entra/identity/conditional-access/agent-id) |
| [Identity Governance](Identity-Governance.md) | Lifecycle and access governance for agent identities with sponsor accountability | [MS Learn](https://learn.microsoft.com/entra/id-governance/agent-id-governance-overview) |
| [ID Protection](ID-Protection.md) | Risk detection and automated response for agent identity anomalies | [MS Learn](https://learn.microsoft.com/entra/id-protection/concept-risky-agents) |

### Security

| Capability | Description | Reference |
|---|---|---|
| [Defender Integration](Defender-Integration.md) | Real-time protection, threat detection, and investigation for AI agents | [MS Learn](https://learn.microsoft.com/defender-xdr/security-for-ai/ai-agent-detection-protection) |
| [Global Secure Access](Global-Secure-Access.md) | Network security controls for agent traffic via Secure Web and AI Gateway | [MS Learn](https://learn.microsoft.com/entra/global-secure-access/concept-secure-web-ai-gateway-agents) |

### Compliance

| Capability | Description | Reference |
|---|---|---|
| [Purview for AI Agents](Purview-AI-Compliance.md) | DSPM, DLP, Communication Compliance, Insider Risk, Information Protection, and Data Lifecycle for AI interactions | [MS Learn](https://learn.microsoft.com/purview/ai-microsoft-purview) |

### Management & APIs

| Capability | Description | Reference |
|---|---|---|
| [Lifecycle Management](Lifecycle-Management.md) | Install, uninstall, block, delete, and assign ownership of agents | [MS Learn](https://learn.microsoft.com/microsoft-365/admin/manage/agent-actions) |
| [Agent Map](Agent-Map.md) | Visual inventory of agents grouped by platform, with filters and drill-down | [MS Learn](https://learn.microsoft.com/microsoft-365/admin/manage/agent-map) |
| [Registry Sync](Registry-Sync.md) | Synchronize agents from AWS Bedrock, Google Vertex, Salesforce, Databricks | [MS Learn](https://learn.microsoft.com/microsoft-agent-365/admin/agent-registry) |
| [Observability](Observability.md) | Agent monitoring, activity tracing, and business impact metrics | [MS Learn](https://learn.microsoft.com/microsoft-agent-365/admin/monitor-agents) |
| [Graph API](Graph-API.md) | Programmatic agent registry access for automation and bulk management | [MS Learn](https://learn.microsoft.com/microsoft-agent-365/admin/graph-api) |
| [Policy Templates](Policy-Templates.md) | Bundled governance policies from Entra, Purview, Defender, and SharePoint | [MS Learn](https://learn.microsoft.com/microsoft-agent-365/admin/agent-template) |
| [Tool Controls](Tool-Controls.md) | Manage MCP servers and AI-powered tools available to agents | [MS Learn](https://learn.microsoft.com/microsoft-365/admin/manage/manage-tools-for-agent) |

## Licensing

| Feature | Required License |
|---|---|
| Agent identities (Agent ID) | Any Microsoft Entra (free) |
| Agent 365 platform features | Microsoft Agent 365 (M365 E7) |
| Conditional Access for agents | Microsoft Entra ID P1 |
| ID Protection for agents | Microsoft Entra ID P2 |
| ID Governance for agents | Microsoft Entra ID P1 |
| Network controls (GSA) | Microsoft Entra Internet Access |

## References

- [Agent 365 — Microsoft Learn](https://learn.microsoft.com/microsoft-agent-365/)
- [M365 Maps E7](https://m365maps.com/files/Microsoft-365-E7.htm)
- [M365 E7 Overview](../Strategy/m365-e7-overview.md)

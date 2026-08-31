---
layout:
  width: wide
source: https://learn.microsoft.com/entra/global-secure-access/concept-secure-web-ai-gateway-agents
last_verified: 2026-08-19
ms_learn_updated: 2026-06-15
status: current
---

# Global Secure Access for AI Agents

## Overview

Global Secure Access for agents provides network security controls for Microsoft Copilot Studio agents, applying the same security policies used for user traffic. It regulates how agents use knowledge, tools, and actions to access external resources.

## Capabilities

| Capability | Description |
|---|---|
| Web content filtering | Block or allow agent access to specific web content categories |
| Threat intelligence filtering | Block agent traffic to known malicious destinations |
| Network file filtering | Inspect and control file transfers through agent connections |
| Traffic forwarding | Route agent traffic through Global Secure Access proxy for inspection |

## How It Works

1. **Traffic forwarding** is enabled in Power Platform Admin Center (per-environment or per-environment-group)
2. Agent traffic routes through Global Secure Access's globally distributed proxy
3. Security policies evaluate agent traffic the same way user traffic is evaluated
4. Policies are configured via the **baseline profile** in Global Secure Access (tenant-level)

### Supported Traffic Types

- HTTP Node traffic
- Custom connectors
- MCP Server Connector

## Licensing

| Feature | Required License |
|---|---|
| Agent ID platform | Any Microsoft Entra (free) |
| Agent 365 integration | Microsoft Agent 365 (M365 E7) |
| Conditional Access for agents | Microsoft Entra ID P1 |
| Network controls for agents | Microsoft Entra Internet Access (included in Entra Suite or standalone). Agent 365 is included with M365 E7 and available as add-on to E5/A5/Business Premium |

## Getting Started

1. Ensure Microsoft Entra Internet Access is licensed and configured
2. Enable traffic forwarding for target environments in Power Platform Admin Center
3. Configure security policies in the Global Secure Access baseline profile
4. Monitor agent traffic alongside user traffic in Global Secure Access reports

## Related Documentation

- [Conditional Access](Conditional-Access.md) — Access policies for agent identities
- [Defender Integration](Defender-Integration.md) — Runtime threat protection
- [Tool Controls](Tool-Controls.md) — Manage MCP servers available to agents

## Source

- [Secure Web and AI Gateway for Copilot Studio Agents — MS Learn](https://learn.microsoft.com/entra/global-secure-access/concept-secure-web-ai-gateway-agents)

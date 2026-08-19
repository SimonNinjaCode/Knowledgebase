---
domain: m365-e7
id: "M365-AGENT-DEF-001"
title: "Detect, block, and investigate threats to AI agents using Microsoft Defender  (Preview) - Microsoft Defender XDR"
sources: ["m365maps E7"]
ms-learn: "https://learn.microsoft.com/defender-xdr/security-for-ai/ai-agent-detection-protection"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#agents", "#security"]
group: "security"
---

# Detect, block, and investigate threats to AI agents using Microsoft Defender  (Preview) - Microsoft Defender XDR

## Översikt

Agent Defender for Cloud Apps Integration — en del av Microsoft 365 E7. Se [Microsoft Learn](https://learn.microsoft.com/defender-xdr/security-for-ai/ai-agent-detection-protection) för full dokumentation.

## Innehåll

Deployed AI agents operate autonomously, invoking tools, accessing data, and taking actions across systems in response to natural‑language input. This makes continuous detection, runtime protection, and investigation critical. Microsoft Defender detects suspicious and malicious agent behavior, blocks dangerous actions in real time, provides alerts in near‑real‑time, and enables security teams to investigate incidents and trace the full root cause and blast radius.

This article explains how Microsoft Defender detects, blocks, and enables security teams to investigate threats to AI agents managed through [Microsoft Agent 365], including the extended detection and protection capabilities available for supported agent platforms.

Some capabilities described in this article currently require onboarding through Microsoft Defender for Cloud Apps. This is a temporary configuration that will be part of the Agent 365 product experience. Starting July 1, 2026, your organization needs an [Agent 365 subscription] to continue using agent protection and visibility capabilities.

## Block unsafe AI agent actions in real time

Microsoft Defender provides real-time protection (RTP) to prevent AI agents from performing unsafe actions during runtime. Defender integrates directly with [Work IQ MCP] to evaluate supported agent-initiated tool invocations before they execute. If Defender determines that an action is risky, it blocks the action before the agent performs it, preventing harmful behavior.

Real-time protection is available only for AI agents that use tools currently supported in Work IQ MCP. Agents that rely on unsupported tools or do not integrate with Work IQ MCP are outside the scope of this capability.

Real-time protection focuses on high-confidence threats, including:

- Attempts to extract or exfiltrate system instructions or internal tool details
- Direct attempts to leak sensitive data
- Misuse of internal-only tools
- Routing information to untrusted or malicious destinations
- Use of obfuscated or hidden content to manipulate agent behavior
- Credential leakage through legitimate channels such as email or external APIs

For agents built with Microsoft Copilot Studio, Microsoft Defender also provides real-time protection by evaluating model prompts and responses. This capability doesn\'t depend on Work IQ.

When Microsoft Defender blocks an action, it generates a detailed alert that explains what was blocked, why the action was considered risky, and which agent, user, and tool were involved. This ensures security teams can investigate blocked actions using familiar Defender workflows.

### Enable real-time protection

To enable real-time protection for your AI agents:

1.  Open the [Microsoft Defender portal]

2.  Select **System** \> **Settings** \> **Security for AI agents**. This opens the [Security for AI agents settings page].

3.  Make sure that **Security for AI agents** is toggled on.

4.  Make sure that **Agent 365** is connected under **AI real-time protection & investigation**.

    [
    [![Screenshot of Security for AI agents settings showing toggled on switch and connected status for Agent 365 and Copilot Studio.]][3]

5.  To enable the extended real-time protection capabilities for Microsoft Copilot Studio agents, make sure that **Copilot Studio** is connected under **AI real-time protection & investigation**.

    For more information, see [Copilot Studio integration in Microsoft Defender for Cloud Apps].

## Detect AI agent threats in near-real-time

*Se MS Learn för full dokumentation.*

## MS Learn-källa
[Agent Defender for Cloud Apps Integration](https://learn.microsoft.com/defender-xdr/security-for-ai/ai-agent-detection-protection)

## Relaterade notes
- Agent 365 Index

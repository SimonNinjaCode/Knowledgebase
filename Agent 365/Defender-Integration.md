---
source: https://learn.microsoft.com/defender-xdr/security-for-ai/ai-agent-detection-protection
last_verified: 2026-08-19
status: current
---

# Defender Integration for AI Agents

## Overview

Microsoft Defender provides detection, real-time blocking, and investigation capabilities for AI agents managed through Microsoft Agent 365. It integrates with Work IQ MCP to evaluate agent-initiated tool invocations before execution.

> **Note:** Starting July 1, 2026, an Agent 365 subscription is required to use agent protection and visibility capabilities. The Defender for Cloud Apps onboarding requirement is temporary and will be integrated into the Agent 365 product experience.

## Capabilities

| Capability | Description |
|---|---|
| Real-Time Protection (RTP) | Blocks unsafe agent actions during runtime before they execute |
| Near-Real-Time Detection | Alerts on suspicious agent behavior patterns |
| Investigation | Full root cause and blast radius tracing for agent incidents |

## Real-Time Protection

Defender integrates with Work IQ MCP to evaluate supported agent-initiated tool invocations before execution. If an action is deemed risky, it is blocked before the agent performs it.

### Threats Blocked

| Threat | Description |
|---|---|
| System instruction extraction | Attempts to exfiltrate internal tool details or system prompts |
| Data exfiltration | Direct attempts to leak sensitive data |
| Tool misuse | Unauthorized use of internal-only tools |
| Untrusted routing | Routing information to malicious or untrusted destinations |
| Obfuscated manipulation | Hidden content designed to manipulate agent behavior |
| Credential leakage | Credential exposure through legitimate channels (email, APIs) |

### Scope

- **Agents using Work IQ MCP tools:** Full real-time protection
- **Copilot Studio agents:** Additional RTP via model prompt/response evaluation (independent of Work IQ)
- **Agents without Work IQ integration:** Not covered by RTP

### Enable Real-Time Protection

1. Open the [Microsoft Defender portal](https://security.microsoft.com)
2. Navigate to **System** > **Settings** > **Security for AI agents**
3. Toggle **Security for AI agents** to on
4. Verify **Agent 365** is connected under **AI real-time protection & investigation**
5. (Optional) Connect **Copilot Studio** for extended RTP on Studio agents

## Alert Details

When Defender blocks an action, the alert includes:

- What was blocked and why
- Risk classification
- Agent identity involved
- User context (if delegated)
- Tool and action details

All alerts integrate into the standard Defender XDR incident queue for investigation.

## Related Documentation

- [ID Protection](ID-Protection.md) — Identity risk detection for agents
- [Global Secure Access](Global-Secure-Access.md) — Network-level security for agent traffic
- [Purview for AI Agents](Purview-AI-Compliance.md) — Data security and compliance

## Source

- [Detect, block, and investigate threats to AI agents — MS Learn](https://learn.microsoft.com/defender-xdr/security-for-ai/ai-agent-detection-protection)

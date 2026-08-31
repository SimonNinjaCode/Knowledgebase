---
layout:
  width: wide
source: https://learn.microsoft.com/purview/ai-microsoft-purview
last_verified: 2026-08-19
ms_learn_updated: 2026-06-25
status: current
---

# Purview Data Security and Compliance for AI Agents

## Overview

Microsoft Purview provides data security and compliance controls for AI interactions across Copilots, agents, enterprise AI apps, and third-party LLMs. Use Purview to mitigate risks associated with AI usage and implement protection and governance controls.

## Supported AI App Categories

| Category | Examples |
|---|---|
| **Copilot experiences and agents** | Microsoft 365 Copilot, Security Copilot, Copilot in Fabric, Copilot Studio, Microsoft Facilitator, Channel Agent in Teams |
| **Enterprise AI apps** | Microsoft Foundry, Entra-registered AI apps, Anthropic Claude (Enterprise), ChatGPT Enterprise |
| **Other AI apps** | ChatGPT, Google Gemini, Microsoft Copilot (consumer), DeepSeek — detected via browser activity and Defender for Cloud Apps |

Agents inherit the same security and compliance capabilities as their parent AI app.

## Purview Capabilities for AI

### Data Security Posture Management (DSPM)

The primary entry point for discovering, securing, and applying compliance controls for AI usage across the enterprise.

| Feature | Description |
|---|---|
| AI usage discovery | Identify which AI apps and agents are being used across the organization |
| Risk assessment | Quantify data leakage risk from AI interactions |
| One-click policies | Rapidly deploy recommended protection policies |
| Personalized recommendations | Tailored guidance based on your organization's AI usage patterns |

DSPM is available in two versions: the current DSPM experience and DSPM for AI (classic). Both use existing Purview information protection and compliance management controls.

### Data Loss Prevention (DLP)

| Capability | AI Coverage |
|---|---|
| Prompt/response inspection | Monitor and block sensitive data in AI prompts and responses |
| Policy enforcement | Apply DLP policies to Copilot, enterprise AI, and third-party AI interactions |
| Sensitivity label enforcement | Block AI interactions with content above a specified sensitivity level |

### Communication Compliance

| Capability | AI Coverage |
|---|---|
| AI interaction monitoring | Detect policy violations in AI-generated content and user prompts |
| Regulatory compliance | Monitor AI interactions for compliance with industry regulations |
| Inappropriate content detection | Flag AI outputs that violate organizational communication standards |

### Insider Risk Management

| Capability | AI Coverage |
|---|---|
| AI-specific risk indicators | Detect anomalous AI usage patterns (unusual volume, sensitive topics, data extraction) |
| Agent audit trail | Track agent interactions for insider threat investigation |
| User-agent correlation | Link suspicious AI usage to specific users and agents |

### Information Protection

| Capability | AI Coverage |
|---|---|
| Sensitivity label propagation | Labels follow data into AI prompts and agent context |
| Data classification | Classify AI-generated content and apply appropriate protections |
| Label-based access control | Restrict AI access to content based on sensitivity labels |

### Data Lifecycle Management

| Capability | AI Coverage |
|---|---|
| Retention policies | Apply retention and deletion policies to AI interaction data |
| Agent conversation archiving | Retain agent interaction history for compliance and e-discovery |
| Regulatory hold | Place legal holds on AI interaction data |

## Implementation Priority

1. **Enable DSPM for AI** — get visibility into current AI usage and risk posture
2. **Deploy sensitivity labels** — ensure labels propagate into AI interactions
3. **Configure DLP policies** — block sensitive data in AI prompts and responses
4. **Enable Communication Compliance** — monitor AI interactions for policy violations
5. **Configure Insider Risk** — detect anomalous AI usage patterns
6. **Set retention policies** — ensure AI interaction data meets regulatory requirements

## Related Documentation

- [Defender Integration](Defender-Integration.md) — Runtime threat protection for agents
- [Policy Templates](Policy-Templates.md) — Bundled Purview policies for agents
- [Observability](Observability.md) — Agent activity monitoring

## Source

- [Purview Data Security and Compliance for AI — MS Learn](https://learn.microsoft.com/purview/ai-microsoft-purview)

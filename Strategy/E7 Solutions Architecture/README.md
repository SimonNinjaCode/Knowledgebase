---
domain: m365-e7
title: "M365 E7 — Solutions Architecture"
created: 2026-05-30
updated: 2026-06-22
type: concept
tags: ["#m365-e7", "#solutions-architecture", "#ciso", "#security"]
sources:
  - raw/Reports/notebooklm/m365-e7-techarch-briefing-2026-06-06.md
---

# M365 E7 — Solutions Architecture

Lösningsorienterade arkitekturguider för att skydda data, identiteter och AI-arbetsflöden med Microsoft 365 E7/E5 — ur ett CISO-perspektiv.

## Domäner

| Domän | Beskrivning |
|-------|-------------|
| [Data Security & Protection](data-security.md) | Säkra data i Copilot, Claude Enterprise, Codex; Purview DLP, DSPM, Information Protection |
| [Identity Protection & Zero Trust](identity-protection.md) | Entra Suite, Agent ID, Conditional Access för AI-agenter, ID Governance |
| [DSPM for AI](dspm-ai.md) | Data Security Posture Management — vilka hål täpper den till? Shadow AI, agentdata, känslig data i AI-flöden |
| [Enterprise AI Governance](enterprise-ai-governance.md) | Multi-modell-miljö: Copilot + Claude + Codex; data leakage, docx/pdf/md, compliance |
| [Device & Endpoint Protection](device-protection.md) | Defender för endpunkter, Purview för AI-klienter, Mobile Device Management |

## Principer

- **Zero Trust för AI**: Alla AI-agenter och modeller är opålitliga tills verifierade — oavsett om de är Microsofts, Anthropics eller OpenAIs
- **Data på resa räknas**: Oavsett om data går till Copilot, Claude eller Codex — samma DLP-policyer måste gälla
- **Agent governance före agent adoption**: Innan AI-agenter får access måste Agent Conditional Access, Agent ID Governance och Agent Registry Sync vara på plats

## Relaterade notes
- Agent 365 Index
- Microsoft 365 Copilot Index
- Entra Suite Index

## CISO: 3 takeaways för beslut

1. **E7 vs E5 — skillnaden är AI-governance.** E5 har grunderna (DLP, endpoint protection). E7 lägger till DSPM, Agent ID governance och AI-specifik insider risk. Om din organisation har Copilot + Claude + Codex är E7 inte en uppgradering — det är miniminivån.
2. **DSPM avslöjar vad DLP missar.** DLP blockerar i realtid, men DSPM hittar data som redan är exponerad — inklusive Shadow AI, felklassificerade dokument, och over-privileged agents. Utan DSPM opererar du blind.
3. **Agent 365 kräver agent-identiteter.** Att köra AI-agenter utan Entra Agent ID governance är som att ge alla anställda admin-credentials. Varje agent måste ha en workload-identitet, Conditional Access-policy och livscykelhantering.

## Architecture Notes (from NotebookLM Briefing, June 2026)

### Project Solara: Agent-First Hardware Ecosystem

Microsoft Build 2026 introduced **Project Solara**: hardware purpose-built for agent-first computing, on the AOSP-based Microsoft device platform. Two form factors:

- **Stationary Devices:** Desk-based units (MediaTek silicon) with Windows Hello for Business for ambient, secured access to Microsoft 365 Copilot grounded in Work IQ.
- **Portable Wearables:** Digital access badges (Qualcomm silicon) with fingerprint unlocking, voice-based documentation (diarization), and computer vision for workflow verification (e.g., patient vital scanning).

Steven Bathiche (Microsoft Build 2026): *"The next computer is not one device. It is all these devices working together as one system, with agents showing up closer to where and when you need them."*

### Connector Models for Agent Data Grounding

| Feature | Synced Connector | Federated Connector (MCP-based) |
|---------|-----------------|-------------------------------|
| **Data Movement** | Content ingested into Microsoft Graph. | No data movement; query-time fetch. |
| **Indexing** | Full semantic indexing supported. | No semantic indexing; real-time API calls. |
| **Protocol** | Microsoft Graph API. | Model Context Protocol (MCP). |
| **Use Case** | Knowledge repositories and LOB systems. | Regulated or highly dynamic content. |

The **Work IQ MCP** serves as the integration layer between agents and tools. Microsoft Defender evaluates agent-initiated tool invocations through Work IQ in real-time, blocking risky actions (e.g., attempts to exfiltrate system instructions) before execution.

### Real-Time Protection (RTP) for AI Agents

In the Microsoft Defender portal (System > Settings > Security for AI agents), ensure Agent 365 and Copilot Studio are connected for runtime tool evaluation — enabling block-on-risk for agent tool invocations rather than post-hoc detection.

^[raw/Reports/notebooklm/m365-e7-techarch-briefing-2026-06-06.md]

## Curated video-resurser

### Övergripande E7 — CISO-nivå
| Video | Kanal | Datum | Varför se den? |
|-------|-------|-------|----------------|
| [Securing The AI & Agentic Enterprise — How M365 E7 Reshapes Security](https://youtu.be/z_y2cCJc4M4) | CyberOne | Maj 2026 | Färsk CISO-genomgång av hela E7-svitens säkerhetsarkitektur |
| [Microsoft Security CISO Workshop: M365 E7 – Why AI is a Security Decision](https://youtu.be/ABwZjV1VxVU) | Softwerx | Maj 2026 | CISO-workshop — strategisk, inte teknisk |
| [Explore Agent 365 security and governance capabilities \| BRK269](https://youtu.be/RsCz57M2SMc) | Microsoft Events | Nov 2025 | Djupdykning i Agent 365 governance från Microsoft Ignite |
| [E7 vs E5: Which Microsoft License Do You Actually Need?](https://youtu.be/XN-gM86tOh0) | CRTL+LOL | Mar 2026 | Rak jämförelse — lämplig för budgetdiskussioner |

### Data Security & Purview
| Video | Kanal | Datum | Varför se den? |
|-------|-------|-------|----------------|
| [Agent 365 \| Controls for Data Security & Compliance in Microsoft Purview](https://youtu.be/CrAJZy7ne3Q) | Microsoft Mechanics ✓ | Maj 2026 | **Senaste** om hur Purview styr Agent 365 — nyaste videon |
| [Data security and governance in the age of AI \| BRK251](https://youtu.be/7FpeYx0f1ck) | Microsoft Events | Nov 2025 | 46-min djupdykning i Microsofts AI-data governance-strategi |
| [New Data Security Posture Management \| Microsoft Purview](https://youtu.be/NLfoFpFxhrA) | Microsoft Mechanics ✓ | Nov 2025 | Introduktion till Purview DSPM — 8.3K views |
| [Secure Your AI Apps and Agents via Microsoft Purview](https://youtu.be/QiJBK3dqeCs) | Microsoft SLED | Jan 2026 | Praktisk — 49 min med demo |
| [Sensitivity Labels for Copilot, ChatGPT & Gemini](https://youtu.be/xtmWt1T2wDM) | Joshua Addae | Feb 2026 | Hands-on: skydda data via labels i multi-modell-miljö |
| [Enforce sensitivity labels and encryption \| SC-401](https://youtu.be/6fn4X0-GxkI) | Microsoft Learn | Feb 2026 | 4.1K views — officiell Microsoft-utbildning |

### DSPM for AI
| Video | Kanal | Datum | Varför se den? |
|-------|-------|-------|----------------|
| [Automate Data Security Triage & Posture \| Agents in Microsoft Purview](https://youtu.be/BqMFzvk7T38) | Microsoft Mechanics ✓ | Mar 2026 | **Senaste** om automatisering av DSPM med Purview-agenter |
| [Secure and Protect AI Usage with DSPM for AI](https://youtu.be/WFkU9psbRb0) | Microsoft Developer ✓ | Feb 2026 | Microsoft Developer-kanalen — 680K subs |
| [Managing Shadow AI with Microsoft Purview DSPM](https://youtu.be/-kHhaE_Nn3Y) | Netwoven | Okt 2025 | 6.7K views — Shadow AI-specifik, praktisk |
| [Beyond Visibility: Purview Data Security Posture Mgmt \| BRK253](https://youtu.be/MqNgGkXJ5bc) | Microsoft Events | Nov 2025 | 43-min technology session från Ignite |
| [Understanding Microsoft Purview DSPM](https://youtu.be/IxEvotm5l3o) | Engage Squared | Feb 2026 | 7.02x engagement — djup teknisk genomgång |

### Enterprise AI Governance (Copilot + Claude + Codex)
| Video | Kanal | Datum | Varför se den? |
|-------|-------|-------|----------------|
| [AI Assistants Compared: Claude, ChatGPT Enterprise & Copilot](https://youtu.be/GHY2hGrr-9k) | ECI | Apr 2026 | Direkt jämförelse av alla tre — säkerhet + funktioner |
| [Enterprise AI Compliance: Stop Shadow IT](https://youtu.be/a9F48jK6Vhs) | Millennium Business Solutions | Okt 2025 | Copilot vs ChatGPT vs Claude vs Perplexity |
| [Is ChatGPT Safe for Work? Enterprise AI Compliance Explained](https://youtu.be/ZvrBNO4VDUk) | CBT Nuggets ✓ | Feb 2026 | 368K subs — compliance-fokuserad |
| [Is Your AI Stealing Business Secrets? ChatGPT, Claude & Copilot Privacy](https://youtu.be/b7Mz7ZNLoA8) | Profit Minds | Nov 2025 | 6.11x engagement — insider-risk fokus |
| [Your Data is training their models — disable this in 5 Minutes](https://youtu.be/926XK2glVo4) | WorkModern | Jan 2026 | Viktig: opt-out för model training på externa plattformar |

### Identity (Entra Agent ID & Zero Trust)
| Video | Kanal | Datum | Varför se den? |
|-------|-------|-------|----------------|
| [How Microsoft Agent 365 works](https://youtu.be/yWwYLbMvc3s) | Microsoft Mechanics ✓ | Dec 2025 | **68.9K views** — mest sedda videon om Agent 365 |
| [AI Agents: The Third Pillar of Identity in Microsoft Entra](https://youtu.be/NDa3Jcsi2go) | Reza Sahebi | Mar 2026 | Konceptuell — varför AI-agenter kräver en ny identitetskategori |
| [Non-Human Identities in Microsoft Entra](https://youtu.be/rLN7WoDLT4U) | Microsoft Cloud IT Pro Podcast | Mar 2026 | NHI ur ett Entra-perspektiv — governance + lifecycle |
| [How to Automate AI Agent Offboarding in Entra ID \| EID-EXP-019](https://youtu.be/FJxgFuj_CTk) | Identity Digest | Maj 2026 | Agent lifecycle — offboarding automation |

### Device & Endpoint
| Video | Kanal | Datum | Varför se den? |
|-------|-------|-------|----------------|
| [M365 E7, Intune and Purview Updates](https://youtu.be/F054yF45tRg) | Cloudy with a Chance of Insights | Mar 2026 | Innehåller Intune-updates för AI-enheter |
| [Microsoft Defender For Endpoint For Mac OS](https://youtu.be/tqhM4q1Iph8) | JOYATRES TECHNOLOGY | Maj 2026 | Mac-stöd för endpoint DLP — viktigt för utvecklargrupper |
| [Data Loss Prevention in Microsoft 365 – Easy Guide](https://youtu.be/VWYeiJ48tQg) | Jonathan Edwards | Jun 2025 | 458K subs — 65.8K views, grundlig DLP-genomgång |
| [Insights from Microsoft Ignite: Your Kick-Start for 2026](https://youtu.be/ZH0umh1T83U) | water IT Security | Jan 2026 | Strategisk — vad Ignite 2025 betyder för 2026 års säkerhet |

## NotebookLM

Allt material är tillgängligt i NotebookLM för chat, podcast och analys:

- **Notebook:** "Hermes — M365 E7"
- **ID:** `9ead269d-d2f6-4dce-9996-64e5baf87d10`
- **Sources:** 5 compilations (agents, copilot, identity, solutions-architecture, overview) + 4 YouTube-videos
- **Öppen i webbläsaren:** https://notebooklm.google.com/notebook/9ead269d-d2f6-4dce-9996-64e5baf87d10

## Relaterade notes
- Agent 365 Index
- Microsoft 365 Copilot Index
- Entra Suite Index

## Security Roadmap

You are an experienced Chief Information Security Architect. Create a Microsoft 365 Security Roadmap using a **capability-based approach**, based on **Microsoft Cybersecurity Reference Architecture (MCRA)** and the **Microsoft Zero Trust Framework**, while aligning capabilities with **NIS2** and mapping to **NIST CSF** and **CMMC 2.0**. Follow the guidelines below and deliver in the exact structure specified.

[CONTEXT — FILL IN/ADAPT]
- Industry/organization type: [e.g., energy, municipality, manufacturing, public sector]
- Regulatory requirements: [e.g., NIS2 essential/important, ISO 27001, GDPR]
- Target maturity: [e.g., NIST CSF “Target Profile” at Tier 3 within 12 months]
- Environment/scope: [e.g., M365 E5, hybrid identities, BYOD, macOS/Windows]
- Risk drivers/priorities: [e.g., data leakage, ransomware, insider risk]
- Timeline: [e.g., 0–6 months, 6–12 months, 12–24 months]
- Resource situation: [e.g., 1 SecOps analyst, partial IT Ops, external SOC]
- Integrations: [e.g., Sentinel, Defender XDR, ServiceNow, SIEM/SOAR, CMDB]
- Governance: [e.g., existing ISMS, CAB, quarterly risk forum]

[FRAMEWORK & MAPPING — REQUIREMENTS]
1) Use **Microsoft Cybersecurity Reference Architecture (MCRA)** and **Microsoft Zero Trust Framework** as the structural foundation.
2) Organize roadmap by **Zero Trust pillars**: Identity, Devices, Data, Applications, Infrastructure, Networks, Threat Protection, Governance.
3) Map each capability to:
   - **NIST CSF**: category and subcategories (ID, PR, DE, RS, RC).
   - **CMMC 2.0**: practices and level (L1/L2) where relevant.
   - **NIS2**: corresponding requirement areas (governance, risk, incident, BCM, suppliers, etc.).
4) Clearly show **overlap** between frameworks to optimize implementation.

[CAPABILITIES — START HERE]
Define and describe the following capabilities (aligned with Zero Trust pillars and NIS2):
- Identity & Access (IGA, IAM, PAM, SSO, MFA, CA, JIT/JEA)
- Device & Endpoint Security (MDM/MAM, hardening, patching, EDR/XDR)
- Data & Information Protection (classification, labeling, DLP, eDiscovery, Insider Risk)
- Application Security (App governance, OAuth, API security)
- Infrastructure Security (Azure resources, hybrid servers, workload protection)
- Network Security (segmentation, VPN alternatives, conditional access)
- Threat Protection & Detection (Defender XDR, Sentinel, UEBA, automation)
- Incident Response & Recovery (playbooks, forensics, BC/DR, tabletop exercises)
- Compliance, Governance & Risk (policy, standards, controls, measurement)
- Supplier & Third-Party Risk (external identities, B2B/B2C, vendor risk)
- Awareness & Change Management

[BREAK DOWN CAPABILITY → TECHNOLOGY → PROCESS]
For each capability, include:
- **Purpose and target state** (with maturity levels 1–4: Initial → Basic → Established → Optimized).
- **M365 technology**: e.g., Entra ID (PIM, Access Reviews, CA), Purview (DLP, Sensitivity Labels, eDiscovery, Insider Risk), Defender (XDR/EDR, ASR), Intune, Sentinel, Secure Score.
- **Processes & routines**: e.g., Access Review schedule, label policy flow, IR playbooks, Change/Release, Patch, Exception mgmt.
- **Policies & standards**: e.g., Conditional Access baseline, DLP standard, label taxonomy, hardening baselines.
- **Roles & ownership**: RACI (Responsible, Accountable, Consulted, Informed).
- **KPI/KRI & audit**: e.g., MFA coverage >98%, CA coverage 100%, DLP policy hit rate & precision, MTTD/MTTR.
- **Risks & dependencies**: e.g., licenses, directory hygiene, network, SIEM integration, training.
- **Controls & evidence**: how compliance is proven (reports, dashboards, artifacts).
- **Mapping to NIST/CMMC/NIS2** (explicit table row).

[ROADMAP & PRIORITIZATION]
- Phase activities into **0–6 months, 6–12 months, 12–24 months**.
- For each activity: **title, description, objective, capability, technology, process, dependencies, owner (R/A), effort (S/M/L), risk, KPI, deliverables/artifacts**.
- Highlight **quick wins** vs **strategic initiatives**.
- Show **sequencing** (e.g., Identity → Device → Data → Detection → Response).
- Include **milestones** and **exit criteria** per phase.
- Add **budget/license impact** and **resource assumptions**.

[OUTPUT FORMAT — DELIVER EXACTLY IN THIS STRUCTURE]
1) **Executive Summary (1 page)**: target state, frameworks, key risks, top priorities.
2) **Capability Overview** (table): Capability | Purpose | Current/Target Maturity | Zero Trust Pillar | NIST | CMMC | NIS2 | Owner (A) | KPI.
3) **Capability Deep Dive** (per capability): 
   - Technology (M365 modules/features)
   - Processes & Policies
   - RACI
   - Controls & Evidence
   - Risks & Dependencies
4) **Roadmap Table**: Phase | Initiative | Capability | Technology | Process | Owner (R/A) | Dependencies | KPI | Deliverables | Risk | Effort.
5) **Visualization**: Gantt-like timeline + prioritization matrix (Impact vs Effort).
6) **Maturity Assessment**: Current/Target per capability + gap and recommended next step.
7) **Governance**: operating model, decision forums, policy lifecycle, control calendar, audit cadence, exception handling.
8) **Appendix**: framework mapping (Zero Trust pillars, NIST subcodes, CMMC practice IDs, NIS2 requirements), glossary, reference architecture (high level).

[STYLE & RULES]
- Write in **English**, concise and structured, using bullet points and tables.
- Be **opinionated**: provide clear recommendations and priorities.
- Avoid fluff. Specify exact M365 features and example policy names.
- Clearly mark where **manual decisions** are required (e.g., label taxonomy, exceptions).
- Assume **M365 E5** unless otherwise stated.
- Include **Secure Score** targets and Sentinel use cases.

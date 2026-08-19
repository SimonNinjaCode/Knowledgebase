---
audit_date: 2026-08-18
scope: Intune
status: active
sources:
  - https://learn.microsoft.com/intune/whats-new/
  - https://learn.microsoft.com/intune/fundamentals/planning-guide
  - https://learn.microsoft.com/intune/fundamentals/platform-guide-windows
---

# Intune knowledge-base audit — August 2026

## Executive finding

The folder is a useful script library but not yet a complete Intune operational
knowledge base. It contains 153 supported files and about 53,642 words: 144 code
files and only 9 documents. Graph analysis found 556 concepts, 449 relationships,
196 small communities, and 153 weakly connected concepts. The two largest
communities have cohesion scores of only 0.06 and 0.09.

The strongest coverage is tactical Windows work: remediations, BitLocker,
Secure Boot, application packaging, assignments, filters, and classic Windows
Autopilot. The weakest coverage is architecture, governance, multi-platform
management, current enrollment, modern update management, advanced Intune
capabilities, testing, and script lifecycle ownership.

## Changes applied during this audit

1. Replaced hard-coded Intune Suite prices with the Microsoft 365 licensing
   model that applies from July 2026 and links to current product terms.
2. Updated Endpoint Privilege Management operating-system prerequisites, virtual
   platform support, Arm64 support, Windows 10 lifecycle warning, RBAC roles, and
   current elevation behaviors.
3. Refreshed the Intune landing page with current Learn routes, Windows Autopilot
   device preparation, enrollment-time grouping, and Linux coverage.
4. Generated a persistent graph, interactive visualization, and graph audit in
   `graphify-out/`.

## Priority adjustments

### P0 — Modernize authentication and API usage

At least eight files use legacy `Connect-MSGraph` or `Invoke-MSGraphRequest`
patterns, four use the retired AzureAD/AzureADPreview module, and nine depend on
Microsoft Graph `/beta` endpoints. These scripts should be treated as examples,
not production-ready automation.

Actions:

- Migrate authentication and directory operations to Microsoft Graph PowerShell
  or Microsoft Entra PowerShell.
- Prefer `v1.0`; document the reason, schema assumptions, and validation date for
  every required `/beta` dependency.
- Add required delegated/application permissions, least-privilege rationale,
  pagination, throttling/retry behavior, and error handling to each Graph script.
- Replace frozen copies of community scripts, especially Autopilot tooling, with
  a versioned upstream reference or an explicitly maintained local fork.
- Remove tenant-specific identifiers from reusable examples and load them from
  parameters or environment-specific configuration.

### P0 — Add ownership and safety metadata to scripts

Every operational script should state owner, purpose, supported platforms,
minimum OS/build, required permissions, execution context, inputs, outputs,
exit-code contract, rollback, validation date, and authoritative source. Add a
simple test harness for detection/remediation pairs and validate both compliant
and noncompliant states before deployment.

### P1 — Replace the classic-only Autopilot story

Current content focuses on device registration, classic deployment profiles,
ESP checks, and legacy PowerShell modules. Add a decision guide comparing:

- Windows Autopilot device preparation versus classic Windows Autopilot.
- Microsoft Entra join versus hybrid join.
- User-driven, automatic, pre-provisioned, self-deploying, and existing-device
  scenarios.
- Enrollment-time grouping, supported application/script limits, reporting,
  rollback, and coexistence rules.

### P1 — Add a Windows servicing operating model

The folder includes old Update Compliance prerequisites but lacks a coherent
current servicing design. Add guidance for Windows Autopatch, update rings,
feature updates, quality updates, expedited updates, drivers and firmware,
hotpatch eligibility, reporting, pause/resume/rollback, and Windows 10 ESU or
migration handling.

### P1 — Modernize application management

Existing material is strong on bespoke Win32 packaging, PSADT, Chocolatey, and
raw WinGet commands. Add a supported-source decision tree covering Microsoft
Store apps, Win32 apps, Enterprise App Catalog, Microsoft 365 Apps, supersedence,
dependencies, detection rules, update ownership, self-service through Company
Portal, and when custom packaging is still justified.

### P1 — Add certificate architecture, not only NDES links

`NDES Security.md` is mainly a link collection. Add a decision record comparing
Microsoft Cloud PKI, Cloud PKI with BYOCA, AD CS + NDES, PKCS, SCEP, and imported
PKCS. Include trust-chain design, renewal/revocation, RBAC, monitoring, disaster
recovery, strong certificate mapping, and migration triggers. Cloud PKI can
remove the on-premises CA, NDES, and Intune certificate connector for supported
scenarios.

### P2 — Build the missing operational layer

Add runbooks for policy rollout rings, assignment strategy, filters versus
groups, scope tags, RBAC, change approval, conflict resolution, break-glass and
rollback, monitoring, service-health review, Intune release review, audit-log
retention, and incident troubleshooting.

## Missing coverage

- Cloud-native Windows endpoint architecture and workload migration.
- GPO analytics and policy rationalization rather than one-for-one migration.
- Compliance + Conditional Access design, grace periods, and failure handling.
- Mobile application management without enrollment and BYOD decision guidance.
- Complete Apple, Android Enterprise, Linux, specialty-device, and shared-device
  lifecycle coverage.
- Windows Autopilot device preparation and enrollment-time grouping.
- Windows Autopatch, hotpatch, driver/firmware policy, and servicing reports.
- Enterprise Application Management and application update ownership.
- Advanced Analytics, multi-device query, Intune data platform schema, privacy,
  and support workflows.
- Remote Help, Cloud PKI, Microsoft Tunnel for MAM, firmware over-the-air, and
  specialty-device management.
- Copilot in Intune governance and validation of generated queries or changes.
- Tenant architecture: RBAC, scope tags, administrative units, naming,
  assignment conventions, and least privilege.
- Policy-as-code lifecycle: export, review, test, deploy, drift detection, and
  rollback.
- A supported-platform matrix and explicit Windows 10 end-of-support strategy.
- Service-release watch process using Intune What's New, In Development, message
  center, and periodic validation dates on local articles.

## Recommended information architecture

1. `00-Governance` — architecture, roles, naming, scope tags, change control.
2. `10-Enrollment` — platform and ownership decision guides, Autopilot, ADE,
   Android Enterprise, BYOD.
3. `20-Configuration` — settings catalog, baselines, certificates, conflicts.
4. `30-Applications` — app source, packaging, deployment, update ownership.
5. `40-Security-and-Compliance` — compliance, Conditional Access, MDE, EPM.
6. `50-Updates` — Autopatch, rings, features, quality, drivers, hotpatch.
7. `60-Operations` — monitoring, analytics, remote help, diagnostics, incidents.
8. `70-Automation` — supported Graph automation with tests and permissions.
9. `90-Archive` — retired modules, classic Teams, obsolete OS guidance, and
   historical examples clearly marked as nonproduction.

## Authoritative references

- [What's new in Microsoft Intune](https://learn.microsoft.com/intune/whats-new/)
- [Intune planning guide](https://learn.microsoft.com/intune/fundamentals/planning-guide)
- [Windows deployment guide](https://learn.microsoft.com/intune/fundamentals/platform-guide-windows)
- [Autopilot device preparation comparison](https://learn.microsoft.com/autopilot/device-preparation/compare)
- [Enrollment-time grouping](https://learn.microsoft.com/intune/device-enrollment/setup-time-grouping)
- [Windows updates in Intune](https://learn.microsoft.com/intune/device-updates/windows/)
- [Intune app management](https://learn.microsoft.com/intune/app-management/overview)
- [Microsoft Cloud PKI](https://learn.microsoft.com/intune/cloud-pki/)
- [Endpoint Privilege Management planning](https://learn.microsoft.com/intune/epm/deployment-planning)
- [Supported operating systems](https://learn.microsoft.com/intune/fundamentals/ref-supported-platforms)
- [Migrate AzureAD PowerShell to Microsoft Graph PowerShell](https://learn.microsoft.com/powershell/microsoftgraph/migration-steps)

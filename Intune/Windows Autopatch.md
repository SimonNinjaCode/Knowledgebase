---
layout:
  width: wide
last_verified: 2026-09-15
status: current
source: https://learn.microsoft.com/en-us/windows/deployment/windows-autopatch/overview/windows-autopatch-overview
---

# Windows Autopatch

Windows Autopatch is Microsoft's cloud service for controlling and automating
updates to managed Windows devices. It uses Microsoft Intune for policy and
reporting, and Windows Update as the content source. Depending on the selected
workload, it can manage Windows quality and feature updates, drivers and
firmware, Microsoft 365 Apps for enterprise, Microsoft Edge and Microsoft Teams.

Autopatch is not Windows Autopilot. Autopilot provisions and enrolls devices.
Autopatch keeps enrolled devices updated after deployment.

> **In short:** Autopatch supplies orchestration, deployment rings, approval
> controls, reporting and safeguards. The organization still owns device
> targeting, application testing, exception handling, change decisions and
> remediation of devices that cannot update.

The facts in this article are confirmed against Microsoft Learn unless a section
is explicitly marked **Recommendation**.

## What Autopatch changes

A traditional Windows Update for Business design normally requires the
administrator to build and maintain separate update rings, feature update
policies, quality update policies and driver policies. Autopatch uses the same
underlying Intune and Windows Update controls but adds a coordinated management
layer.

An **Autopatch group** combines:

- One or more Microsoft Entra device groups.
- Deployment rings for staged rollout.
- Update policies for the selected workloads.
- Approval methods, deferrals, deadlines and release schedules.
- Scope tags for delegated administration.

Autopatch creates the required Entra groups and Intune policies from the group
configuration. A device is registered with the service when it is assigned to an
Autopatch policy or group; there is no separate end-user enrollment flow.
Initial group registration can take up to 48 hours.

See [Manage Windows Autopatch groups](https://learn.microsoft.com/windows/deployment/windows-autopatch/manage/windows-autopatch-manage-autopatch-groups)
and [Autopatch group registration](https://learn.microsoft.com/windows/deployment/windows-autopatch/deploy/windows-autopatch-device-registration-overview).

## Functions and workloads

| Area | What Autopatch provides | Important boundary |
|---|---|---|
| Update rings | Staged deployment with deferrals, deadlines, grace periods, restart behavior and notifications. | Ring membership must reflect real hardware, application and business risk. |
| Quality updates | Automatic or manual approval for monthly Windows and supported .NET Framework updates. Security updates can be expedited. | Pausing a release prevents new installations; it does not remove an update already installed. |
| Feature updates | Version targeting, multi-phase releases, Windows 10-to-11 deployment and pause/resume controls. | The Autopatch feature-release flow has no native rollback action. LTSC devices only receive quality-update management through Autopatch. |
| Drivers and firmware | Automatic deployment or manual approval, configurable per group or ring. Deferral can be set from 0 to 30 days. | Extension drivers and initial Plug and Play drivers are not always governed by the approval flow. Firmware still requires OEM validation. |
| Hotpatch | Eligible monthly security updates can be applied without a restart. | Devices still require quarterly baseline updates with a restart. Hotpatch is not "no more reboots." |
| Microsoft 365 Apps | Management of Microsoft 365 Apps for enterprise on the Monthly Enterprise Channel. | Autopatch cannot pause or roll back these updates. Microsoft 365 Apps Cloud Update takes precedence. |
| Microsoft Edge | Uses Edge's progressive rollout on the Stable Channel. | Autopatch cannot pause or resume Edge updates. Other Edge channels are outside this managed flow. |
| Microsoft Teams | Uses the standard automatic update channel for eligible devices. | This is not a separate ring-controlled deployment. Autopatch cannot pause or resume Teams updates. |
| Reporting and alerts | Tenant-wide management status, readiness checks, per-device status, deployment trends, alerts and hotpatch readiness. | Reports depend on Intune and Windows diagnostic data and are not real time. |
| RBAC and scope | Built-in Autopatch roles, Intune policy permissions, scope tags and scoped groups. | The Autopatch Administrator role alone cannot manage all underlying update policies. |
| Automation | Windows updates can be approved, scheduled and managed through Microsoft Graph. | The Windows updates API is under the Microsoft Graph `beta` endpoint; production automation must account for change risk. |

Sources: [Autopatch overview](https://learn.microsoft.com/windows/deployment/windows-autopatch/overview/windows-autopatch-overview),
[quality updates](https://learn.microsoft.com/windows/deployment/windows-autopatch/manage/windows-autopatch-windows-quality-update-overview),
[feature updates](https://learn.microsoft.com/windows/deployment/windows-autopatch/manage/windows-autopatch-windows-feature-update-overview),
[drivers and firmware](https://learn.microsoft.com/windows/deployment/windows-autopatch/manage/windows-autopatch-manage-driver-and-firmware-updates),
[RBAC](https://learn.microsoft.com/windows/deployment/windows-autopatch/prepare/windows-autopatch-role-based-access-control),
and [Windows updates API overview](https://learn.microsoft.com/graph/windowsupdates-concept-overview).

## Autopatch groups and deployment rings

Autopatch groups are the simplest way to establish a coordinated rollout. Each
group represents an update population, for example standard office devices,
shared devices, kiosks or restart-sensitive systems. Within the group, deployment
rings control when devices receive an update.

Microsoft provides release schedule presets for:

- Information workers.
- Shared devices.
- Kiosks and billboards.
- Reboot-sensitive devices.

The preset controls installation, restart and notification behavior. Deferrals
and deadlines can then be adjusted per ring. The available update types are
quality updates, feature updates, drivers, Microsoft 365 Apps and Microsoft Edge.

An Entra device group can only be used in one deployment ring within an
Autopatch group at a time. Overlapping group membership can leave devices in a
**Not ready** or **Not registered** state and require manual resolution.

### Groups or individual policies?

Use an Autopatch group when the same device population should share a coordinated
ring structure across several workloads. Use individual policies when a workload
requires separate targeting or approval logic. Both approaches use the same
Autopatch deployment service, but individual policies leave policy creation,
assignment and conflict management to the administrator.

For feature upgrades, use a custom multi-phase feature update release. Do not
change the minimum target version of an Autopatch group merely to start a
rollout; Microsoft warns that this can start deployment immediately for all
members of the group.

See [Autopatch group policies](https://learn.microsoft.com/windows/deployment/windows-autopatch/manage/windows-autopatch-groups-policies).

## Quality updates

Quality update policies cover monthly Windows updates and supported .NET
Framework updates, including security, non-security and out-of-band releases.
One policy can combine approval methods:

- **Automatic approval** is Microsoft's recommendation for security updates.
- **Manual approval** is appropriate for optional or non-security updates where
  explicit change control is required.
- **Expedite** bypasses the normal cadence for a specific security update.
- **Pause** revokes approval so that new devices do not receive the selected
  release. Devices that already installed it are not rolled back.

A pause, resume or rollback instruction can take up to eight hours to reach
devices through Intune. Pausing one release does not pause other approved
Windows or .NET releases.

## Feature updates

Feature update policies pin devices to a selected Windows version. Multi-phase
releases add controlled scheduling across Autopatch groups and deployment rings.
They support:

- Targeting a supported Windows version.
- Moving eligible Windows 10 devices to Windows 11.
- Separate phases and start dates.
- Pause and resume per release.
- Safeguard holds for known compatibility risks.

The Autopatch feature-release experience does not provide a native rollback
action. Windows can retain an uninstall window through the underlying update-ring
policy, but that client mechanism must not be confused with rollback in the
Autopatch release workflow. Treat recovery planning as a separate design item.

Feature updates are not available through Autopatch for LTSC devices. Those
devices require LTSC media or an appropriate operating-system deployment method
for version changes.

## Driver and firmware updates

Driver management can be configured as:

- **Automatic:** Autopatch deploys recommended drivers progressively through the
  rings. This is Microsoft's default recommendation for standardized OEM
  hardware without a history of update-related hardware incidents.
- **Manual:** Administrators review and approve individual drivers. Nothing in
  the managed driver catalog is deployed without approval.

Approval mode and deferral can differ between rings. Switching between automatic
and manual mode creates replacement policies and discards earlier approvals,
pauses and declines. Treat that change as a controlled migration, not a harmless
toggle.

Autopatch shows drivers applicable to the targeted devices. The **Other drivers**
view can contain firmware, optional drivers and previously recommended versions.
This is useful, but it is not proof that an update is safe for a business-critical
device model.

See [Manage driver and firmware updates](https://learn.microsoft.com/windows/deployment/windows-autopatch/manage/windows-autopatch-manage-driver-and-firmware-updates).

## Microsoft 365 Apps, Edge and Teams

These workloads are part of Autopatch, but they do not behave like Windows
quality and feature updates.

### Microsoft 365 Apps for enterprise

Autopatch targets the Monthly Enterprise Channel and creates policy assignments
for the relevant groups and rings. The Office content delivery network still
determines when an update is offered, so the rings do not directly stage the
offer in the same way as Windows quality updates. Applications must close before
the update can complete.

Autopatch cannot pause or roll back Microsoft 365 Apps updates. Devices governed
by Cloud Update in the Microsoft 365 Apps admin center are not eligible for the
Autopatch Microsoft 365 Apps workload because Cloud Update takes precedence.

See [Microsoft 365 Apps for enterprise](https://learn.microsoft.com/en-us/windows/deployment/windows-autopatch/manage/windows-autopatch-microsoft-365-apps-enterprise).

### Microsoft Edge

Autopatch places eligible production devices on the Stable Channel and relies on
Edge's progressive product rollout. Test devices can use the Beta Channel. Edge
must restart before an installed update takes effect. Autopatch does not expose
pause or resume controls for this workload.

See [Microsoft Edge](https://learn.microsoft.com/en-us/windows/deployment/windows-autopatch/manage/windows-autopatch-edge).

### Microsoft Teams

Teams uses its standard automatic update channel. The Autopatch workload does
not provide a separate deployment-ring schedule or pause/resume controls. The
user must be signed in and Teams must be online; completing an update also
depends on device idle time.

See [Microsoft Teams](https://learn.microsoft.com/en-us/windows/deployment/windows-autopatch/manage/windows-autopatch-teams).

## Hotpatch

Hotpatch applies eligible Monthly B security updates without restarting the
device. It is an extension of Windows Update and must be enabled through a
Windows quality update policy.

Client prerequisites include:

- An eligible license.
- Windows 11, version 24H2 or later.
- The latest quarterly baseline update.
- Virtualization-based security (VBS) enabled.
- Intune management and an Autopatch quality update policy with hotpatch allowed.

Microsoft publishes standard cumulative baseline updates quarterly. Those
baseline updates require a restart. Eligible intervening monthly releases can be
hotpatched. If a critical hotpatch error occurs, Windows can install the standard
cumulative update to keep the device protected.

The planned cadence uses restart-requiring baseline releases in January, April,
July and October, with hotpatch releases in the intervening eight months.
Microsoft can publish an additional baseline when security requirements demand
it.

See [Hotpatch updates](https://learn.microsoft.com/en-us/windows/deployment/windows-autopatch/manage/windows-autopatch-hotpatch-updates).

## Reporting and readiness

Autopatch reporting combines Intune inventory and Windows diagnostic data. The
current reporting surface includes:

- **Autopatch management status:** tenant-wide view of all Intune-managed Windows
  devices, including their management method, assigned update types, active
  alerts and hotpatch readiness.
- **Update readiness checker:** checks connectivity, disk space, safeguard holds,
  appraiser markers and hotpatch prerequisites before deployment.
- **Device update journey:** detailed feature-update progression from offer to
  installation or failure.
- **Quality and feature update reports:** per-device status, trends and alerts.
- **Hotpatch quality update report:** policy-level status for devices targeted
  with hotpatch.

The management status report includes devices managed by cloud policies,
traditional update rings and devices with no update policy. It exposes devices
outside the design. Without that denominator, an impressive compliance
percentage says rather less than it appears to.

See [Autopatch management status](https://learn.microsoft.com/windows/deployment/windows-autopatch/monitor/windows-autopatch-management-status-report),
[update readiness](https://learn.microsoft.com/windows/deployment/windows-autopatch/monitor/windows-autopatch-update-readiness-overview)
and [quality and feature update reports](https://learn.microsoft.com/windows/deployment/windows-autopatch/monitor/windows-autopatch-windows-quality-and-feature-update-reports-overview).

## Licensing

Windows Autopatch is included with these subscriptions:

- Microsoft 365 Business Premium.
- Windows 10/11 Enterprise E3 or E5, including Microsoft 365 F3, E3 and E5.
- Windows 10/11 Education A3 or A5, including Microsoft 365 A3 and A5.
- Windows 10/11 Enterprise VDA E3 or E5.

Feature entitlement differs by license. In particular, access to support requests
with the Windows Autopatch Service Engineering Team is limited to eligible E3+
and F3 licensing. Hotpatch has its own license and device prerequisites; verify
those separately rather than assuming every Autopatch-licensed device qualifies.

Licensing changes more often than architecture. Confirm entitlement in
[Windows Autopatch prerequisites](https://learn.microsoft.com/windows/deployment/windows-autopatch/prepare/windows-autopatch-prerequisites)
before customer design or procurement.

## Technical prerequisites

The standard prerequisites are:

- Microsoft Entra ID P1 or P2 and Microsoft Intune.
- Microsoft Entra joined or Microsoft Entra hybrid joined devices. Local
  Active Directory joined devices are not supported.
- Corporate-owned devices. BYOD devices fail the registration prerequisite
  checks.
- Devices enrolled in Intune, or co-managed with the Windows Update and Device
  configuration workloads set to Intune or Pilot Intune.
- Internet access to the required Microsoft service endpoints.
- A supported Windows 10 or Windows 11 edition on the General Availability
  Channel.
- Recent Intune communication; devices that have not contacted Intune in the
  previous 28 days are not registered.
- Required Windows diagnostic data for population-specific deployment
  protections and richer reporting.

Supported editions include Pro, Enterprise, Education, Pro Education, Pro for
Workstations and Windows IoT Enterprise, subject to license and servicing
requirements. Configuration Manager-only devices are not supported.

See [Prerequisites](https://learn.microsoft.com/windows/deployment/windows-autopatch/prepare/windows-autopatch-prerequisites)
and [Configure your network](https://learn.microsoft.com/windows/deployment/windows-autopatch/prepare/windows-autopatch-configure-network).

## Roles and permissions

Autopatch separates access to its management layer from access to the underlying
Intune policies:

| Task | Required access |
|---|---|
| View Autopatch data | Windows Autopatch Reader or equivalent custom permissions. |
| Manage Autopatch groups, reports, support and messages | Windows Autopatch Administrator or equivalent custom permissions. |
| Manage update rings, quality, feature and driver policies | Intune Device Configuration permissions, for example Policy and Profile Manager. |
| Fully operate Autopatch with delegated rights | Both Autopatch and Intune policy permissions, with aligned scope tags and role scopes. |

Assigning only **Windows Autopatch Administrator** is therefore insufficient for
full update-policy management. Use scope tags and scoped groups to separate
administration where required.

See [Role-based access control](https://learn.microsoft.com/windows/deployment/windows-autopatch/prepare/windows-autopatch-role-based-access-control).

## Division of responsibility

| Microsoft/Autopatch | Customer IT |
|---|---|
| Provides update content and cloud orchestration. | Defines device populations, exclusions and business-critical rings. |
| Creates and coordinates selected policies through Autopatch groups. | Tests applications, security controls, peripherals and operational workflows. |
| Applies rollout logic, safeguards, reporting and alerts. | Monitors results and remediates devices that are offline, misconfigured or unhealthy. |
| Can pause content when service signals require it. | Decides when to pause, resume, expedite or invoke supported recovery actions for organization-specific incidents. |
| Provides eligible support paths and service communications. | Maintains RBAC, change records, communications and exception ownership. |

## Recommendation: minimum operating model

The following is an Exobe recommendation, not a Microsoft requirement.

1. Create separate Autopatch groups only where device type, restart behavior or
   business risk genuinely differs. Group sprawl recreates the policy mess that
   Autopatch was supposed to remove.
2. Place named IT and application-validation devices in the first ring. A random
   one-percent sample is statistically neat and operationally useless if nobody
   observes it.
3. Ensure later rings include representative hardware models, drivers, offices
   and critical applications, not just increasing percentages of identical
   laptops.
4. Use automatic approval for monthly security updates and explicit approval for
   optional content. Document exceptions.
5. Start feature upgrades as custom multi-phase releases. Keep feature version
   targeting separate from the monthly quality-update cadence.
6. Use automatic driver deployment only for standardized, well-supported device
   estates. Use manual approval for fragile hardware, regulated workloads and
   devices with a history of firmware incidents.
7. Review management status, update readiness, alerts and devices without policy
   coverage at least weekly. Review release outcomes after each Monthly B update.
8. Define in advance who can pause or expedite updates, who owns recovery, and
   how users and service owners are informed.

## Adoption checklist

- [ ] Confirm licensing and supported device editions.
- [ ] Inventory existing update rings, feature policies, driver policies, WSUS
      settings and Configuration Manager workloads.
- [ ] Remove or resolve conflicting update authority and overlapping assignments.
- [ ] Define Autopatch groups and named owners for each deployment ring.
- [ ] Select workloads and approval modes.
- [ ] Validate restart, deadline and notification behavior with users.
- [ ] Confirm diagnostic data, network endpoints and Intune check-in health.
- [ ] Assign RBAC and scope tags using least privilege.
- [ ] Pilot quality updates, feature updates and drivers as separate test cases.
- [ ] Establish alert handling, recovery decisions and monthly service review.
- [ ] Use the management status report to find unmanaged or partially managed
      devices.

## Limitations and design cautions

- Autopatch does not test business applications or peripherals for the customer.
- A pause is not instantaneous and does not uninstall an update already applied.
- Hotpatch reduces restarts; it does not eliminate them.
- Policy overlap, Entra group overlap and mixed WSUS/cloud authority can disrupt
  the intended release schedule.
- LTSC devices have restricted workload support.
- BYOD and Configuration Manager-only devices are not supported for registration.
- Reports are delayed by device check-in and diagnostic-data processing.
- Microsoft Graph automation uses beta APIs and needs lifecycle controls.
- Feature names, portal paths and license entitlements change. Revalidate this
  article before using it as a customer design baseline.

## Microsoft documentation

All sources below were retrieved on **2026-09-15**.

| Source | Microsoft page date |
|---|---:|
| [Windows Autopatch documentation](https://learn.microsoft.com/windows/deployment/windows-autopatch/) | Current documentation index |
| [What is Windows Autopatch?](https://learn.microsoft.com/windows/deployment/windows-autopatch/overview/windows-autopatch-overview) | 2026-07-13 |
| [Frequently asked questions](https://learn.microsoft.com/windows/deployment/windows-autopatch/overview/windows-autopatch-faq) | 2026-05-28 |
| [Prerequisites](https://learn.microsoft.com/windows/deployment/windows-autopatch/prepare/windows-autopatch-prerequisites) | 2026-02-27 |
| [Start using Windows Autopatch](https://learn.microsoft.com/windows/deployment/windows-autopatch/prepare/windows-autopatch-start-using-autopatch) | 2025-11-18 |
| [Manage Windows Autopatch groups](https://learn.microsoft.com/windows/deployment/windows-autopatch/manage/windows-autopatch-manage-autopatch-groups) | 2025-08-05 |
| [Autopatch group policies](https://learn.microsoft.com/windows/deployment/windows-autopatch/manage/windows-autopatch-groups-policies) | 2026-07-02 |
| [Windows quality updates](https://learn.microsoft.com/en-us/windows/deployment/windows-autopatch/manage/windows-autopatch-windows-quality-update-overview) | 2026-09-01 |
| [Windows feature updates](https://learn.microsoft.com/en-us/windows/deployment/windows-autopatch/manage/windows-autopatch-windows-feature-update-overview) | 2025-05-27 |
| [Driver and firmware updates](https://learn.microsoft.com/windows/deployment/windows-autopatch/manage/windows-autopatch-manage-driver-and-firmware-updates) | 2025-03-31 |
| [Microsoft 365 Apps for enterprise](https://learn.microsoft.com/en-us/windows/deployment/windows-autopatch/manage/windows-autopatch-microsoft-365-apps-enterprise) | 2025-03-31 |
| [Microsoft Edge](https://learn.microsoft.com/en-us/windows/deployment/windows-autopatch/manage/windows-autopatch-edge) | 2025-03-31 |
| [Microsoft Teams](https://learn.microsoft.com/en-us/windows/deployment/windows-autopatch/manage/windows-autopatch-teams) | 2025-03-31 |
| [Hotpatch updates](https://learn.microsoft.com/windows/deployment/windows-autopatch/manage/windows-autopatch-hotpatch-updates) | 2026-06-02 |
| [Autopatch management status](https://learn.microsoft.com/windows/deployment/windows-autopatch/monitor/windows-autopatch-management-status-report) | 2026-08-20 |
| [Update readiness](https://learn.microsoft.com/windows/deployment/windows-autopatch/monitor/windows-autopatch-update-readiness-overview) | 2026-03-02 |
| [Quality and feature update reports](https://learn.microsoft.com/windows/deployment/windows-autopatch/monitor/windows-autopatch-windows-quality-and-feature-update-reports-overview) | 2025-05-27 |
| [Role-based access control](https://learn.microsoft.com/en-us/windows/deployment/windows-autopatch/prepare/windows-autopatch-role-based-access-control) | 2025-05-27 |
| [Windows updates API overview](https://learn.microsoft.com/graph/windowsupdates-concept-overview) | 2026-01-28 |

## Open questions before customer implementation

- Which applications, device models and business processes must be represented in
  the first deployment rings?
- Which devices need a different restart schedule or manual driver approval?
- Is update authority fully cloud-based, or must selected workloads remain in
  WSUS or Configuration Manager?
- Which diagnostic-data level is permitted by the organization's privacy and
  compliance decisions?
- Who owns update exceptions, and when does an exception expire?
- Does the available license include every required feature and support path?

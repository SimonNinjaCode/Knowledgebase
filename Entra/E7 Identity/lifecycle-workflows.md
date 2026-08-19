---
domain: m365-e7
id: "M365-ENTRA-LW-001"
title: "Plan a Lifecycle Workflow deployment - Microsoft Entra ID Governance"
sources: ["m365maps E7"]
ms-learn: "https://learn.microsoft.com/entra/id-governance/lifecycle-workflows-deployment"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#identity", "#governance"]
group: "governance"
---

# Plan a Lifecycle Workflow deployment - Microsoft Entra ID Governance

## Översikt

Lifecycle Workflows — en del av Microsoft 365 E7. Se [Microsoft Learn](https://learn.microsoft.com/entra/id-governance/lifecycle-workflows-deployment) för full dokumentation.

## Innehåll

[Lifecycle Workflows] help your organization to manage Microsoft Entra users by increasing automation. With Lifecycle Workflows, you can:

- **Extend** your HR-driven provisioning process with other workflows that simplify and automate tasks.
- **Centralize** your workflow process so you can easily create and manage workflows all in one location.
- **Troubleshoot** workflow scenarios with the Workflow history and Audit logs with minimal effort.
- **Manage** user lifecycle at scale. As your organization grows, the need for other resources to manage user lifecycles is lowered.
- **Reduce** or remove manual tasks that were done in the past with automated Lifecycle Workflows.
- **Apply** logic apps to extend workflows for more complex scenarios using your existing Logic apps.

Lifecycle Workflows are a [Microsoft Entra ID Governance] capability. The other capabilities are [entitlement management], [access reviews],[Privileged Identity Management (PIM)], and [terms of use]. Together, they help you address these questions:

- Which users should have access to which resources?
- What are those users doing with that access?
- Is there effective organizational control for managing access?
- Can auditors verify that the controls are working?
- Are users ready to go on day one or do they have access removed in a timely manner?

Planning your Lifecycle Workflow deployment is essential to make sure you achieve your desired governance strategy for users in your organization.

For more information on deployment plans, see [Microsoft Entra deployment plans].

## License requirements

Using this feature requires Microsoft Entra ID Governance or Microsoft Entra Suite licenses. To find the right license for your requirements, see [Microsoft Entra ID Governance licensing fundamentals].

### Plan the Lifecycle Workflow deployment project

Consider your organizational needs to determine the strategy for deploying Lifecycle Workflows in your environment.

### Engage the right stakeholders

When technology projects fail, they typically do so because of mismatched expectations on impact, outcomes, and responsibilities. To avoid these pitfalls, [ensure that you\'re engaging the right stakeholders][Microsoft Entra deployment plans] and that project roles are clear.

For Lifecycle Workflows, you\'ll likely include representatives from the following teams within your organization:

- **IT administration** manages your IT infrastructure and administers your cloud investments and software as a service (SaaS) apps. This team:

  - Reviews Lifecycle Workflows for infrastructure and apps, including Microsoft 365 and Microsoft Entra ID.
  - Schedules and runs Lifecycle Workflows on users.
  - Ensures that programmatic Lifecycle Workflows, via GRAPH or extensibility, are governed and reviewed.

- **Security Owner** ensures that the plan meets the security requirements of your organization. This team:

  - Ensures Lifecycle Workflows meet organizational security policies

- **Compliance manager** ensures that the organization follows internal policy and complies with regulations. This team:

  - Requests or schedules new Lifecycle Workflow reviews.
  - Assesses processes and procedures for reviewing Lifecycle Workflows, which include documentation and record keeping for compliance.
  - Reviews results of past reviews for most critical resources.

- **HR Representative** - Assists with attribute mapping and population in HR provisioning scenarios. This team:

  - Helps determine attributes that are used to populate employeeHireDate and employeeLeaveDateTime.
  - Ensures source attributes are populated and have values
  - Identifies and suggests alternate attributes that could be mapped to employeeHireDate and employeeLeaveDateTime

- **Development teams** build and maintain applications for your organization. This team:

*Se MS Learn för full dokumentation.*

## MS Learn-källa
[Lifecycle Workflows](https://learn.microsoft.com/entra/id-governance/lifecycle-workflows-deployment)

## Relaterade notes
- Entra Suite Index

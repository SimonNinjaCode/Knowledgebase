---
domain: m365-e7
id: "M365-ENTRA-VID-001"
title: "Microsoft Entra licensing"
sources: ["m365maps E7"]
ms-learn: "https://learn.microsoft.com/entra/fundamentals/licensing#microsoft-entra-verified-id"
created: 2026-05-30
updated: 2026-06-17
type: concept
tags: ["#m365-e7", "#identity", "#verified-id"]
group: "verified-id"
corrected: 2026-06-17 — Verified ID är inte E7-specifikt; grund ingår i alla Entra-prenumerationer
---

# Microsoft Entra licensing

## Översikt

**Viktig korrigering:** Entra Verified ID (grund) ingår i **alla** Entra ID-prenumerationer, inklusive Free. Face Check (premium) är ett tillägg eller ingår i Microsoft Entra Suite. Det finns **inget specifikt E7-licenskrav** dokumenterat på MSLearn för Verified ID. Se [Microsoft Learn](https://learn.microsoft.com/entra/fundamentals/licensing#microsoft-entra-verified-id) för full dokumentation.

## Licensstruktur

| Nivå | Vad ingår | Krav |
|------|-----------|------|
| **Verified ID (grund)** | Utfärda och verifiera credentials | Valfri Entra ID-prenumeration (inkl. Free) |
| **Face Check (premium)** | Biometrisk verifiering | Add-on eller Entra Suite (kräver Entra ID P1) |
| **Verified ID i Entra Suite** | Full premium-kapacitet | Entra ID P1 + Entra Suite-licens |

<!-- Original text från MSLearn bevaras nedan som referens -->

## Innehåll

## Overview

This article discusses licensing options for the Microsoft Entra product family. It\'s intended for security decision makers, identity and network access administrators, and IT professionals who are considering Microsoft Entra solutions for their organizations.

If you\'re troubleshooting licensing assignment issues, review [Identify and resolve license assignment problems for a group in the Microsoft 365 Admin Portal].

## Microsoft Entra licensing options

Microsoft Entra is available in several licensing options that allow you to choose the package best suited to your needs.

The licensing options on this page aren\'t comprehensive. You can get detailed information about the various options at the [Microsoft Entra pricing page] and at the [Compare Microsoft 365 Enterprise plans and pricing page].

**Microsoft Entra ID Free** - Included with Microsoft cloud subscriptions such as Microsoft Azure, Microsoft 365, and others.

**Microsoft Entra ID P1** - Microsoft Entra ID P1 is available as a standalone product or included with Microsoft 365 E3, F1, F3, and Enterprise Mobility + Security E3 for enterprise customers. Entra ID P1 is also included in Microsoft 365 Business Premium for small to medium businesses.

**Microsoft Entra ID P2** - Microsoft Entra ID P2 is available as a standalone product. It is also included with the following offers for enterprise customers:

- Microsoft 365 E5
- Microsoft Defender Suite (formerly Microsoft 365 E5 Security)
- Microsoft Defender Suite FLW
- Microsoft Defender + Purview Suite FLW
- Enterprise Mobility + Security E5

Entra ID P2 is also included in Microsoft Defender Suite for Microsoft 365 Business Premium and Microsoft Defender and Purview Suites for Microsoft 365 Business Premium for small to medium businesses.

**Microsoft Entra Suite** - The suite combines Microsoft Entra products to secure access for your employees. It allows administrators to provide secure access from anywhere to any app or resource whether cloud or on-premises, while ensuring least privilege access. A Microsoft Entra ID P1 subscription is required. The Microsoft Entra suite includes five products:

- Microsoft Entra Private Access
- Microsoft Entra Internet Access
- Microsoft Entra ID Governance
- Microsoft Entra ID Protection
- Microsoft Entra Verified ID (premium capabilities)

Important

User and group license assignments are managed through the Microsoft 365 Admin Center. For more information on how to assign or unassign licenses to users and groups, see this article:
- [Assign or unassign licenses for users in the Microsoft 365 admin center]

## App provisioning

Microsoft Entra application proxy requires Microsoft Entra ID P1 or P2 licenses. For more information about licensing, see [Microsoft Entra pricing.][Microsoft Entra pricing page]

## Authentication

The following table lists features that are available for authentication in the various versions of Microsoft Entra ID. Plan out your needs for securing user sign-in, then determine which approach meets those requirements. For example, although Microsoft Entra ID Free provides security defaults with multifactor authentication, only Microsoft Authenticator can be used for the authentication prompt, including text and voice calls. This approach might be a limitation if you can\'t make sure that Authenticator is installed on a user\'s personal device.

*Se MS Learn för full dokumentation.*

## MS Learn-källa
[Entra Verified ID Premium](https://learn.microsoft.com/entra/fundamentals/licensing#microsoft-entra-verified-id)

## Relaterade notes
- Entra Suite Index

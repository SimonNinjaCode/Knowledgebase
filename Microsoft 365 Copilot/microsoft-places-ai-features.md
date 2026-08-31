---
layout:
  width: wide
domain: m365-e7
id: "M365-COP-PLACES-001"
title: "Microsoft Places overview - Microsoft Places"
sources: ["m365maps E7"]
ms-learn: "https://learn.microsoft.com/microsoft-365/places/places-overview"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#copilot", "#platform"]
group: "platform"
---

# Microsoft Places overview - Microsoft Places

## Översikt

Microsoft Places (AI features) — en del av Microsoft 365 E7. Se [Microsoft Learn](https://learn.microsoft.com/microsoft-365/places/places-overview) för full dokumentation.

## Innehåll

Microsoft Places is an AI-powered workplace app that supports flexible work. It helps organizations reimagine flexible work with AI, enables employees to connect more easily in person so that they can make the most of in-office days, and optimizes space management with occupancy and utilization data.

Places features are directly embedded in Teams and Outlook so they can be used in the flow of work.

Microsoft Places also adds support for individual desk booking to Microsoft 365.

Most Places features depend on a fully established hierarchy of buildings, floors, and rooms/workspaces/desks. Go to [Configuring buildings and floors] for more information on configuring this hierarchy. 

## Licensing requirements

### Supported user licenses

Users with one the following plans can access Microsoft Places:

- Microsoft 365 Business Basic, Standard, Premium

- Microsoft 365 or Office 365 (E1, E3, E5)

- Microsoft 365 or Office 365 for Education (A1, A3, A5)

- Microsoft 365 for frontline workers (F1, F3)

- Microsoft Teams Enterprise

- Microsoft Teams Essentials

- Microsoft Teams standalone

### Core features

These features are available to all users with one of these plans. Some features need to be explicitly enabled, as described in the Configure Places section of this guide.

- Work plans and workplace presence

- In-person events and hybrid RSVP

- Automatic detection of work location

- Book room and workspaces (also known as desk pools)

- Desk assignment

- Places Management portal (requires specific permissions described [here])

- Places explorer

- Places finder

- Places analytics (with some limitations. Also requires specific enablement described here)

### Premium features

The following features used to require a Teams Premium license. As of April 1st, 2026, these features have shifted to a per-space licensing model:

- **Individual desk booking** shifts from a per-user to a per-space licensing model. To ensure a smooth transition, customers with active Teams Premium subscriptions continue to enjoy premium features until renewal.

- **Auto-release** requires rooms and desks to have a space license

- **Occupancy reports** in Places analytics requires rooms and desks to have a space license. Other analytics features don\'t require any other license.

### Supported space licenses

- Microsoft Teams Room (\"MTR\"), which can be used on meeting rooms
- Microsoft Teams Shared Space (\"MTSS\"). This was previously called Microsoft Teams Shared Device and is renamed to Shared Space for clarity. This license can be used with BYOD rooms, common area phones, and now with individual desks
- Microsoft Teams Shared Space -- Single Space (\"MTSS-SS\"). You can acquire 3 free MTSS-SS licenses for each purchased MTSS license. MTSS-SS licenses can be used with BYOD rooms or individual desks, but not with common area phones.

  Space type        Places features                           License required
  ----------------- ----------------------------------------- ----------------------
  Room              Autorelease, Occupancy reports            MTR, MTSS or MTSS-SS
  Individual desk   Booking, Autorelease, Occupancy reports   MTSS or MTSS-SS

If you use an MTSS license for a Teams common area phone, you can't use the 3 free MTSS-SS licenses for rooms or desks.
If you use an MTSS license for a BYOD room or an individual desk, you can use the 3 free MTSS-SS licenses for 3 more rooms or desks.
Refer to the FAQ section for more details.

### AI features

AI-driven features such as Copilot room booking require a Microsoft 365 Copilot license.

### Transition period for individual desk booking

- Before April 1st, 2026: users needed a Teams Premium license to book a desk. Space licenses were ignored.

- Transition period, starting in April 2026:

*Se MS Learn för full dokumentation.*

## MS Learn-källa
[Microsoft Places (AI features)](https://learn.microsoft.com/microsoft-365/places/places-overview)

## Relaterade notes
- Copilot Index

---
domain: m365-e7
id: "M365-COP-PG-001"
title: "Understand Prompt Gallery in Copilot"
sources: ["m365maps E7"]
ms-learn: "https://learn.microsoft.com/microsoft-365/copilot/copilot-prompt-gallery"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#copilot", "#core"]
group: "core"
---

# Understand Prompt Gallery in Copilot

## Översikt

Copilot Prompt Gallery — en del av Microsoft 365 E7. Se [Microsoft Learn](https://learn.microsoft.com/microsoft-365/copilot/copilot-prompt-gallery) för full dokumentation.

## Innehåll

Microsoft Prompt Gallery in Copilot is a resource of Microsoft-created prompts, videos, and articles that help your users understand and use Microsoft Copilot effectively. Prompt Gallery is available within Microsoft 365 Copilot or Copilot Chat.

As an admin, you can use analytics and reporting tools to track usage and engagement with Prompt Gallery content, including the following data:

- The saved, liked, and shared prompts of a specific user.
- The prompts shared with a specific team.

For information on how you can export this data, see [Export prompts that users saved, liked, or shared in Prompt Gallery].

This article covers Prompt Gallery architecture, data flows, security, and privacy.

## Overview

[![Screenshot showing the prompts available to try in Copilot Prompt Gallery.]][3]

Prompt Gallery is a comprehensive catalog of Copilot prompts that highlights key scenarios and capabilities of Microsoft Copilot, designed to help users become proficient in using Copilot to accomplish their tasks. The Prompt Gallery contains Microsoft-curated prompts (under **Suggested**), as well as prompts created and saved by users (under **Your Prompts**) and by team (under **Teams**).

Copilot prompts can be saved and shared across teams using Prompt Gallery to promote consistency and collaboration. Each prompt within Prompt Gallery includes tips for personalization and extension, allowing users to tailor experiences to organizational needs.

For more information about how your users can use Copilot Prompt Gallery, see [Learn about Copilot prompts] and [Sharing prompts with your team].

## Compliance considerations

Prompt Gallery processes and manages data in a structured manner to ensure compliance and security. The following are key data compliance considerations:

1.  Authenticated users can access Prompt Gallery from Microsoft 365 Copilot. Unauthenticated users can only see Microsoft-authored prompts online at [Copilot Prompts], however, users must authenticate to try any of them in Copilot.
2.  Prompt Gallery accesses Microsoft-authored Copilot prompts from the public catalog.
3.  Prompt Gallery also accesses user-created Copilot prompts from user and group collections in the Microsoft 365 Substrate data store.

The Copilot prompts are stored in collections within the Substrate Data Store, which is a storage type that allows applications to store files and data and enables efficient indexing and search. There are collections for users and groups, all of which are within the tenant boundary. All data is encrypted, transported via a secure pipeline, and is accessible only via Substrate APIs.

## Related content

- [Export prompts that users saved, liked, or shared in Copilot Prompt Gallery][Export prompts that users saved, liked, or shared in Prompt Gallery]
- [Copilot Prompt Gallery][Copilot Prompts]
- [Microsoft Copilot help & learning]
- [Data, Privacy, and Security for Microsoft 365 Copilot]

------------------------------------------------------------------------

## Feedback 

Need help with this topic?

Want to try using Ask Learn to clarify or guide you through this topic?

Suggest a fix?

------------------------------------------------------------------------

## Additional resources 

------------------------------------------------------------------------

- [
  Last updated on
  2026-02-07

*Se MS Learn för full dokumentation.*

## MS Learn-källa
[Copilot Prompt Gallery](https://learn.microsoft.com/microsoft-365/copilot/copilot-prompt-gallery)

## Relaterade notes
- Copilot Index

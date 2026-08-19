---
domain: m365-e7
id: "M365-ENTRA-FC-001"
title: "Tutorial - Use Face Check with Microsoft Entra Verified ID - Microsoft Entra Verified ID"
sources: ["m365maps E7"]
ms-learn: "https://learn.microsoft.com/entra/verified-id/using-facecheck"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#identity", "#verified-id"]
group: "verified-id"
---

# Tutorial - Use Face Check with Microsoft Entra Verified ID - Microsoft Entra Verified ID

## Översikt

Face Check — en del av Microsoft 365 E7. Se [Microsoft Learn](https://learn.microsoft.com/entra/verified-id/using-facecheck) för full dokumentation.

## Innehåll

## Overview

Face Check is a privacy-respecting facial matching. It allows enterprises to perform high-assurance verifications securely, simply, and at scale. Face Check adds a critical layer of trust by performing facial matching between a user's real-time selfie and a photo. The facial matching is powered by Azure AI services. Face Check protects user privacy by sharing only the match results and not any sensitive identity data, while allowing organizations to be sure the person claiming an identity is really them.

![Screenshot of Microsoft Authenticator Face Check verification flow showing verify, confirm, and review steps with facial recognition interface.]

## Prerequisites

Face Check is a premium feature within Verified ID. If you\'re a Microsoft Entra Suite customer, Face Check is included as part of the Suite. If you\'re not using Microsoft Entra Suite, you need to enable the Face Check Add-on in your Microsoft Entra Verified ID setup before doing Face Check verifications.

- Make sure Microsoft Entra Verified ID is [set up in your tenant] before using Face Check.
- [Associate or add an Azure subscription to your Microsoft Entra tenant]
- Make sure the user setting up Face Check has [Contributor role for the Azure subscription]

## Set up Face Check with Microsoft Entra Verified ID

The Face Check Add-on can be enabled in two ways from the Microsoft Entra Admin Center or by using the [Azure Resource Manager (ARM) Rest API] via CLI. If you\'re going to use Face Check in a tenant with the [Microsoft Entra Suite license], Face Check is enabled at the tenant level, and the configuration applies to all authorities within that tenant. For any other licenses, you can enable Face Check individually by each authority on your tenant using the Azure Resource Manager (ARM) Rest API.

The ARM Rest API for Microsoft Entra Verified ID is currently in preview.

### Set up Face Check with Microsoft Entra Verified ID in the Admin Center

To enable the Face Check add-on from the admin center, follow these steps:

1.  In the Verified ID overview page, scroll down to the new Add-ons section and **Enable** the Face Check add-on.

    [
    ![Screenshot of Microsoft Entra Verified ID overview page showing Face Check add-on in Add-ons section with Enable button.]

2.  In the Link a subscription step, select a Subscription, a Resource group, and the Resource location. Then select **Validate**. If there are no subscriptions listed, see [What if I can\'t find a subscription?]

    [
    ![Screenshot of Face Check subscription linking dialog showing dropdown menus for Subscription, Resource group, and Resource location with Validate button.]

3.  Once validated, you can **Enable** the add-on.

    [
    ![Screenshot of Face Check add-on configuration showing successful validation with Enable button to activate the service.]

Now you can start using Face Check in your enterprise applications.

### Set up Face Check with Microsoft Entra Verified ID using the Azure Resource Manager (ARM) Rest API

The ARM Rest API for Microsoft Entra Verified ID is currently in preview.

To set up the Face Check Add-on on a given authority, you must have the [Azure PowerShell tools] in your machine. This mechanism wraps the REST call. You can alternatively use the Azure Resource Manager (ARM) Rest API PUT accordingly.

1.  Run the following command in PowerShell.

    ``` lang-http
    az login --tenant  <tenant ID>
    ```

2.  Select the subscription that you want to enable Face Check billing on.

3.  Run the following command.

    ``` lang-http
    az rest --method PUT --uri /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.VerifiedId/authorities/?api-version=2024-01-26-preview --body ""
    ```

*Se MS Learn för full dokumentation.*

## MS Learn-källa
[Face Check](https://learn.microsoft.com/entra/verified-id/using-facecheck)

## Relaterade notes
- Entra Suite Index

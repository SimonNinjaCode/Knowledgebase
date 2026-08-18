# Conditional Access Design

**Created:** 2025-04-02

## Introduction

This document outlines the configuration details for Entra ID Conditional Access (CA) policies within your organization. Conditional Access is a critical component of modern identity security, providing dynamic and automated access control decisions based on user, device, location, and session risk.

By leveraging Conditional Access, our goal is to enhance security posture while maintaining a seamless user experience. This design ensures that only trusted users and devices can access organizational resources under the right conditions, aligning with our compliance requirements and operational objectives.


## Policies

- [GLOBAL - 1010 - BLOCK - Legacy Authentication](#global---1010---block---legacy-authentication)

- [GLOBAL - 1020 - BLOCK - Device Code Auth Flow](#global---1020---block---device-code-auth-flow)

- [GLOBAL - 1030 - BLOCK - Unsupported Device Platforms](#global---1030---block---unsupported-device-platforms)

- [GLOBAL - 1040 - BLOCK - All Countries Except Allowed](#global---1040---block---all-countries-except-allowed)

- [GLOBAL - 1050 - BLOCK - High-Risk Countries](#global---1050---block---high-risk-countries)

- [GLOBAL - 1060 - BLOCK - Service Accounts (Trusted Locations Excluded)](#global---1060---block---service-accounts-trusted-locations-excluded)

- [GLOBAL - 1070 - BLOCK - Explicitly Blocked Cloud Apps](#global---1070---block---explicitly-blocked-cloud-apps)

- [GLOBAL - 1080 - BLOCK - Guest Access to Sensitive Apps](#global---1080---block---guest-access-to-sensitive-apps)

- [GLOBAL - 1090 - BLOCK - High-Risk Sign-Ins](#global---1090---block---high-risk-sign-ins)

- [GLOBAL - 1100 - BLOCK - High-Risk Users](#global---1100---block---high-risk-users)

- [GLOBAL - 2010 - GRANT - Medium-Risk Sign-Ins](#global---2010---grant---medium-risk-sign-ins)

- [GLOBAL - 2020 - GRANT - Medium-Risk Users](#global---2020---grant---medium-risk-users)

- [GLOBAL - 2040 - GRANT - Terms of Use (All users)](#global---2040---grant---terms-of-use-all-users)

- [GLOBAL - 2050 - GRANT - MFA for All Users](#global---2050---grant---mfa-for-all-users)

- [GLOBAL - 2055 - GRANT - Phishing Resistant MFA for Admins](#global---2055---grant---phishing-resistant-mfa-for-admins)

- [GLOBAL - 2060 - GRANT - Mobile Apps and Desktop Clients](#global---2060---grant---mobile-apps-and-desktop-clients)

- [GLOBAL - 2070 - GRANT - Mobile Device Access Requirements](#global---2070---grant---mobile-device-access-requirements)

- [GLOBAL - 3010 - SESSION - Admin Persistence (9 hours)](#global---3010---session---admin-persistence-9-hours)

- [GLOBAL - 3020 - SESSION - BYOD Persistence](#global---3020---session---byod-persistence)

- [GLOBAL - 3030 - SESSION - Register Security Info Requirements](#global---3030---session---register-security-info-requirements)

- [GLOBAL - 3040 - SESSION - Block File Downloads On Unmanaged Devices](#global---3040---session---block-file-downloads-on-unmanaged-devices)

- [OVERRIDE - 0001 - GRANT - Example](#override---0001---grant---example)


### GLOBAL - 1010 - BLOCK - Legacy Authentication

| **Policy Name** | GLOBAL - 1010 - BLOCK - Legacy Authentication |
| ----------- | ----------- |
| **ID** | 1010 |
| **Description** | This global policy blocks all connections from insecure legacy protocols like ActiveSync, IMAP, POP3, etc. Blocking legacy authentication, together with MFA, is one of the most important security improvements your can do in the cloud. |

```json
{
  "displayName": "GLOBAL - 1010 - BLOCK - Legacy Authentication",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [
        "All"
      ],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access",
        "Excluded from Legacy Authentication Block"
      ],
      "excludeRoles": [],
      "includeRoles": []
    },
    "devices": null,
    "locations": null,
    "clientAppTypes": [
      "exchangeActiveSync",
      "other"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [],
      "includeApplications": [
        "All"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": {
    "operator": "OR",
    "builtInControls": [
      "block"
    ],
    "customAuthenticationFactors": [],
    "termsOfUse": [],
    "authenticationStrength": null
  },
  "sessionControls": null,
  "templateId": null
}
```

---


### GLOBAL - 1020 - BLOCK - Device Code Auth Flow

| **Policy Name** | GLOBAL - 1020 - BLOCK - Device Code Auth Flow |
| ----------- | ----------- |
| **ID** | 1020 |
| **Description** | This policy blocks users from signing in with OAuth 2.0 device authorization grant flow. https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-device-code |

```json
{
  "displayName": "GLOBAL - 1020 - BLOCK - Device Code Auth Flow",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [
        "All"
      ],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access",
        "Excluded from Device Code Auth Flow Block"
      ],
      "excludeRoles": [],
      "includeRoles": []
    },
    "devices": null,
    "locations": null,
    "authenticationFlows": {
      "transferMethods": "deviceCodeFlow,authenticationTransfer"
    },
    "clientAppTypes": [
      "all"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [],
      "includeApplications": [
        "All"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": {
    "operator": "OR",
    "builtInControls": [
      "block"
    ],
    "customAuthenticationFactors": [],
    "termsOfUse": [],
    "authenticationStrength": null
  },
  "sessionControls": null,
  "templateId": null
}
```

---


### GLOBAL - 1030 - BLOCK - Unsupported Device Platforms

| **Policy Name** | GLOBAL - 1030 - BLOCK - Unsupported Device Platforms |
| ----------- | ----------- |
| **ID** | 1030 |
| **Description** | Block unsupported platforms like Windows Phone, Linux, and other OS variants. Note: Device platform detection is a best effort security signal based on the user agent string and can be spoofed. Always combine this with additional signals like MFA and/or device authentication. |

```json
{
  "displayName": "GLOBAL - 1030 - BLOCK - Unsupported Device Platforms",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": {
      "includePlatforms": [
        "all"
      ],
      "excludePlatforms": [
        "android",
        "iOS",
        "windows",
        "macOS"
      ]
    },
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [
        "All"
      ],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access",
        "Excluded from Legacy Authentication Block"
      ],
      "excludeRoles": [],
      "includeRoles": []
    },
    "devices": null,
    "locations": null,
    "clientAppTypes": [
      "all"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [],
      "includeApplications": [
        "All"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": {
    "operator": "OR",
    "builtInControls": [
      "block"
    ],
    "customAuthenticationFactors": [],
    "termsOfUse": [],
    "authenticationStrength": null
  },
  "sessionControls": null,
  "templateId": null
}
```

---


### GLOBAL - 1040 - BLOCK - All Countries Except Allowed

| **Policy Name** | GLOBAL - 1040 - BLOCK - All Countries Except Allowed |
| ----------- | ----------- |
| **ID** | 1040 |
| **Description** | This global policy blocks all connections from countries not in the Allowed countries whitelist. You should only allow countries where you expect your users to sign in from. This is not a strong security solution since attackers will easily bypass this with a proxy service, however, this effectively blocks a lot of the automated noise in the cloud. |

```json
{
  "displayName": "GLOBAL - 1040 - BLOCK - Countries not Allowed",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "locations": {
      "excludeLocations": [
        "Allowed CountriesxxSExxNOxxDKxxFI"
      ],
      "includeLocations": [
        "All"
      ]
    },
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [
        "All"
      ],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access",
        "Excluded from Country Block List"
      ],
      "excludeRoles": [],
      "includeRoles": []
    },
    "devices": null,
    "clientAppTypes": [
      "all"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [],
      "includeApplications": [
        "All"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": {
    "operator": "OR",
    "builtInControls": [
      "block"
    ],
    "customAuthenticationFactors": [],
    "termsOfUse": [],
    "authenticationStrength": null
  },
  "sessionControls": null,
  "templateId": null
}
```

---


### GLOBAL - 1050 - BLOCK - High-Risk Countries

| **Policy Name** | GLOBAL - 1050 - BLOCK - High-Risk Countries |
| ----------- | ----------- |
| **ID** | 1050 |
| **Description** | This global policy blocks all connections from countries in the High-Risk Countries list. This is not a strong security solution since attackers will easily bypass this with a proxy service, however, this effectively blocks a lot of the automated noise in the cloud. |

```json
{
  "displayName": "GLOBAL - 1050 - BLOCK - High-Risk Countries",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "locations": {
      "excludeLocations": [],
      "includeLocations": [
        "High-Risk CountriesxxKPxxRUxxIR"
      ]
    },
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [
        "All"
      ],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access"
      ],
      "excludeRoles": [],
      "includeRoles": []
    },
    "devices": null,
    "clientAppTypes": [
      "all"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [],
      "includeApplications": [
        "All"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": {
    "operator": "OR",
    "builtInControls": [
      "block"
    ],
    "customAuthenticationFactors": [],
    "termsOfUse": [],
    "authenticationStrength": null
  },
  "sessionControls": null,
  "templateId": null
}
```

---


### GLOBAL - 1060 - BLOCK - Service Accounts (Trusted Locations Excluded)

| **Policy Name** | GLOBAL - 1060 - BLOCK - Service Accounts (Trusted Locations Excluded) |
| ----------- | ----------- |
| **ID** | 1060 |
| **Description** | Block service accounts (real Entra ID user accounts used by non-humans) from untrusted IP addresses. Service accounts can only connect from allowed IP addresses, but without MFA requirement. Only use service accounts as a last resort! |

```json
{
  "displayName": "GLOBAL - 1060 - BLOCK - Service Accounts (Trusted Locations Excluded)",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "locations": {
      "excludeLocations": [
        "Service Accounts Trusted IPs"
      ],
      "includeLocations": [
        "All"
      ]
    },
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [
        "Conditional Access Service Accounts"
      ],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access"
      ],
      "excludeRoles": [],
      "includeRoles": []
    },
    "devices": null,
    "clientAppTypes": [
      "all"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [],
      "includeApplications": [
        "All"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": {
    "operator": "OR",
    "builtInControls": [
      "block"
    ],
    "customAuthenticationFactors": [],
    "termsOfUse": [],
    "authenticationStrength": null
  },
  "sessionControls": null,
  "templateId": null
}
```

---


### GLOBAL - 1070 - BLOCK - Explicitly Blocked Cloud Apps

| **Policy Name** | GLOBAL - 1070 - BLOCK - Explicitly Blocked Cloud Apps |
| ----------- | ----------- |
| **ID** | 1070 |
| **Description** | This policy can be used to explicitly block certain cloud apps across the organisation. This is handy if you want to permanently block certain apps, or temporary block unwanted apps, for example, if there is a known critical security flaw. |

```json
{
  "displayName": "GLOBAL - 1070 - BLOCK - Explicitly Blocked Cloud Apps",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [
        "All"
      ],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access"
      ],
      "excludeRoles": [],
      "includeRoles": []
    },
    "devices": null,
    "locations": null,
    "clientAppTypes": [
      "all"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [],
      "includeApplications": [
        "None"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": {
    "operator": "OR",
    "builtInControls": [
      "block"
    ],
    "customAuthenticationFactors": [],
    "termsOfUse": [],
    "authenticationStrength": null
  },
  "sessionControls": null,
  "templateId": null
}
```

---


### GLOBAL - 1080 - BLOCK - Guest Access to Sensitive Apps

| **Policy Name** | GLOBAL - 1080 - BLOCK - Guest Access to Sensitive Apps |
| ----------- | ----------- |
| **ID** | 1080 |
| **Description** | Block guests from accessing sensitive apps like Microsoft Admin Portals. |

```json
{
  "displayName": "GLOBAL - 1080 - BLOCK - Guest Access to Sensitive Apps",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": {
        "externalTenants": {
          "membershipKind": "all",
          "@odata.type": "#microsoft.graph.conditionalAccessAllExternalTenants"
        },
        "guestOrExternalUserTypes": "internalGuest,b2bCollaborationGuest,b2bCollaborationMember,b2bDirectConnectUser,otherExternalUser"
      },
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access"
      ],
      "excludeRoles": [],
      "includeRoles": []
    },
    "devices": null,
    "locations": null,
    "clientAppTypes": [
      "all"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [],
      "includeApplications": [
        "MicrosoftAdminPortals",
        "797f4846-ba00-4fd7-ba43-dac1f8f63013"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": {
    "operator": "OR",
    "builtInControls": [
      "block"
    ],
    "customAuthenticationFactors": [],
    "termsOfUse": [],
    "authenticationStrength": null
  },
  "sessionControls": null,
  "templateId": null
}
```

---


### GLOBAL - 1090 - BLOCK - High-Risk Sign-Ins

| **Policy Name** | GLOBAL - 1090 - BLOCK - High-Risk Sign-Ins |
| ----------- | ----------- |
| **ID** | 1090 |
| **Description** | This global policy blocks all high-risk authentications detected by Entra ID Protection. This is called risk-based Conditional Access. Note that this policy requires Entra ID P2 for all targeted users. |

```json
{
  "displayName": "GLOBAL - 1090 - BLOCK - High-Risk Sign-Ins",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [
        "All"
      ],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access"
      ],
      "excludeRoles": [],
      "includeRoles": []
    },
    "devices": null,
    "locations": null,
    "clientAppTypes": [
      "all"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [],
      "includeApplications": [
        "All"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": [
      "high"
    ]
  },
  "grantControls": {
    "operator": "OR",
    "builtInControls": [
      "block"
    ],
    "customAuthenticationFactors": [],
    "termsOfUse": [],
    "authenticationStrength": null
  },
  "sessionControls": null,
  "templateId": null
}
```

---


### GLOBAL - 1100 - BLOCK - High-Risk Users

| **Policy Name** | GLOBAL - 1100 - BLOCK - High-Risk Users |
| ----------- | ----------- |
| **ID** | 1100 |
| **Description** | Same as above but looks at the user risk level instead of the sign-in risk level. For example, many medium risk sign-ins can result in a high-risk user. |

```json
{
  "displayName": "GLOBAL - 1100 - BLOCK - High-Risk Users",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [
      "high"
    ],
    "clientApplications": null,
    "times": null,
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [
        "All"
      ],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access"
      ],
      "excludeRoles": [],
      "includeRoles": []
    },
    "devices": null,
    "locations": null,
    "clientAppTypes": [
      "all"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [],
      "includeApplications": [
        "All"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": {
    "operator": "OR",
    "builtInControls": [
      "block"
    ],
    "customAuthenticationFactors": [],
    "termsOfUse": [],
    "authenticationStrength": null
  },
  "sessionControls": null,
  "templateId": null
}
```

---


### GLOBAL - 2010 - GRANT - Medium-Risk Sign-Ins

| **Policy Name** | GLOBAL - 2010 - GRANT - Medium-Risk Sign-Ins |
| ----------- | ----------- |
| **ID** | 2010 |
| **Description** | This global policy enforces MFA on all medium-risk authentications detected by Entra ID Protection. |

```json
{
  "displayName": "GLOBAL - 2010 - GRANT - Medium-Risk Sign-ins",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [
        "All"
      ],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access"
      ],
      "excludeRoles": [],
      "includeRoles": []
    },
    "devices": null,
    "locations": null,
    "clientAppTypes": [
      "all"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [],
      "includeApplications": [
        "All"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": [
      "medium"
    ]
  },
  "grantControls": {
    "operator": "OR",
    "builtInControls": [],
    "customAuthenticationFactors": [],
    "termsOfUse": [],
    "authenticationStrength": {
      "id": "00000000-0000-0000-0000-000000000002"
    }
  },
  "sessionControls": {
    "cloudAppSecurity": null,
    "continuousAccessEvaluation": null,
    "applicationEnforcedRestrictions": null,
    "signInFrequency": {
      "type": null,
      "value": null,
      "frequencyInterval": "everyTime",
      "authenticationType": "primaryAndSecondaryAuthentication",
      "isEnabled": true
    },
    "secureSignInSession": null,
    "persistentBrowser": null,
    "disableResilienceDefaults": null
  },
  "templateId": null
}
```

---


### GLOBAL - 2020 - GRANT - Medium-Risk Users

| **Policy Name** | GLOBAL - 2020 - GRANT - Medium-Risk Users |
| ----------- | ----------- |
| **ID** | 2020 |
| **Description** | Same as above but looks at the user risk level instead of the sign-in risk level. |

```json
{
  "displayName": "GLOBAL - 2020 - GRANT - Medium-Risk Users",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [
      "medium"
    ],
    "clientApplications": null,
    "times": null,
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [
        "All"
      ],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access"
      ],
      "excludeRoles": [],
      "includeRoles": []
    },
    "devices": null,
    "locations": null,
    "clientAppTypes": [
      "all"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [],
      "includeApplications": [
        "All"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": {
    "operator": "OR",
    "builtInControls": [],
    "customAuthenticationFactors": [],
    "termsOfUse": [],
    "authenticationStrength": {
      "id": "00000000-0000-0000-0000-000000000002"
    }
  },
  "sessionControls": {
    "cloudAppSecurity": null,
    "continuousAccessEvaluation": null,
    "applicationEnforcedRestrictions": null,
    "signInFrequency": {
      "type": null,
      "value": null,
      "frequencyInterval": "everyTime",
      "authenticationType": "primaryAndSecondaryAuthentication",
      "isEnabled": true
    },
    "secureSignInSession": null,
    "persistentBrowser": null,
    "disableResilienceDefaults": null
  },
  "templateId": null
}
```

---


### GLOBAL - 2040 - GRANT - Terms of Use (All users)

| **Policy Name** | GLOBAL - 2040 - GRANT - Terms of Use (All users) |
| ----------- | ----------- |
| **ID** | 2040 |
| **Description** | This global policy forces Terms of Use, like an Terms of Use or NDA, on all users. Users must read and agree to this policy the first time they sign in before they're granted access. |

```json
{
  "displayName": "GLOBAL - 2040 - GRANT - Terms of Use (All users)",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [
        "All"
      ],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access",
        "Conditional Access Service Accounts"
      ],
      "excludeRoles": [
        "d29b2b05-8046-44ba-8758-1e26182fcf32"
      ],
      "includeRoles": []
    },
    "devices": null,
    "locations": null,
    "clientAppTypes": [
      "all"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [],
      "includeApplications": [
        "All"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": {
    "operator": "OR",
    "builtInControls": [],
    "customAuthenticationFactors": [],
    "termsOfUse": [
      "Terms of Use"
    ],
    "authenticationStrength": null
  },
  "sessionControls": null,
  "templateId": null
}
```

---


### GLOBAL - 2050 - GRANT - MFA for All Users

| **Policy Name** | GLOBAL - 2050 - GRANT - MFA for All Users |
| ----------- | ----------- |
| **ID** | 2050 |
| **Description** | Protects all user authentications with MFA. This policy applies to both internal users and guest users on all devices and clients. Intune enrollment is excluded since MFA is not supported during enrollment of fully managed devices. |

```json
{
  "displayName": "GLOBAL - 2050 - GRANT - MFA for All Users",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [
        "All"
      ],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access",
        "Conditional Access Service Accounts"
      ],
      "excludeRoles": [
        "d29b2b05-8046-44ba-8758-1e26182fcf32"
      ],
      "includeRoles": []
    },
    "devices": null,
    "locations": null,
    "clientAppTypes": [
      "all"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [
        "0000000a-0000-0000-c000-000000000000"
      ],
      "includeUserActions": [],
      "includeApplications": [
        "All"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": {
    "operator": "OR",
    "builtInControls": [],
    "customAuthenticationFactors": [],
    "termsOfUse": [],
    "authenticationStrength": {
      "id": "00000000-0000-0000-0000-000000000002"
    }
  },
  "sessionControls": null,
  "templateId": null
}
```

---


### GLOBAL - 2055 - GRANT - Phishing Resistant MFA for Admins

| **Policy Name** | GLOBAL - 2055 - GRANT - Phishing Resistant MFA for Admins |
| ----------- | ----------- |
| **ID** | 2055 |
| **Description** | Protects privileged admin roles with phishing resistant MFA, like FIDO2. |

```json
{
  "displayName": "GLOBAL - 2055 - GRANT - Phishing Resistant MFA for Admins",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "deviceStates": null,
    "devices": null,
    "users": {
      "excludeGuestsOrExternalUsers": null,
      "includeRoles": [
        "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3",
        "0526716b-113d-4c15-b2c8-68e3c22b9f80",
        "158c047a-c907-4556-b7ef-446551a6b5f7",
        "17315797-102d-40b4-93e0-432062caca18",
        "e6d1a23a-da11-4be4-9570-befc86d067a7",
        "b1be1c3e-b65d-4f19-8427-f6fa0d97feb9",
        "62e90394-69f5-4237-9190-012177145e10",
        "8ac3fc64-6eca-42ea-9e69-59f4c7b60eb2",
        "7be44c8a-adaf-4e2a-84d6-ab2649e08a13",
        "e8611ab8-c189-46e8-94e1-60213ab1f814",
        "194ae4cb-b126-40b2-bd5b-6091b380977d"
      ],
      "includeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access"
      ],
      "includeGroups": [],
      "excludeUsers": [],
      "includeGuestsOrExternalUsers": null,
      "excludeRoles": []
    },
    "clientApplications": null,
    "applications": {
      "includeAuthenticationContextClassReferences": [],
      "includeUserActions": [],
      "includeApplications": [
        "All"
      ],
      "applicationFilter": null,
      "excludeApplications": []
    },
    "signInRiskLevels": [],
    "userRiskLevels": [],
    "platforms": null,
    "clientAppTypes": [
      "all"
    ],
    "times": null,
    "locations": null
  },
  "grantControls": {
    "builtInControls": [],
    "customAuthenticationFactors": [],
    "termsOfUse": [],
    "authenticationStrength": {
      "id": "00000000-0000-0000-0000-000000000004"
    },
    "operator": "OR"
  },
  "sessionControls": null,
  "partialEnablementStrategy": null,
  "templateId": null
}
```

---


### GLOBAL - 2060 - GRANT - Mobile Apps and Desktop Clients

| **Policy Name** | GLOBAL - 2060 - GRANT - Mobile Apps and Desktop Clients |
| ----------- | ----------- |
| **ID** | 2060 |
| **Description** | Requires mobile apps and desktop clients to be Intune compliant. BYOD is blocked. |

```json
{
  "displayName": "GLOBAL - 2060 - GRANT - Mobile Apps and Desktop Clients",
  "state": "disabled",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [
        "All"
      ],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access",
        "Conditional Access Service Accounts"
      ],
      "excludeRoles": [
        "d29b2b05-8046-44ba-8758-1e26182fcf32"
      ],
      "includeRoles": []
    },
    "devices": null,
    "locations": null,
    "clientAppTypes": [
      "mobileAppsAndDesktopClients"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [],
      "includeApplications": [
        "All"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": {
    "operator": "OR",
    "builtInControls": [
      "compliantDevice"
    ],
    "customAuthenticationFactors": [],
    "termsOfUse": [],
    "authenticationStrength": null
  },
  "sessionControls": null,
  "templateId": null
}
```

---


### GLOBAL - 2070 - GRANT - Mobile Device Access Requirements

| **Policy Name** | GLOBAL - 2070 - GRANT - Mobile Device Access Requirements |
| ----------- | ----------- |
| **ID** | 2070 |
| **Description** | Requires apps to be protected by Intune App Protection Policies (MAM) on iOS and Android. This blocks third-party app store apps and encrypts org data on mobile devices. |

```json
{
  "displayName": "GLOBAL - 2070 - GRANT - Mobile Device Access Requirements",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": {
      "includePlatforms": [
        "android",
        "iOS"
      ],
      "excludePlatforms": []
    },
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [
        "All"
      ],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access",
        "Conditional Access Service Accounts"
      ],
      "excludeRoles": [],
      "includeRoles": []
    },
    "devices": null,
    "locations": null,
    "clientAppTypes": [
      "mobileAppsAndDesktopClients"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [
        "0000000a-0000-0000-c000-000000000000"
      ],
      "includeUserActions": [],
      "includeApplications": [
        "All"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": {
    "operator": "OR",
    "builtInControls": [
      "compliantApplication"
    ],
    "customAuthenticationFactors": [],
    "termsOfUse": [],
    "authenticationStrength": null
  },
  "sessionControls": null,
  "templateId": null
}
```

---


### GLOBAL - 3010 - SESSION - Admin Persistence (9 hours)

| **Policy Name** | GLOBAL - 3010 - SESSION - Admin Persistence (9 hours) |
| ----------- | ----------- |
| **ID** | 3010 |
| **Description** | This policy disables token persistence for all accounts with admin roles assigned. It also sets the sign-in frequency to 9 hours. This is to protect against Primary Refresh Token stealing attacks by keeping such tokens few and short-lived. Always use separate cloud-only accounts for admin role assignments. |

```json
{
  "displayName": "GLOBAL - 3010 - SESSION - Admin Persistence",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access"
      ],
      "excludeRoles": [],
      "includeRoles": [
        "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3",
        "0526716b-113d-4c15-b2c8-68e3c22b9f80",
        "158c047a-c907-4556-b7ef-446551a6b5f7",
        "17315797-102d-40b4-93e0-432062caca18",
        "e6d1a23a-da11-4be4-9570-befc86d067a7",
        "b1be1c3e-b65d-4f19-8427-f6fa0d97feb9",
        "62e90394-69f5-4237-9190-012177145e10",
        "8ac3fc64-6eca-42ea-9e69-59f4c7b60eb2",
        "7be44c8a-adaf-4e2a-84d6-ab2649e08a13",
        "e8611ab8-c189-46e8-94e1-60213ab1f814",
        "194ae4cb-b126-40b2-bd5b-6091b380977d"
      ]
    },
    "devices": null,
    "locations": null,
    "clientAppTypes": [
      "all"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [],
      "includeApplications": [
        "All"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": null,
  "sessionControls": {
    "signInFrequency": {
      "frequencyInterval": "timeBased",
      "type": "hours",
      "value": 9,
      "isEnabled": true,
      "authenticationType": "primaryAndSecondaryAuthentication"
    },
    "cloudAppSecurity": null,
    "secureSignInSession": null,
    "disableResilienceDefaults": null,
    "applicationEnforcedRestrictions": null,
    "persistentBrowser": {
      "mode": "never",
      "isEnabled": true
    },
    "continuousAccessEvaluation": null
  },
  "templateId": null
}
```

---


### GLOBAL - 3020 - SESSION - BYOD Persistence

| **Policy Name** | GLOBAL - 3020 - SESSION - BYOD Persistence |
| ----------- | ----------- |
| **ID** | 3020 |
| **Description** | This policy disables token persistence for all accounts signing in from a non-compliant (unmanaged) device. It also sets the sign-in frequency to 9 hours. |

```json
{
  "displayName": "GLOBAL - 3020 - SESSION - BYOD Persistence",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": {
        "externalTenants": {
          "membershipKind": "all",
          "@odata.type": "#microsoft.graph.conditionalAccessAllExternalTenants"
        },
        "guestOrExternalUserTypes": "internalGuest,b2bCollaborationGuest,b2bCollaborationMember,b2bDirectConnectUser,otherExternalUser,serviceProvider"
      },
      "includeUsers": [
        "All"
      ],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access"
      ],
      "excludeRoles": [],
      "includeRoles": []
    },
    "devices": {
      "excludeDevices": [],
      "excludeDeviceStates": [],
      "includeDevices": [],
      "includeDeviceStates": [],
      "deviceFilter": {
        "mode": "exclude",
        "rule": "device.isCompliant -eq True"
      }
    },
    "locations": null,
    "clientAppTypes": [
      "all"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [],
      "includeApplications": [
        "All"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": null,
  "sessionControls": {
    "signInFrequency": {
      "frequencyInterval": "timeBased",
      "type": "hours",
      "value": 9,
      "isEnabled": true,
      "authenticationType": "primaryAndSecondaryAuthentication"
    },
    "cloudAppSecurity": null,
    "secureSignInSession": null,
    "disableResilienceDefaults": null,
    "applicationEnforcedRestrictions": null,
    "persistentBrowser": {
      "mode": "never",
      "isEnabled": true
    },
    "continuousAccessEvaluation": null
  },
  "templateId": null
}
```

---


### GLOBAL - 3030 - SESSION - Register Security Info Requirements

| **Policy Name** | GLOBAL - 3030 - SESSION - Register Security Info Requirements |
| ----------- | ----------- |
| **ID** | 3030 |
| **Description** | Require reauthentication when registering security info. This helps to protect against different identity theft attacks. |

```json
{
  "displayName": "GLOBAL - 3030 - SESSION - Register Security Info Requirements",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [
        "All"
      ],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access"
      ],
      "excludeRoles": [],
      "includeRoles": []
    },
    "devices": null,
    "locations": null,
    "clientAppTypes": [
      "all"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [
        "urn:user:registersecurityinfo"
      ],
      "includeApplications": [],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": null,
  "sessionControls": {
    "signInFrequency": {
      "frequencyInterval": "everyTime",
      "type": null,
      "value": null,
      "isEnabled": true,
      "authenticationType": "primaryAndSecondaryAuthentication"
    },
    "cloudAppSecurity": null,
    "secureSignInSession": null,
    "disableResilienceDefaults": null,
    "applicationEnforcedRestrictions": null,
    "persistentBrowser": null,
    "continuousAccessEvaluation": null
  },
  "templateId": null
}
```

---


### GLOBAL - 3040 - SESSION - Block File Downloads On Unmanaged Devices

| **Policy Name** | GLOBAL - 3040 - SESSION - Block File Downloads On Unmanaged Devices |
| ----------- | ----------- |
| **ID** | 3040 |
| **Description** | This policy blocks file downloads in SharePoint Online, Teams, OneDrive, and Exchange Online on unmanaged devices. Note that App Enforced Restrictions must be enabled in the services for this to work. |

```json
{
  "displayName": "GLOBAL - 3040 - SESSION - Block File Downloads On Unmanaged Devices",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [
        "All"
      ],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access"
      ],
      "excludeRoles": [],
      "includeRoles": []
    },
    "devices": {
      "excludeDevices": [],
      "excludeDeviceStates": [],
      "includeDevices": [],
      "includeDeviceStates": [],
      "deviceFilter": {
        "mode": "exclude",
        "rule": "device.isCompliant -eq True"
      }
    },
    "locations": null,
    "clientAppTypes": [
      "all"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [],
      "includeApplications": [
        "00000003-0000-0ff1-ce00-000000000000"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": null,
  "sessionControls": {
    "signInFrequency": null,
    "cloudAppSecurity": null,
    "secureSignInSession": null,
    "disableResilienceDefaults": null,
    "applicationEnforcedRestrictions": {
      "isEnabled": true
    },
    "persistentBrowser": null,
    "continuousAccessEvaluation": null
  },
  "templateId": null
}
```

---


### OVERRIDE - 0001 - GRANT - Example

| **Policy Name** | OVERRIDE - 0001 - GRANT - Example |
| ----------- | ----------- |
| **ID** | 0001 |
| **Description** | Finally, this is an example policy. All scenarios that deviates from the global baseline should have the OVERRIDE prefix, and be targeted by groups. These groups of users can be excluded from global policies. In this way, we have a strong foundations, and manages deviations with small groups of users. |

```json
{
  "displayName": "OVERRIDE - 0001 - GRANT - Example",
  "state": "disabled",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [
        "None"
      ],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access"
      ],
      "excludeRoles": [],
      "includeRoles": []
    },
    "devices": null,
    "locations": null,
    "clientAppTypes": [
      "all"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [],
      "includeApplications": [
        "None"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": {
    "operator": "OR",
    "builtInControls": [
      "mfa"
    ],
    "customAuthenticationFactors": [],
    "termsOfUse": [],
    "authenticationStrength": null
  },
  "sessionControls": null,
  "templateId": null
}
```

---


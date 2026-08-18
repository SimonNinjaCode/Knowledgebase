# Risk Detection and Remediation

## Identity Protection Risk Classifications

- **Sign-in Risk**
- **User Risk**

---

## Risk Detection Types

| Risk Detection Type                  | Description                                                                                      |
|-------------------------------------|--------------------------------------------------------------------------------------------------|
| Anonymous IP address                | Sign in from an anonymous IP address (e.g., Tor, anonymizer VPNs).                              |
| Atypical travel                     | Sign in from an unusual location based on user’s recent activity.                                |
| Malware-linked IP address           | Sign in from a known malware-linked IP address.                                                  |
| Unfamiliar sign-in properties       | Sign in with properties not previously associated with the user.                                 |
| Leaked credentials                  | The user’s valid credentials have been leaked.                                                   |
| Password spray                      | Multiple usernames attacked using common passwords (brute-force).                                |
| Entra ID Threat Intelligence        | Microsoft’s intelligence sources identified a known attack pattern.                              |
| New country                         | Detected by Microsoft Defender for Cloud Apps (MDA).                                             |
| Activity from anonymous IP address  | Detection by MDA.                                                                                |
| Suspicious inbox forwarding         | Detection by MDA.                                                                                |

---

## Identity Protection Notifications

Users in the **Global Administrator**, **Security Administrator**, or **Security Reader** roles are automatically added to alert lists if they have a valid email address configured.

- [Users At Risk Alerts](#)
- [Weekly Digest](#)

---

## Risk Detection Table

### Sign-in Risk Detections

| Risk Detection                                      | Detection Type         | License     | Event Type                          |
|----------------------------------------------------|------------------------|-------------|--------------------------------------|
| Activity from anonymous IP address                 | Offline                | Premium     | `riskyIPAddress`                     |
| Additional risk detected (sign-in)                 | Real-time or Offline   | Nonpremium  | `generic`                            |
| Admin confirmed user compromised                   | Offline                | Nonpremium  | `adminConfirmedUserCompromised`      |
| Anomalous Token (sign-in)                          | Real-time or Offline   | Premium     | `anomalousToken`                     |
| Anonymous IP address                               | Real-time              | Nonpremium  | `anonymizedIPAddress`                |
| Atypical travel                                    | Offline                | Premium     | `unlikelyTravel`                     |
| Impossible travel                                  | Offline                | Premium     | `mcasImpossibleTravel`               |
| Malicious IP address                               | Offline                | Premium     | `maliciousIPAddress`                 |
| Mass Access to Sensitive Files                     | Offline                | Premium     | `mcasFinSuspiciousFileAccess`        |
| Entra threat intelligence (sign-in)                | Real-time or Offline   | Nonpremium  | `investigationsThreatIntelligence`   |
| New country                                        | Offline                | Premium     | `newCountry`                         |
| Password spray                                     | Real-time or Offline   | Premium     | `passwordSpray`                      |
| Suspicious browser                                 | Offline                | Premium     | `suspiciousBrowser`                  |
| Suspicious inbox forwarding                        | Offline                | Premium     | `suspiciousInboxForwarding`          |
| Suspicious inbox manipulation rules                | Offline                | Premium     | `mcasSuspiciousInboxManipulationRules`|
| Token issuer anomaly                               | Offline                | Premium     | `tokenIssuerAnomaly`                 |
| Unfamiliar sign-in properties                      | Real-time              | Premium     | `unfamiliarFeatures`                 |
| Verified threat actor IP                           | Real-time              | Premium     | `nationStateIP`                      |

---

### User Risk Detections

| Risk Detection                                      | Detection Type         | License     | Event Type                          |
|----------------------------------------------------|------------------------|-------------|--------------------------------------|
| Additional risk detected (user)                    | Real-time or Offline   | Nonpremium  | `generic`                            |
| Anomalous Token (user)                             | Real-time or Offline   | Premium     | `anomalousToken`                     |
| Anomalous user activity                            | Offline                | Premium     | `anomalousUserActivity`              |
| Attacker in the Middle                             | Offline                | Premium     | `attackerInTheMiddle`                |
| Leaked credentials                                 | Offline                | Nonpremium  | `leakedCredentials`                  |
| Entra threat intelligence (user)                   | Real-time or Offline   | Nonpremium  | `investigationsThreatIntelligence`   |
| Attempt to access Primary Refresh Token (PRT)      | Offline                | Premium     | `attemptedPrtAccess`                 |
| Suspicious API Traffic                             | Offline                | Premium     | `suspiciousAPITraffic`               |
| Suspicious sending patterns                        | Offline                | Premium     | `suspiciousSendingPatterns`          |
| User reported suspicious activity                  | Offline                | Premium     | `userReportedSuspiciousActivity`     |

---
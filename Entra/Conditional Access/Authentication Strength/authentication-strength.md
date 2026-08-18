# Authentication Strength

|**Authentication method combination** | **MFA** | **Passwordless**| **Phishing-resistant MFA** |
|--------------------------------------|---------|-----------------|----------------------------|
| Passkey / FIDO2 Security Key         | ✅ | ✅ | ✅ |
| Windows Hello for Business | ✅ | ✅ | ✅ |
| Certificate-based authentication (Multi-Factor) | ✅ | ✅ | ✅ |
| Microsoft Authenticator (Phone Sign-in) | ✅ | ✅ |  |
| Temporary Access Pass | ✅ | ✅ |  |
| Password + something you have | ✅ |  |  |
| Federated Multi-Factor | ✅ |  |  |
| Certificate-based authentication (single-factor) | ❌ |  |  |
| SMS sign-in | ❌ |  |  |
| Password | ❌ |  |  |

**MFA** - the same set of combinations that could be used to satisfy the Require multifactor authentication setting.

**Passwordless MFA** - includes authentication methods that satisfy MFA but don't require a password.

**Phishing-resistant MFA** - includes methods that require an interaction between the authentication method and the sign-in surface (hardware-bound).

## Phishing-Resistant MFA (including TAP for onboarding)
**Phishing-Resistant MFA + TAP**
```
  Windows Hello For Business
  OR
  Passkeys (FIDO2)
  OR
  Certificate-based Authentication (Multifactor)
  OR
  Temporary Access Pass (One-time use)
```

## Passkeys Example
**Passkeys + TAP**
```
  Passkeys (FIDO2)
  Microsoft Authenticator (iOS)
  Microsoft Authenticator (Android)
  OR
  Temporary Access Pass (One-time use)
```

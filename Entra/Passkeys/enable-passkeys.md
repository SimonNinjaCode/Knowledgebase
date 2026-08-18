# Passkeys in Entra ID

Entra ID supports **device-bound passkeys** used for authentication. These are securely stored on user devices (computers and mobile) and currently available in **public preview**.

Passkeys are treated as an authentication method in Entra ID, alongside the FIDO Security Key. Microsoft's implementation uses the **Microsoft Authenticator App**.

- Google and Apple: Use **synced passkeys** (stored in device + cloud) → convenient but **less secure**
- Microsoft: Uses **local passkeys** (stored in hardware only) → **more secure**

---

## Why Use Passkeys?

- The private key is stored securely in hardware
- Convenient passwordless sign-in experience
- Biometrics or PIN protect the passkey
- Passkeys are phishing-resistant
- No sensitive information is sent to the cloud

---

## Requirements

- **OS Version**: Android 14+ or iOS 17+
- **Microsoft Authenticator App**:  
  - Android: 6.2404.2444+  
  - iOS: 6.8.7+
- [Existing Conditional Access Policy Considerations](#)

---

## Passkey Recommendations

- Migrate legacy policies (SSPR & MFA)
- Users should be enrolled in MFA (or use Temporary Access Pass)
- Enable **passkey (FIDO2)** authentication method

---

## Enable Passkeys in Entra ID

### Authentication Methods Policies

1. Sign in to the [Microsoft Entra admin center](https://entra.microsoft.com) as an **Authentication Policy Administrator**
2. Go to:  
   `Protection > Authentication methods > Authentication method policy`
3. Under **FIDO2 security key**:
   - Select **All users** or **Add groups** (security groups only)
4. Save the configuration
5. Set:
   - `Enforce Attestation` → `No`
   - `Enforce Key Restrictions` → `Yes`
   - `Restrict Specific Keys` → `Allow`
6. Add the following **AAGUIDs**:

```text
Authenticator for iOS:      90a3ccdf-635c-4729-a248-9b709135078f  
Authenticator for Android:  de1e552d-db1d-4423-a619-566b625cdc84
```
### List all registered FIDO2 Security Keys in Tenant

```
Install-Module Microsoft.Graph

Connect-MgGraph -Scope AuditLog.Read.All,UserAuthenticationMethod.Read.All

((Get-MgReportAuthenticationMethodUserRegistrationDetail `
  -Filter "methodsRegistered/any(i:i eq 'passKeyDeviceBound')" -All).Id |
    ForEach-Object {
        Get-MgUserAuthenticationFido2Method -UserId $_ -All
    }).AaGuid | Select-Object -Unique
```

---

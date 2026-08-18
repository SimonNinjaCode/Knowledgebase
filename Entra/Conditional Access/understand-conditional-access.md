# 🔐 Understanding CA in Entra ID

### 🧩 Understanding the Role of Conditional Access (CA)

- Conditional Access (CA) **performs authorization** by evaluating tokens from the authentication service.
- **CA policies do not block access until after authentication occurs.**

---

### 🚫 Limitations of Conditional Access

- **CA does not prevent password spray or credential stuffing attacks.**
- Instead, use **Entra ID Password Protection** and **Smart Lockout** to mitigate these threats.

---

### 🚨 What Happens When an Attacker is Blocked by CA?

- If CA blocks an attacker, **they either have valid credentials or a stolen token**.
- Failure to monitor and respond to CA blocks **gives attackers more time** with valid credentials.
- Use **Microsoft Identity Protection** to detect suspicious behavior — but note its limitations.

---

### 🔐 Multi-Factor Authentication (MFA) and CA

- **Initial Windows sign-in with a password** results in a **Primary Refresh Token (PRT)** without an MFA claim.
- When accessing apps that require MFA:
  - CA prompts for MFA
  - Updates the PRT
  - Applies the MFA claim to future requests

---

### 📶 Authentication Strengths in CA

- **Auth Strengths** allow CA to assess the strength of the authentication method.
- If the method doesn't meet policy, users must **reauthenticate using an approved method**.

---

###  ⏱️ Sign-In Frequency Policy

- **Sign-in frequency** checks the **token issuance timestamp** to determine if reauthentication is needed.

---

###  💻 Device Identity in CA

- When a device is **registered or joined**, it authenticates via certificate to Entra ID.
- The **device ID is embedded in the PRT**, allowing CA filtering by device.
- **Adversary-in-the-Middle (AiTM)** attacks can't spoof device ID — helping to block unauthorized access.

---

### 🌍 Location Awareness in CA

- **Trusted Named Locations** improve user experience via **Continuous Access Evaluation (CAE)** claims.
- CA can **revoke tokens** when risk conditions are detected (e.g., IP changes).
- Admins must **configure trusted locations** and enforce policies accordingly.

---

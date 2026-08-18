# Microsoft Intune

**Microsoft Intune** is Microsoft’s cloud-based endpoint management solution, enabling organizations to manage devices, apps, and compliance policies across platforms. It integrates deeply with Microsoft 365, Entra ID, Defender for Endpoint, and Purview to support Zero Trust principles and modern device lifecycle management.

---

## 🔧 Core Capabilities

| Area | Capabilities |
|------|--------------|
| **Device Management** | Enroll and manage Windows, macOS, iOS, and Android devices |
| **App Management** | Deploy, protect, and monitor corporate apps |
| **Compliance** | Define and enforce security baselines and compliance rules |
| **Conditional Access** | Restrict access based on device and user risk posture |
| **Integration** | Works natively with Microsoft 365 including Entra ID, Defender for Endpoint & Purview |

---

## 🎯 Key Use Cases

- Enforce **security baselines** across device platforms  
- Manage corporate devices and **BYOD** scenarios  
- Integrate with **Defender for Endpoint** to block non-compliant or unhealthy devices  
- Deploy **apps and updates** at scale  
- Configure **compliance policies** for secure access control  
- Leverage **remote actions** (wipe, lock, restart, reset passcode)  
- Use **Intune Reporting** and **Endpoint Analytics** to assess environment health

---

## 🔐 Policy Types

| Policy | Description |
|--------|-------------|
| **Configuration Profiles** | Manage settings like Wi-Fi, certificates, BitLocker, and more |
| **Compliance Policies** | Enforce security requirements (PIN, encryption, OS version, etc.) |
| **Security Baselines** | Microsoft-recommended security configurations for hardening endpoints |
| **App Protection Policies (MAM)** | Protect corporate data within apps without enrolling devices |
| **Windows Update Rings** | Control the rollout of Windows updates and features |

---

## 🚦 Conditional Access Integration

- Use device compliance state in **Entra ID Conditional Access**  
- Combine with Defender for Endpoint signals (risk-based access)  
- Require compliant devices for accessing Microsoft 365 services  
- Block access from jailbroken/rooted devices  
- Enforce encryption and secure login requirements

---

## 🛠️ Enrollment Options

| Platform | Enrollment Methods |
|----------|---------------------|
| **Windows** | Autopilot, Automatic, Manual |
| **macOS** | Company Portal, Apple Business Manager (ABM) |
| **iOS/iPadOS** | Company Portal, Apple School/Business Manager |
| **Android** | Android Enterprise (work profile, fully managed), Zero Touch, KME |

---

## 🔍 Monitoring & Troubleshooting

- **Intune Troubleshooting Blade**: Troubleshoot by user/device  
- **Endpoint Analytics**: Track boot times, app reliability, and proactive remediation  
- **Device Compliance Reports**: View per-device and per-policy results  
- **Audit Logs**: Track changes to policies, devices, and users  
- **Remote Actions**: Wipe, lock, restart, reset PIN/password, and locate

---

## 📘 Documentation & Resources

- [Microsoft Intune Documentation](https://learn.microsoft.com/en-us/mem/intune/)
- [Security Baselines](https://learn.microsoft.com/en-us/mem/intune/protect/security-baselines)
- [Endpoint Analytics](https://learn.microsoft.com/en-us/mem/analytics/)
- [Intune and Defender for Endpoint Integration](https://learn.microsoft.com/en-us/mem/intune/protect/windows-defender-integration)
- [Conditional Access Overview](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview)

---

## 🧾 Recommended Roles & Permissions

| Role | Scope |
|------|-------|
| **Intune Reader** | View-only access to Intune configurations |
| **Intune Administrator** | Full configuration and policy management |
| **Help Desk Operator** | Limited device/user support actions |
| **Entra ID Conditional Access Admin** | Manage Conditional Access policies |
| **Security Reader** | View security-related insights and posture |

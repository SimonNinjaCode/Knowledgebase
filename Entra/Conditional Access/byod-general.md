# BYOD - Questionnaire

## Strategic Decisions

| Question | Description |
|----------|-------------|
| Do we allow BYOD in our organization? | Consider whether your organization wants to permit personal devices to access corporate resources at all or if you're committed to a corporate-device-only approach. |
| For which personas will we allow BYOD access? | Identify which user groups (executives, knowledge workers, field staff, contractors, etc.) will be permitted to use personal devices for work. |
| What level of control do we need over BYOD devices and or different personas? | Determine if you need full management (MDM), application-level control (MAM), or minimal conditional access requirements. |
| What is our data protection strategy for BYOD? | Consider how corporate data will be protected on personal devices (encryption, containment, conditional access, etc.). |
| What is our overall risk tolerance for BYOD? | Assess how much risk your organization is willing to accept with BYOD against the productivity benefits. |

## 📝  Current Environment Assessment

| Question | Description |
|----------|-------------|
| What identity and access management solutions do you have? | Identify your current identity provider and licensing (Entra ID Premium P1/P2) which determines available Conditional Access capabilities. |
| What endpoint management solutions are deployed? | Determine if Microsoft Intune or other MDM/MAM solutions are already available for BYOD management. |
| What security monitoring tools are in place? | Assess if you have tools like Defender for Cloud Apps to monitor and control BYOD sessions. |

## 💻 Device Management Strategy

| Question | Description |
|----------|-------------|
| Which device platforms will you support for BYOD? | Decide which operating systems (iOS, Android, Windows, macOS, Linux) will be allowed, based on your ability to secure them. |
| Will you require device enrollment for BYOD? | Determine if personal devices must be enrolled in Intune (full MDM) or if app protection policies (MAM) are sufficient. |
| What compliance requirements will you enforce? | Define minimum standards for device health (encryption, passcode, OS version) before allowing access to resources. |

## 🔐 Authentication & Access Controls

| Question | Description |
|----------|-------------|
| What authentication methods will be required for BYOD? | Decide if standard MFA is sufficient or if phishing-resistant methods will be required for certain resources. |
| How will you handle risky sign-ins from BYOD devices? | Determine policy for medium/high-risk sign-ins (block, require stronger authentication, limit access). |
| What session controls will you implement for BYOD? | Define session timeout requirements (like the 9-hour BYOD persistence policy in reference templates). |

## 🧑🏻‍💻 Application Access Strategy

| Question | Description |
|----------|-------------|
| Which applications will be accessible via BYOD? | List applications that can be accessed from personal devices versus those that require corporate devices. |
| Will you require managed applications on BYOD? | Decide if users must use protected apps (Outlook, Edge, etc.) with app protection policies on personal devices. |
| How will you control data movement between work and personal apps? | Determine if you'll allow copy/paste between work and personal apps, sharing to personal locations, etc. |
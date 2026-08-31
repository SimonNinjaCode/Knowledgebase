---
layout:
  width: wide
---

# Ransomware Guidance

## Overview

Comprehensive guidance for protecting organizations from ransomware attacks through layered security measures, proper planning, and response strategies.

## Defensive Security Measures

### Protect Against Ransomware

Implement layers of cloud security features to protect your critical assets from ransomware attackers.

### Recovery Plan Overview

Develop a comprehensive Ransomware Attack Recovery Plan to guide response efforts when an attack occurs.

### Ransomware Playbooks

Follow established response procedures and Microsoft Incident Response Best Practices when dealing with ransomware incidents.

## Cyber Security Incident Process

Structure incident response with recommendations and best practices to help navigate those crucial initial hours after a breach is detected.

## Detailed Ransomware Guidance

### Establish a Ransomware Recovery Plan

Minimize the impact of a ransomware attack by making it difficult for attackers to succeed and ensure recovery without paying ransom.

* **Backups**: Verify that your customer has reliable offline and potentially online backups of critical data and systems. Ensure they are regularly tested and can be restored quickly.

* **Incident Response Plan**: If your customer doesn't have an existing plan, guide them to build one that covers ransomware scenarios, focusing on business continuity.

* **Recovery Process**: Work with the customer and vendors to determine a clear compromise recovery process, outlining steps for system restoration, data recovery, and service resumption.

### Limit the Impact of Ransomware Attacks

Focus on limiting the potential damage of ransomware attacks by restricting attacker access and strengthening the defensive capabilities in the environment.

* **Privileged Access Strategy**: Implement a strategy to mitigate privileged access compromise, a common ransomware attack vector. This includes enforcing session security, protecting identity systems, mitigating lateral traversal, and ensuring rapid threat response.

* **Endpoint Protection**: Implement robust endpoint security measures across all devices (Windows, Linux, macOS, Android, iOS, etc.). Apply attack surface reduction rules, tamper protection, and maintain updated software.

* **Email and Collaboration Security**: Strengthen email security using solutions like Microsoft Defender for Office 365. Implement Advanced Email Security features and deploy attack surface reduction rules to block common attack techniques.

* **Remote Access Security**: Secure remote access by configuring Microsoft Entra ID, enforcing Zero Trust principles, and utilizing secure VPN solutions like Azure Point-to-Site VPN.

* **Account Security**: Enforce strong, unique passwords, multi-factor authentication (MFA), or passwordless sign-in for all users, especially privileged accounts. Utilize tools like Microsoft Entra Password Protection.

* **Zero Trust Principle**: Encourage the adoption of a Zero Trust security model to minimize business risk.

### Make Ransomware Attacks Harder to Execute

Proactively identify & address vulnerabilities to prevent ransomware attacks.

* **Vulnerability Management**: Implement a system for patching vulnerabilities. Prioritize patching systems running outdated or unsupported software and prioritize critical security updates.

* **Security Audits**: Conduct regular security audits to identify and address misconfigurations, deviations from security baselines, and potential vulnerabilities.

* **Threat Detection and Response**: Implement tools like Microsoft Defender XDR to detect and respond to ransomware attacks. This includes monitoring for brute-force attempts, suspicious system changes, and attempts to disable security tools. Integrate outside experts like the Microsoft Detection and Response Team (DART) if necessary.

* **Data Protection**: Review data access permissions and implement the principle of least privilege. Reduce broad permissions for business-critical data.

* **Network Segmentation**: Use firewalls and network segmentation to contain potential breaches and restrict lateral movement within the network. Isolate critical systems and data from less secure parts of the network.

## General Recommendations

* **Collaboration**: Emphasize the importance of collaboration between internal teams and third-party vendors. Clear communication and shared responsibility are crucial for effective ransomware prevention and response.

* **Training and Awareness**: Conduct regular security awareness training for employees on identifying phishing emails, social engineering tactics, and best practices for password security.

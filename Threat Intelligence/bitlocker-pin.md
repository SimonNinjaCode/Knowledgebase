---
layout:
  width: wide
---

# Bypassing Windows Disk Encryption

## Bitlocker - Windows Disk Encryption Bypass

[Scenario:](https://www.youtube.com/watch?v=wTl4vEednkQ)
Physical Access to device + Open source software.

## Open source software:
- https://github.com/stacksmashing/pico-tpmsniffer
- https://github.com/denandz/lpc_sniffer_tpm

Windows 11 23H2 + CIS + MDM Security Baseline recommends allowing using PIN, neither baseline enforce it.

### Windows 11 23H2 Security Baseline
**Windows Components\BitLocker Drive Encryption\Operating System Drives**
- Allow enhanced PINs for startup > **Enabled**
- Configure minim PIN length for startup > *Not configured*
- Require additional authentication at startup > *Not configured*

Microsoft recommends utilizing Bitlocker with TPM and PIN protector on physical Secure Administrative Workstations.

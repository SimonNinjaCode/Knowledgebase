# Windows Defender

## Cloud-Delivered Protection / MAPS + Block at First Sight

### Block at First Sight Configuration
- **Cloud-delivered protection:** Enable
- **File Blocking Level:** High
- **Time extension for file scanning by the cloud:** 50
- **Prompt users before sample submission:** Send all data without prompting

## Security Features
- Tamper Protection (Intune)
- Ransomware Protection (OneDrive)
- Controlled Folder Access / ASR
- Credential Guard
- Exploit Guard
- Device Guard

## Actions for Detected Threats
| Threat Level | Action |
|--------------|--------|
| Low threat | Quarantine |
| Moderate Threat | Quarantine |
| High Threat | Block |
| Severe Threat | Block |

## Validation Commands
### Validate Defender (MAPS/Cloud Updates for definitions)
```powershell
"C:\Program Files\Windows Defender\mpcmdrun -validatemapsconnection"
```

## Reference Links

### Windows Hardening
[Windows Hardening GitHub Repository](https://github.com/0x6d69636b/windows_hardening)

### Enable Cloud Delivered Protection
[Microsoft Documentation: Enable Cloud Protection](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-defender-antivirus/enable-cloud-protection-windows-defender-antivirus)

### Utilize Cloud Protection
[Microsoft Documentation: Utilize Cloud Protection](https://docs.microsoft.com/en-us/windows/security/threat-protection/microsoft-defender-antivirus/utilize-microsoft-cloud-protection-microsoft-defender-antivirus)

### Validate Cloud Delivered Protection
[Microsoft Documentation: Configure Network Connections](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-defender-antivirus/configure-network-connections-windows-defender-antivirus)

### Active / Passive / Disabled Mode
[Microsoft Documentation: Antivirus Compatibility](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/microsoft-defender-antivirus-compatibility?view=o365-worldwide)

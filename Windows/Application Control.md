# Application Control

| **Capability** | **Windows Defender Application Control** | **AppLocker** |
|----------------|------------------------------------------|-------------|
| Development Release | Windows 10 (2015) | Windows 7 (2009) |
| Platform Support | Windows 10, 11, Windows Server 2016 and later | Windows 8 and later |
| Management | Intune Powershell | Intune (OMA-URI) Powershell |
| Reporting | Advanced Hunting (E5) | Local Event Log |
| Policy scope | Device-wide | Per-user + per-group rules |
| Mode | Kernel + user | User + services allow-listing |
| Enforceable file types | * Driver files: .sys<br>* Executable files: .exe and .com<br>* DLLs: .dll and .ocx<br>* Windows Installer files: .msi, .mst, and .msp<br>* Scripts: .ps1, .vbs, and .js<br>* Packaged apps and packaged app installers: .appx | * Executable files: .exe and .com<br>* [Optional] DLLs: .dll, .rll and .ocx<br>* Windows Installer files: .msi, .mst, and .msp<br>* Scripts: .ps1, .bat, .cmd, .vbs, and .js<br>* Packaged apps and packaged app installers: .appx |
| Path-based rules | Yes | Yes |
| Managed Installer (MI) | Allows Child processes of trusted Installer | No |
| Reputation | Intelligent Security Graph (ISG) | No |
| Application ID Tagging | 20H1+ | No |
| Activation Without Reboot | Yes, with Application Control CSP | Yes, with Group Policy or AppLocker CSP |
| Multiple Policies | Yes, base policies + supplemental policies | Yes, base policies + supplemental policies |

---

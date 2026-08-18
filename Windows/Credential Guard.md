# Credential Guard

## Requirements
* 64-bit CPU with support for Virtualization-based security
* Secure Boot
* Trusted Platform Module (TPM)
* UEFI-Lock (recommended)
* Windows Enterprise License (to support Virtualization based security features)

## Status Checking
```powershell
$CredentialguardStatus = (Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard)
$CredentialguardStatus.SecurityServicesConfigured
$CredentialguardStatus.SecurityServicesRunning
```

### Status Codes
| Code | Description |
|------|-------------|
| 0 | Windows Defender Credential Guard is disabled (not running) |
| 1 | Windows Defender Credential Guard is enabled (running) |
| 2 | Hypervisor enforced Code Integrity is enabled (running) |

## Registry Configuration

| Category | Registry Key | Enabled Value |
|----------|-------------|---------------|
| Virtualization Based Security | HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\DeviceGuard\EnableVirtualizationBasedSecurity | 1 (Enabled) |
| Security Feature | HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\DeviceGuard\RequirePlatformSecurityFeatures | 1 (SecureBoot)<br>3 (SecureBoot + DMA Protection) |
| Signed Boot Chain | HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\DeviceGuard\RequireMicrosoftSignedBootChain | 1 (Enabled) |
| UEFI-Lock | HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\DeviceGuard\Locked | 1 (Enabled) |
| Credential Guard | HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\LSA\LsaCfgFlags | 1 (Enabled) |

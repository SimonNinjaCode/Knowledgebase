# PKfail Vulnerability

A significant security issue in the UEFI ecosystem, affecting hundreds of device models due to untrusted Platform Keys (PK) used in Secure Boot.
 
## Supply Chain Security

The vulnerability stems from the use of test keys by Independent BIOS Vendors (IBVs) that were not replaced by OEMs, leading to devices shipping with untrusted keys.
 
## Impact

Binarly have discovered approx. 9% affected firmware on models from these vendors:
*Lenovo, Dell, HP, Supermicr, Intel, MSI, Gigabyte*

Exploiting PKfail allows attackers to run untrusted code during the boot process, even with Secure Boot enabled. Bypassing all operating system security measures local on the endpoint.
 
## Detection
 
### Intune - Custom Compliance

**Discovery Script:**
```powershell
$PKFailSecureBoot = [System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI PK).bytes) -match "DO NOT TRUST|DO NOT SHIP"
$jsondata = @{PKFailSecureBoot = $PKFailSecureBoot}
return $jsondata | ConvertTo-Json -Compress
```
 
**JSON Custom Compliance Settings:**
```json
{
    "Rules":[
        {
           "SettingName":"PKFailSecureBoot",
           "Operator":"IsEquals",
           "DataType":"Boolean",
           "Operand":"false",
           "MoreInfoUrl":"https://arstechnica.com/security/2024/07/secure-boot-is-completely-compromised-on-200-models-from-5-big-device-makers/",
           "RemediationStrings":[
              {
                 "Language":"en_US",
                 "Title":"SecureBoot (UEFI) is vulnerable.",
                 "Description": "Contact support for remediation."
              }
           ]
        }
     ]
}
```
 
### Local Powershell on Windows:
```powershell
[System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI PK).bytes) -match "DO NOT TRUST|DO NOT SHIP"
True
```
 
### Linux:
```bash
$ efi-readvar -v PK
Variable PK, length 862
PK: List 0, type X509
Signature 0, size 834, owner 26dc4851-195f-4ae1-9a19-fbf883bbb35e
Subject:
CN=DO NOT TRUST - AMI Test PK
Issuer:
CN=DO NOT TRUST - AMI Test PK
PK
```
 
### Binarly PKfail Detector:
https://pk.fail/

## Sources:
- https://www.binarly.io/blog/pkfail-untrusted-platform-keys-undermine-secure-boot-on-uefi-ecosystem
- Secure Boot is completely broken on 200+ models
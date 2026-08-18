# Side-Channel Attack FIDO2
### YubiKey 5 Series (Infineon's Cryptographic Library)

A vulnerability was discovered in Infineon's cryptographic library, which is utilized in YubiKey 5 Series, and Security Key Series with firmware prior to 5.7.0 and YubiHSM 2 with firmware prior to 2.4.0. The severity of the issue in Yubico devices is moderate.

## Vulnerability Details

* **Vulnerability Discovery**: New Security Research from Ninjalab.io reveals a side-channel vulnerability in the Infineon ECDSA implementation, affecting YubiKey 5 Series and other Infineon security microcontrollers. This vulnerability is due to a non-constant-time modular inversion.

* **Attack Method**: The attack requires physical access to the device and involves local electromagnetic side-channel acquisitions to extract the ECDSA secret key, allowing the creation of a clone of the FIDO device. Exploiting this vulnerability requires physical possession of the device, specialized equipment, and additional knowledge such as account details and PINs.

* **Affected Versions**: All YubiKey 5 Series with firmware versions below 5.7 and other Infineon security microcontrollers running the Infineon cryptographic library are vulnerable.

* **Mitigations**: Users can mitigate risks by using RSA or ed25519 signing keys, maintaining physical control of their devices, and promptly deregistering lost or stolen keys.

## Firmware Upgrade

Due to security reasons, the firmware of a YubiKey is immutable. It cannot be upgraded.

https://support.yubico.com/hc/en-us/articles/360013708760-YubiKey-Firmware-is-Not-Upgradable

## Yubico's Response

Yubico has removed the dependency on Infineon's library in newer devices and recommends continued use of FIDO authentication for its strong security.

## References

* Security Research: https://ninjalab.io/eucleak/
* Yubico Statement: [Security Advisory YSA-2024-03 | Yubico](https://www.yubico.com/support/security-advisories/ysa-2024-03/)
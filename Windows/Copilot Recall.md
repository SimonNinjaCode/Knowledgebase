# Recall

<!-- TOC tocDepth:2..3 chapterDepth:2..6 -->

- [Architecture](#architecture)
- [Recall Security Model](#recall-security-model)
- [Privacy Controls](#privacy-controls)
    - [Additional Privacy Features](#additional-privacy-features)

<!-- /TOC -->

* A new feature for Copilot+ PCs, designed to help users securely find what they've seen on their PC.
* Feature is opt-in by default. Can be turned off centrally using a configuration policy.
 
## Architecture
* **User Control**: Recall is opt-in, and users can remove it anytime.
* **Encryption**: All data is encrypted, with keys protected by TPM and VBS Enclave.
* **Isolation**: Services operate within a secure VBS Enclave.
* **User Authorization**: Uses Windows Hello for secure access and operations.
 
## Recall Security Model
* **VBS Enclaves**: Protect snapshots and data, ensuring only authorized access.
* **Zero Trust Principles**: Secure environment for sensitive operations.
* **Biometric Credentials**: Required for accessing Recall content.
 
## Privacy Controls
* **Local Storage**: Data is stored locally and not shared with Microsoft or third parties.
* **User Control**: Users can manage what gets saved, delete snapshots, and control retention.

### Additional Privacy Features
* In-private browsing in supported browsers is never saved.
* Users can filter out specific apps or websites viewed in supported browsers.
* Users can control how long Recall content is retained and how much disk space is allocated to snapshots.
* Sensitive content filtering is on by default and helps reduce passwords, national ID numbers and credit card numbers from being stored in Recall. Recall leverages the libraries that power Microsoft's Purview information protection product, which is deployed in enterprises globally.
 
[Recall Architecture](https://blogs.windows.com/windowsexperience/2024/09/27/update-on-recall-security-and-privacy-architecture/)

---

# Security Settings Integration
## Defender Security Settings Integration for Servers (MDE / Intune)

* Devices without an Intune presence enable the security settings management feature.
* For devices that aren't fully Microsoft Entra registered, a synthetic device identity is created in Microsoft Entra ID that allows the device to retrieve policies. Fully registered devices use their current registration.
* Policies retrieved from Microsoft Intune are enforced on the device by Microsoft Defender for Endpoint.
 
[Learn more about MDE security integration](https://learn.microsoft.com/en-us/mem/intune/protect/mde-security-integration)

## How It Works

* Devices onboard to Microsoft Defender for Endpoint.
* Devices communicate with Intune. This communication enables Microsoft Intune to distribute policies that are targeted to the devices when they check in.
* A registration is established for each device in Microsoft Entra ID:
   1. If a device was previously fully registered, like a Hybrid Join device, the existing registration is used.
   2. For devices that haven't been registered, a synthetic device identity is created in Microsoft Entra ID to enable the device to retrieve policies. When a device with a synthetic registration has a full Microsoft Entra registration created for it, the synthetic registration is removed and the devices management continues on uninterrupted by using the full registration.
* Defender for Endpoint reports the status of the policy back to Microsoft Intune.
 
## Configuration

### Defender Settings
Navigate to Defender > Settings > Configuration Management > Enforcement Scope

#### Security setting management
Allow security setting in Intune to be enforced by Microsoft Defender for Endpoint (MDE).
This configuration setting will apply to devices that are not yet enrolled to Intune.

You'll need to turn on the integration in Microsoft Defender for Endpoint connector settings under Intune.
For more information and pre-requisites, see [security settings management for Microsoft Defender for Endpoint](https://learn.microsoft.com/en-us/mem/intune/protect/mde-security-integration).

### Use MDE to enforce security configuration settings from Intune
- [x] On

#### Enable configuration management

Choose which OS platforms to apply the settings on, then select which set of devices to implement it on. To test the feature on a specific set of devices, tag them with `MDE-Management`

- [x] Windows Client devices
  - (•) On all devices
  - ( ) On tagged devices

- [x] Windows Server devices
  - (•) On all devices
  - ( ) On tagged devices

#### Security settings management for Microsoft Defender for Cloud onboarded devices.
- [x] On

### Intune Configuration
Navigate to Intune > Endpoint Security > Microsoft Defender for Endpoint

**Connection status**: Enabled  

#### Endpoint Security Profile Settings

Allow Microsoft Defender for Endpoint to enforce Endpoint Security Configurations
- [ ] Off
- [x] On

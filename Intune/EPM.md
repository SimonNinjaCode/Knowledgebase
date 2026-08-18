# Endpoint Privilege Management

## Requirements
- Microsoft Entra joined or Microsoft Entra hybrid joined
- Microsoft Intune Enrollment
- Supported Operating Systems:
  - Windows 11, version 22H2 (22621.1344 or later) with KB5022913
  - Windows 11, version 21H2 (22000.1761 or later) with KB5023774
  - Windows 10, version 22H2 (19045.2788 or later) with KB5023773
  - Windows 10, version 21H2 (19044.2788 or later) with KB5023773
  - Windows 10, version 20H2 (19042.2788 or later) with KB5023773 
- Clear line of sight (without SSL-Inspection) to the required endpoints

## Permission Requirements
Endpoint Privilege Management Policy Authoring:
- View Reports
- Read
- Create
- Update
- Delete
- Assign

## RBAC

| Role | Required Permissions |
|------|---------------------|
| Endpoint Administrator | ✅ |
| Endpoint Privilege Reader | - View Reports<br/>- Read |
| Endpoint Security Manager | - View Reports<br/>- Read<br/>- Create<br/>- Update<br/>- Delete<br/>- Assign |
| Read Only Operator | - View Reports<br/>- Read<br/>- Create<br/>- Update<br/>- Delete<br/>- Assign |

## EPM Settings & Concepts

| Setting | Concept |
|---------|---------|
| Elevation settings policy | Activates EPM on the client device. |
| Elevation rule policies | Links an application or task to an elevation action. Use this policy to configure the elevation behavior for applications your organization allows when the applications run on the device. |
| Run with elevated access | A right-click context menu option that appears when EPM is activated on a device. When this option is used, the devices elevation rules policies are checked for a match to determine if, and how, that file can be elevated to run in an administrative context. If there's no applicable elevation rule, then the device uses the default elevation configurations as defined by the elevation settings policy. |
| File elevation and elevation types | EPM allows users without administrative privileges to run processes in the administrative context. When you create an elevation rule, that rule allows EPM to proxy the target of that rule to run with administrator privileges on the device. The result is that the application has full administrative capability on the device.<br/><br/>- For automatic elevation rules, EPM automatically elevates these applications without input from the user. Broad rules in this category can have widespread impact to the security posture of the organization.<br/><br/>- For user confirmed rules, end users use a new right-click context menu Run with elevated access. User confirmed rules require the end-user to complete some additional requirements before the application is allowed to elevate. These requirements provide an extra layer of protection by making the user acknowledge that the app will run in an elevated context, before that elevation occurs. |
| Child process controls | When processes are elevated by EPM, you can control how the creation of child processes is governed by EPM. This allows you to have granular control over any subprocesses that may be created by your elevated application. |
| Client-side components | Intune provisions a small set of components on the device that receive elevation policies and enforces them. The components are provisioned only when an elevation settings policy is received, and the policy has expressed the intent to enable Endpoint Privilege management. |
| Disabling and deprovisioning | Once the device has received an elevation settings policy requiring EPM to be disabled, Intune immediately disables the client-side components. EPM will remove the EPM component after a period of seven days. The delay is to ensure temporary or accidental changes in policy or assignments don't result in mass de-provisioning/re-provisioning events that might have a substantial impact on business operations. |
| Managed elevation | Any elevation that Endpoint Privilege Management facilitates. Managed elevations include all elevations that EPM ends up facilitating for the standard user. This could include elevations that happen as the result of an elevation rule or as part of default elevation action. |
| Unmanaged elevation | All file elevations that happen without use of Endpoint Privilege Management. These elevations can happen when a user with administrative rights uses the Windows default action of Run as administrator. |

## Commands

### Get-FileHash
```powershell
Get-FileHash -path C:\Windows\System32\cmd.exe
Get-FileHash -path C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe
```

### Get-FileAttributes
```powershell
Import-Module 'C:\Program Files\Microsoft EPM Agent\EpmTools\EpmCmdlets.dll'
Get-FileAttributes -Filepath C:\Windows\System32\cmd.exe
```

## EPM PowerShell Module

| Command | Description |
|---------|-------------|
| Get-Policies | Retrieves a list of all policies received by the Epm Agent for a given PolicyType (ElevationRules, ClientSettings). |
| Get-DeclaredConfiguration | Retrieves a list of WinDC documents that identify the policies targeted to the device. |
| Get-DeclaredConfigurationAnalysis | Retrieves a list of WinDC documents of type MSFTPolicies and checks if the policy is already present in Epm Agent (Processed column). |
| Get-ElevationRules | Query the EpmAgent lookup functionality and retrieves rules given lookup and target. Lookup is supported for FileName and CertificatePayload. |
| Get-ClientSettings | Process all existing client settings policies to display the effective client settings used by the EPM Agent. |
| Get-FileAttributes | Retrieves File Attributes for a .exe file and extracts its Publisher and CA certificates to a set location that can be used to populate Elevation Rule Properties for a particular application |

## Reporting

### Elevation Setting
- Send elevation data for reporting > Yes
- Reporting scope > Diagnostic data and all endpoint elevations

### Reporting Data (24hrs)
- Elevation report
- Managed elevations report
- Elevation report by applications

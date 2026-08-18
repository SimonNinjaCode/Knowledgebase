# MDM and Intune Management Extension Diagnostics Guide

## MDM Diagnostics Commands
```powershell
MDMdiagnosticstool.exe -area Autopilot -cab C:\Temp\autopilot.cab
MDMdiagnosticstool.exe -area Deviceenrollment -cab C:\Temp\deviceenrollment.cab
```

## Win32App

### Registry Locations
- Information on the parameters for the IME can be found in the registry:
  ```
  HKLM:\Software\Microsoft\EnterpriseDesktopAppManagement<SID>\MSI<ProductCode>
  ```
- Win32Apps registry:
  ```
  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\IntuneManagementExtension\Win32Apps
  ```
- ADMX Templates registry:
  ```
  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\AdmxInstalled\
  ```

### Important File Locations
- Content:
  ```
  C:\Program Files (x86)\Microsoft Intune Management Extension\Content\Incoming
  ```
- MSI + Installer Log:
  ```
  C:\Windows\System32\config\systemprofile\AppData\Local\mdm
  ```
- IME Logs:
  ```
  C:\ProgramData\Microsoft\IntuneManagementExtension\Logs
  ```
- Content Cache:
  ```
  C:\Windows\IMECache
  ```

### PSADT - Default Logs Location
The default log directory for the toolkit and MSI log files can be specified in the XML configuration file.
The default directory is `C:\Windows\Logs\Software`

## Troubleshooting Resources

- [Intune Management Extension not installing](https://techcommunity.microsoft.com/t5/Microsoft-Intune/Intune-Management-Extension-not-installing/td-p/142443)
- [Intune Management Extension documentation](https://docs.microsoft.com/en-us/intune/intune-management-extension)

### Deep Dive
[Part 2: Deep Dive Microsoft Intune Management Extension & PowerShell Scripts](https://oliverkieselbach.com/2018/02/12/part-2-deep-dive-microsoft-intune-management-extension-powershell-scripts/#enterprisedesktopappmanagement-csp)

## Diagnostic Report
A diagnostic report can be generated client-side from:
`Settings > Access Work and School > Connected to Tenant's Entra ID > Info > Create Report`

The report will be saved to:

C:\Users\Public\Public Documents\MDMDiagnostics\MDMDiagReport.html


## Intune Management Extension Details

Information on the parameters for the IME can be found in the registry:

HKLM:\Software\Microsoft\EnterpriseDesktopAppManagement<SID>\MSI<ProductCode>


The MSI itself can be found here, together with an installer log:

C:\Windows\System32\config\systemprofile\AppData\Local\mdm


IME logs can be found here:

C:\ProgramData\Microsoft\IntuneManagementExtension\Logs


### Key Log Files
- AgentExecutor
- ClientHealth
- IntuneManagementExtension

Additional resource: [Develop and deliver a working Win32 app via Intune](https://docs.microsoft.com/en-us/troubleshoot/mem/intune/develop-deliver-working-win32-app-via-intune)

## Script Execution
When a PowerShell script is run on the client from Intune, the scripts and the script output will be stored in these locations (but only until execution is complete):
```
C:\Program files (x86)\Microsoft Intune Management Extension\Policies\Scripts
C:\Program files (x86)\Microsoft Intune Management Extension\Policies\Results
```

A transcript of the script execution can be found under `C:\_showmewindows` (a hidden folder).

The full content of the script will also be logged in the IntuneManagementExtension.log (be careful of sensitive data in scripts!)

The error code and result output of the script can also be found in the registry:
```
HKLM:\Software\Microsoft\IntuneManagementExtension\Policies<UserGUID><ScriptGUID>
```

## Event Logs
There are MDM event logs which can be found here:
```
Applications and Services Logs > Microsoft > Windows > DeviceManagement-Enterprise-Diagnostics-Provider
```

## Services
The IME runs as a service called "Microsoft Intune Management Extension". You can restart this to force a check for new policies.

## Scheduled Task
The IME runs a health evaluation every day as a scheduled task, and logs the results in the ClientHealth.log.

## Log Collection Information
No personal information is collected. This list below is the same order as the diagnostic zip. Each collection contains the following data:

### Registry Keys
```
HKLM\Software\Microsoft\IntuneManagementExtension
HKLM\SOFTWARE\Microsoft\SystemCertificates\AuthRoot
HKLM\SOFTWARE\Microsoft\Windows Endpoint
HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI
HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings
HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall
HKLM\Software\Policies
HKLM\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL
HKLM\SOFTWARE\Policies\Microsoft\Windows Endpoint
HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall
HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL
```

### Commands
```
%programfiles%\windows defender\mpcmdrun.exe -GetFiles
%windir%\system32\certutil.exe -store
%windir%\system32\certutil.exe -store -user my
%windir%\system32\Dsregcmd.exe /status
%windir%\system32\ipconfig.exe /all
%windir%\system32\mdmdiagnosticstool.exe
%windir%\system32\msinfo32.exe /report %temp%\MDMDiagnostics\msinfo32.log
%windir%\system32\netsh.exe advfirewall show allprofiles
%windir%\system32\netsh.exe advfirewall show global
%windir%\system32\netsh.exe lan show profiles
%windir%\system32\netsh.exe winhttp show proxy
%windir%\system32\netsh.exe wlan show profiles
%windir%\system32\netsh.exe wlan show wlanreport
%windir%\system32\ping.exe -n 50 localhost
%windir%\system32\powercfg.exe /batteryreport /output %temp%\MDMDiagnostics\battery-report.html
%windir%\system32\powercfg.exe /energy /output %temp%\MDMDiagnostics\energy-report.html
```

### Event Viewers
```
Application
Microsoft-Windows-AppLocker/EXE and DLL
Microsoft-Windows-AppLocker/MSI and Script
Microsoft-Windows-AppLocker/Packaged app-Deployment
Microsoft-Windows-AppLocker/Packaged app-Execution
Microsoft-Windows-Bitlocker/Bitlocker Management
Microsoft-Windows-HelloForBusiness/Operational
Microsoft-Windows-SENSE/Operational
Microsoft-Windows-SenseIR/Operational
Setup
System
```

### Files
```
%ProgramData%\Microsoft\DiagnosticLogCSP\Collectors.etl
%ProgramData%\Microsoft\IntuneManagementExtension\Logs
%ProgramData%\Microsoft\Windows Defender\Support\MpSupportFiles.cab
%ProgramData%\Microsoft\Windows\WlanReport\wlan-report-latest.html
%temp%\MDMDiagnostics\battery-report.html
%temp%\MDMDiagnostics\energy-report.html
%temp%\MDMDiagnostics\mdmlogs-<Date/Time>.cab
%temp%\MDMDiagnostics\msinfo32.log
%windir%\ccm\logs.log
%windir%\ccmsetup\logs.log
%windir%\logs\CBS\cbs.log
%windir%\logs\measuredboot
%windir%\Logs\WindowsUpdate.etl
```
---

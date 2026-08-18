# Install and import the necessary modules
Install-Module Microsoft.Graph -Force
Import-Module Microsoft.Graph.Reports -Force

# Connect to Microsoft Graph with the necessary scopes
Connect-MgGraph -Scope AuditLog.Read.All,UserAuthenticationMethod.Read.All

# Execute the command to get FIDO2 security keys
((Get-MgReportAuthenticationMethodUserRegistrationDetail -Filter "methodsRegistered/any(i:i eq 'passKeyDeviceBound')" -All).Id | ForEach-Object {Get-MgUserAuthenticationFido2Method -UserId $_ -All }).AaGuid | Select-Object -Unique

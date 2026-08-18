# First, ensure TLS 1.2 for PowerShell gallery access.
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

# Install the Azure AD Kerberos PowerShell Module.
Install-Module -Name AzureADHybridAuthenticationManagement -AllowClobber
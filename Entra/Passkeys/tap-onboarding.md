# TAP Onboarding

Temporary Access Pass is a time-limited passcode that serves as strong credentials and allow onboarding of Passwordless credentials.

The most common scenario is to use the temporary access pass for a new user to be able to provision their Passwordless Method (FIDO2, Passwordless Phone Sign-In using Authenticator without needing to enter their password in Azure AD (during first sign-in or device setup). Registration and update of methods for the end users is done here:
https://aka.ms/mysecurityinfo
 
Existing users can be migrated with the registration campaign (from SMS/Voice to Authenticator)
https://learn.microsoft.com/en-us/azure/active-directory/authentication/how-to-mfa-registration-campaign
 
## Steps Overview

* Configure Temporary Access Pass Policy in the GUI *(Global Administrator)*
* Create a Temporary Access Pass *(Global Administrator, Privileged Authentication Administrator or Authentication Administrator)*
   * Using the Azure Portal
   * Using Graph API
* Use a Temporary Access Pass
 
## Configure Temporary Access Pass Policy in the GUI
 
1. Sign in to the Azure portal using an account with global administrator permissions.
2. Search for and select Azure Active Directory, then choose Security from the menu on the left-hand side.
3. Under the Manage menu header, select Authentication methods > Policies.
4. From the list of available authentication methods, select Temporary Access Pass.
5. Set the Enable to Yes to enable the policy. Then select the Target users.

## Optional Settings

Optionally configure the settings of the Temporary Access Pass:

| Setting | Default values | Allowed values | Comments |
|---------|---------------|----------------|----------|
| Minimum lifetime | 1 hour | 10 – 43,200 Minutes (30 days) | Minimum number of minutes that the Temporary Access Pass is valid. |
| Maximum lifetime | 8 hours | 10 – 43,200 Minutes (30 days) | Maximum number of minutes that the Temporary Access Pass is valid. |
| Default lifetime | 1 hour | 10 – 43,200 Minutes (30 days) | Default values can be overridden by the individual passes, within the minimum and maximum lifetime configured by the policy. |
| One-time use | False | True / False | When the policy is set to false, passes in the tenant can be used either once or more than once during its validity (maximum lifetime). By enforcing one-time use in the Temporary Access Pass policy, all passes created in the tenant will be created as one-time use. |
| Length | 8 | 8-48 characters | Defines the length of the passcode. |
 
## Permissions
 
| Role | Permissions |
|------|-------------|
| Global Administrator | Create, delete, and view a Temporary Access Pass on any user (except themselves) |
| Privileged Authentication Administrators | Create, delete, and view a Temporary Access Pass on admins and members (except themselves) |
| Authentication Administrators | Create, delete, and view a Temporary Access Pass on members (except themselves) |
| Global Reader | View the Temporary Access Pass details on the user (without reading the code itself). |
 
## Create a Temporary Access Pass using Graph API
 
```powershell
# Install module
Install-module Microsoft.Graph.Identity.Signins -Scope CurrentUser

# Connect to Microsoft Graph API using Device Authentication and with correct API permissions
Connect-MgGraph -Scopes UserAuthenticationMethod.ReadWrite.All

# Switch to beta API
Select-MgProfile -Name beta

# Specify User ID (Object ID in Entra ID on the User Object)
$UserID = "..."

# Show TAP for Specific User
Get-MgUserAuthenticationTemporaryAccessPassMethod -UserID $UserID

# Create a TAP (one-time use), valid for 30 minutes
$TAP = New-MgUserAuthenticationTemporaryAccessPassMethod -UserID $UserID -IsUsableOnce -LifetimeInMinutes 30

# View the newly created TAP
$TAP.TemporaryAccessPass
```

## Use a Temporary Access Pass

When the end user has access to their temporary access pass, they can authenticate without a password and add their preferred passwordless authentication method (Security Key or Microsoft Authenticator App)

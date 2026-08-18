# Install Microsoft.Graph.Identity.SignIns if it's not already installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Identity.SignIns)) {
    Install-Module Microsoft.Graph.Identity.SignIns -Scope CurrentUser -Verbose
}

# Install Microsoft.Graph.Users.Actions if it's not already installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Users.Actions)) {
    Install-Module Microsoft.Graph.Users.Actions -Scope CurrentUser -Verbose
}

# Connect to Microsoft Graph using interactive login
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Get the user you want to revoke sessions for (replace with the actual user principal name)
$user = Get-MgUser -Filter "userPrincipalName eq 'testuser@evergr33ndev.onmicrosoft.com'"

# Revoke all sign-in sessions for the user
Revoke-MgUserSignInSession -UserId $user.Id -Verbose
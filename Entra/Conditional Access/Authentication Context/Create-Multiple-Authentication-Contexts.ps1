<#
.DESCRIPTION
Uses Microsoft Graph to create multiple Authentication Contexts in Entra ID.
The contexts are named "Compliant device", "Entra hybrid joined device", and "Reauthentication".
#>

# Check if Microsoft.Graph.Identity.SignIns module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Beta.Identity.SignIns)) {
    # Install the Microsoft.Graph.Identity.SignIns module if not installed
    Install-Module Microsoft.Graph.Beta.Identity.SignIns -Scope CurrentUser -Verbose
} else {
    # Output a message if the module is already installed
    Write-Output "Microsoft.Graph.Beta.Identity.SignIns module is already installed."
}

# Check if Microsoft.Graph.Authentication module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication)) {
    # Install the Microsoft.Graph.Authentication module if not installed
    Install-Module Microsoft.Graph.Authentication -Scope CurrentUser -Verbose
} else {
    # Output a message if the module is already installed
    Write-Output "Microsoft.Graph.Authentication module is already installed."
}

# Connect to MS Graph with the specified scope for authentication context creation
Connect-MgGraph -Scopes "AuthenticationContext.ReadWrite.All"	

# Create Authentication Context - Compliant device
$compliant = @{
	id = "c60"
	displayName = "Compliant device"
	description = "Require compliant device"
	isAvailable = $true
}

# Create a new Authentication Context in Entra ID
New-MgBetaIdentityConditionalAccessAuthenticationContextClassReference -BodyParameter $compliant

# Create Authentication Context - Entra hybrid joined device
$hybrid = @{
	id = "c61"
	displayName = "Entra hybrid joined device"
	description = "Require Entra hybrid joined device"
	isAvailable = $true
}

# Create a new Authentication Context in Entra ID
New-MgBetaIdentityConditionalAccessAuthenticationContextClassReference -BodyParameter $hybrid

# Create Authentication Context - Reauthentication
$reauthentication = @{
	id = "c62"
	displayName = "Reauthentication"
	description = "Sign-in frequency - Every time"
	isAvailable = $true
}

# Create a new Authentication Context in Entra ID
New-MgBetaIdentityConditionalAccessAuthenticationContextClassReference -BodyParameter $reauthentication
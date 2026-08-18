<#
.DESCRIPTION
Use Microsoft Graph to create a new Authentication Context in Entra ID.
This context is named "Require Phishing-Resistant MFA (Context)", it will be published to apps and has the ID "c66".
Note: the Microsoft.Graph.Beta.Identity.SignIns and Microsoft.Graph.Authentication modules are required for this script.
https://learn.microsoft.com/en-us/graph/api/conditionalaccessroot-post-authenticationcontextclassreferences?view=graph-rest-beta&tabs=powershell
#>

# Check if Microsoft.Graph.Beta.Identity.SignIns module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Beta.Identity.SignIns)) {
    # Install the Microsoft.Graph.Beta.Identity.SignIns module if not installed
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

# Define the parameters for the new Authentication Context
$params = @{
	id = "c66"
	displayName = "Require Phishing-Resistant MFA (Context)"
	description = "Require Phishing-Resistant MFA"
	isAvailable = $true
}

# Create a new Authentication Context in Entra ID
New-MgBetaIdentityConditionalAccessAuthenticationContextClassReference -BodyParameter $params
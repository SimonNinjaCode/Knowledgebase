<#
.DESCRIPTION
Use Microsoft Graph to create a new Authentication Strength Policy in Entra ID.
Strength includes WHfB, Passkeys incl. FIDO2 & Temporary Access Pass (one-time use).
https://learn.microsoft.com/en-us/graph/api/resources/authenticationstrengths-overview?view=graph-rest-1.0
#>

# Check if Microsoft.Graph.Identity.SignIns module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Identity.SignIns)) {
    # Install the Microsoft.Graph.Identity.SignIns module if not installed
    Install-Module Microsoft.Graph.Identity.SignIns -Scope CurrentUser -Verbose
} else {
    # Output a message if the module is already installed
    Write-Output "Microsoft.Graph.Identity.SignIns module is already installed."
}

# Check if Microsoft.Graph.Authentication module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication)) {
    # Install the Microsoft.Graph.Authentication module if not installed
    Install-Module Microsoft.Graph.Authentication -Scope CurrentUser -Verbose
} else {
    # Output a message if the module is already installed
    Write-Output "Microsoft.Graph.Authentication module is already installed."
}

# Connect to MS Graph with the specified scope for authentication method policies
Connect-MgGraph -Scopes "Policy.ReadWrite.AuthenticationMethod"

$params = @{
	displayName = "Phishing-Resistant MFA + TAP"
    description = "WHfB, Passkeys incl. FIDO2 & Temporary Access Pass"
	requirementsSatisfied = "mfa"
	allowedCombinations = @(
	"windowsHelloForBusiness",
    "fido2",
    "temporaryAccessPassOneTime"
)
}

New-MgPolicyAuthenticationStrengthPolicy -BodyParameter $params
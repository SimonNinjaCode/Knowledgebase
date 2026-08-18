# Ænima Evergr33nDev.onmicrosoft.com
# Managed Identity Name: "Security-Automation-Account"
# AppID: "d10dbd45-03b7-4e1f-9feb-72d85a39d3e7"

$ManagedIdentityName = "Security-Automation-Account"

$Permissions = @(
    'SecurityEvents.Read.All',
    'ThreatHunting.Read.All'
)

# Install and import the necessary modules
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication)) {
    Write-Output "Microsoft.Graph.Authentication module not found. Installing..."
    Install-Module -Name Microsoft.Graph.Authentication -Force -AllowClobber
} else {
    Write-Output "Microsoft.Graph.Authentication module is already installed."
}

Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Applications

# Connect to Microsoft Graph with the necessary scopes
Connect-MgGraph -Scopes "Application.Read.All","AppRoleAssignment.ReadWrite.All","RoleManagement.ReadWrite.Directory"

# Get the Managed Identity Service Principal
$IdentityServicePrincipal = Get-MgServicePrincipal -Filter "displayName eq '$ManagedIdentityName'"
if (-not $IdentityServicePrincipal) {
    Write-Error "Managed Identity '$ManagedIdentityName' not found."
}

# Get the Microsoft Graph Service Principal
$GraphServicePrincipal = Get-MgServicePrincipal -Filter "appId eq '00000003-0000-0000-c000-000000000000'"
if (-not $GraphServicePrincipal) {
    Write-Error "Microsoft Graph Service Principal not found."

}

# Verify Selection if SP and ID
"Selected Service Principal Name: $($IdentityServicePrincipal.DisplayName)"
"Service Principal ID: $($IdentityServicePrincipal.Id)"

# Add app role assignments
foreach ($Permission in $Permissions) {
    $AppRole = $GraphServicePrincipal.AppRoles | Where-Object { $_.Value -eq $Permission -and $_.AllowedMemberTypes -contains "Application" }
    if ($AppRole) {
        $AppRoleAssignment = @{
            principalId = $IdentityServicePrincipal.Id
            resourceId = $GraphServicePrincipal.Id
            appRoleId = $AppRole.Id
        } | ConvertTo-Json
        try {
            Write-Output "Assigning permission '$($Permission)' to managed identity '$($ManagedIdentityName)'..."
            $response = Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/servicePrincipals/$($IdentityServicePrincipal.Id)/appRoleAssignments" -Body $AppRoleAssignment -ErrorAction Stop
            Write-Output "Assigned permission '$($Permission)' to managed identity '$($ManagedIdentityName)'."
        } catch {
            Write-Error "Failed to assign permission '$($Permission)' to managed identity '$($ManagedIdentityName)': $_"
            Write-Output "Response: $($response | ConvertTo-Json -Depth 10)"
        }
    } else {
        Write-Output "Permission '$($Permission)' not found in Microsoft Graph Service Principal."
    }
}


# Disconnect from Microsoft Graph
Disconnect-MgGraph
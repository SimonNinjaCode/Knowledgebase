# This script assigns permissions to a Managed Identity in Microsoft Graph.
# It requires the Microsoft.Graph module and the necessary permissions to perform the operations.
$ManagedIdentityName = "DefenderXDR-Automation"

$Permissions = @(
    'User.ReadWrite.All',
    'SecurityEvents.Read.All',
    'SecurityIncident.Read.All'
)

# Install and import the necessary modules
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Write-Output "Microsoft.Graph module not found. Installing..."
    Install-Module -Name Microsoft.Graph -Force -AllowClobber
} else {
    Write-Output "Microsoft.Graph module is already installed."
}

Import-Module Microsoft.Graph
Import-Module Microsoft.Graph.Applications 

# Connect to Microsoft Graph with the necessary scopes
Connect-MgGraph -Scopes "Application.Read.All","AppRoleAssignment.ReadWrite.All,RoleManagement.ReadWrite.Directory"

# Get the Managed Identity Service Principal
$IdentityServicePrincipal = Get-MgServicePrincipal -Filter "displayName eq '$ManagedIdentityName'"
if (-not $IdentityServicePrincipal) {
    Write-Error "Managed Identity '$ManagedIdentityName' not found."
    Disconnect-MgGraph
    exit
}

# Get the Microsoft Graph Service Principal
$GraphServicePrincipal = Get-MgServicePrincipal -Filter "appId eq '00000003-0000-0000-c000-000000000000'"
if (-not $GraphServicePrincipal) {
    Write-Error "Microsoft Graph Service Principal not found."
    Disconnect-MgGraph
    exit
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
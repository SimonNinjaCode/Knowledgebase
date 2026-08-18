
# Get all Device Configuration IDs
https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations?$select=id,displayName

# For Each ID get all  Assignments based on ID
https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/[ID]/assignments

# App Protection / App Configuration policies (based on apps)
https://graph.microsoft.com/beta/deviceAppManagement/managedAppPolicies

# Get all Managed Device App Configuration policies
https://graph.microsoft.com/beta/deviceAppManagement/mobileAppConfigurations?`$select=id,displayName

# Get all Intune Roles
https://graph.microsoft.com/beta/roleManagement/deviceManagement/roleDefinitions?$select=id,displayName,isBuiltIn

# Get all Intune Role Assignments
https://graph.microsoft.com/beta/deviceManagement/roleDefinitions('[id]')?$expand=roleassignments

# Compliance Policies
/deviceManagement/deviceCompliancePolicies?$select=id,displayName

# Feature Update Rings
/deviceManagement/windowsFeatureUpdateProfiles?$select=id,displayName

# Settings Catalog
/deviceManagement/configurationPolicies?$select=id,name

# Endpoint Security / Security Baseline
/deviceManagement/intents

# Scripts
/deviceManagement/deviceManagementScripts?$select=id,displayName

# Proactive Remediations
/deviceHealthScripts?$select=id,displayName

# Autopilot Profiles
/deviceManagement/windowsAutopilotDeploymentProfiles?$select=id,displayName
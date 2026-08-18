# Connect and change schema 
Connect-MSGraph -ForceInteractive
Update-MSGraphEnvironment -SchemaVersion beta
Connect-MSGraph
 
# Which AAD group do we want to check against
$groupName = "EvergreenDev-Dynamic Devices IT"
 
#$Groups = Get-AADGroup | Get-MSGraphAllPages
$Group = Get-AADGroup -Filter "displayname eq '$GroupName'"
Write-host "AAD Group Name: $($Group.displayName)" -ForegroundColor Green
Write-host "AAD Group ID: $($Group.id)" -ForegroundColor Green
 
# Apps
$AllAssignedApps = Get-IntuneMobileApp -Filter "isAssigned eq true" -Select id, displayName, lastModifiedDateTime, assignments -Expand assignments | Where-Object {$_.assignments -match $Group.id}
Write-host "Number of Apps found: $($AllAssignedApps.DisplayName.Count)" -ForegroundColor cyan
Foreach ($Config in $AllAssignedApps) {
Write-host $Config.displayName -ForegroundColor Yellow
}
 
# Device Compliance
$AllDeviceCompliance = Get-IntuneDeviceCompliancePolicy -Select id, displayName, lastModifiedDateTime, assignments -Expand assignments | Where-Object {$_.assignments -match $Group.id}
Write-host "Number of Device Compliance policies found: $($AllDeviceCompliance.DisplayName.Count)" -ForegroundColor cyan
Foreach ($Config in $AllDeviceCompliance) {
Write-host $Config.displayName -ForegroundColor Yellow
}
 
# Device Configuration
$AllDeviceConfig = Get-IntuneDeviceConfigurationPolicy -Select id, displayName, lastModifiedDateTime, assignments -Expand assignments | Where-Object {$_.assignments -match $Group.id}
Write-host "Number of Device Configurations found: $($AllDeviceConfig.DisplayName.Count)" -ForegroundColor cyan
Foreach ($Config in $AllDeviceConfig) {
Write-host $Config.displayName -ForegroundColor Yellow
}
 
# Device Configuration Powershell Scripts 
$Resource = "deviceManagement/deviceManagementScripts"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)?`$expand=groupAssignments"
$DMS = Invoke-MSGraphRequest -HttpMethod GET -Url $uri
$AllDeviceConfigScripts = $DMS.value | Where-Object {$_.assignments -match $Group.id}
Write-host "Number of Device Configurations Powershell Scripts found: $($AllDeviceConfigScripts.DisplayName.Count)" -ForegroundColor cyan
 
Foreach ($Config in $AllDeviceConfigScripts) {
Write-host $Config.displayName -ForegroundColor Yellow
}

# Feature Update Rings
$Resource = "deviceManagement/windowsFeatureUpdateProfiles"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)?`$expand=Assignments"
$DMS = Invoke-MSGraphRequest -HttpMethod GET -Url $uri
$AllFeatureUpdateRings = $DMS.value | Where-Object {$_.assignments -match $Group.id}
Write-host "Number of Feature Update Rings found: $($AllFeatureUpdateRings.DisplayName.Count)" -ForegroundColor cyan
 
Foreach ($Config in $AllFeatureUpdateRings) {
Write-host $Config.displayName -ForegroundColor Yellow
}

# Settings Catalog
$Resource = "deviceManagement/configurationPolicies"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)?`$expand=assignments"
$DMS = Invoke-MSGraphRequest -HttpMethod GET -Url $uri
$SettingsCatalog = $DMS.value | Where-Object {$_.assignments -match $Group.id}
Write-host "Number of Settings Catalog: $($SettingsCatalog.name.Count)" -ForegroundColor cyan
 
Foreach ($Setting in $SettingsCatalog) {
Write-host $Setting.name -ForegroundColor Yellow
}

# Security Baseline / Endpoint Security
$Resource = "deviceManagement/intents"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)?`$expand=assignments"
$DMS = Invoke-MSGraphRequest -HttpMethod GET -Url $uri
$SecBaseline = $DMS.value | Where-Object {$_.assignments -match $Group.id}
Write-host "Number of Security Baseline Settings: $($SecBaseline.DisplayName.Count)" -ForegroundColor cyan
 
Foreach ($Setting in $SecBaseline) {
Write-host $Setting.DisplayName -ForegroundColor Yellow
}

# Proactive Remediations
$Resource = "deviceManagement/deviceHealthScripts"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)?`$expand=assignments"
$DMS = Invoke-MSGraphRequest -HttpMethod GET -Url $uri
$ProactiveRemediations = $DMS.value | Where-Object {$_.assignments -match $Group.id}
Write-host "Proactive Remediations: $($ProactiveRemediations.displayame.Count)" -ForegroundColor cyan
 
Foreach ($Setting in $ProactiveRemediations) {
Write-host $Setting.DisplayName -ForegroundColor Yellow
}

# Administrative templates
$Resource = "deviceManagement/groupPolicyConfigurations"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)?`$expand=Assignments"
$ADMT = Invoke-MSGraphRequest -HttpMethod GET -Url $uri
$AllADMT = $ADMT.value | Where-Object {$_.assignments -match $Group.id}

Write-host "Number of Device Administrative Templates found: $($AllADMT.DisplayName.Count)" -ForegroundColor cyan
Foreach ($Config in $AllADMT) {
Write-host $Config.displayName -ForegroundColor Yellow
}
# Get all the Values
$Resource = "deviceAppManagement/managedAppPolicies"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
  
$ManagedAppPolicies = Invoke-MSGraphRequest -HttpMethod GET -Url $uri
$ManagedAppPolicies.value 

##########################

$Assignments = (Invoke-MSgraphRequest -httpmethod GET -Url "https://graph.microsoft.com/beta/deviceAppManagement/managedAppPolicies?`$select=id,displayname").value
$Assignments | Where-Object 'isAssigned' -eq "false"
# Get all the Values
$Resource = "deviceManagement/deviceConfigurations"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
  
$DeviceConfigurations = Invoke-MSGraphRequest -HttpMethod GET -Url $uri
$DeviceConfigurations.value

# Convert to JSON
$DeviceConfigurations = $DeviceConfigurations | ConvertTo-Json
$DeviceConfigurations


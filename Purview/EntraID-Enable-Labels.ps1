# Install the Microsoft Graph module for the current user
Install-Module Microsoft.Graph -Scope CurrentUser -Verbose

# Install the Microsoft Graph Beta module for the current user
Install-Module Microsoft.Graph.Beta -Scope CurrentUser -Verbose

# Connect to Microsoft Graph with the "Directory.ReadWrite.All" scope
Connect-MgGraph -Scopes "Directory.ReadWrite.All"

# Get the unified group settings from Microsoft Graph
$grpUnifiedSetting = Get-MgBetaDirectorySetting -Search DisplayName:"Group.Unified"

# Define the parameters for updating the directory settings
$params = @{
    Values = @(
        @{
            # Enable MIP labels
            Name = "EnableMIPLabels"
            Value = "True"
        }
    )
}

# Update the directory settings with the defined parameters
Update-MgBetaDirectorySetting -DirectorySettingId $grpUnifiedSetting.Id -BodyParameter $params

# Get the updated directory settings
$Setting = Get-MgBetaDirectorySetting -DirectorySettingId $grpUnifiedSetting.Id

# Output the values of the updated directory settings
$Setting.Values
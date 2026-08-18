<# 
.DESCRIPTION
Detects if Powershell 2.0 is installed/enabled
#>

$PSString = "Powershell 2.0"

# Collect current configured values
try {
    $PSValue = (Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root)
    if ($PSValue.state -eq 'Disabled')
{
    # Powershell 2.0 is Disabled.
    Write-Host "$PSString is disabled!"
    exit 0
}
else {
    # Remediation needed!
    Write-Host "$PSString is not disabled. Remediation needed!"
    exit 1
}
}
catch {
Write-Error $_.Exception
exit 1
}
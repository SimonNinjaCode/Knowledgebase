<# 
.DESCRIPTION
Detects if SMBv1 is installed/enabled.
#>

$PSString = "SMBv1"

# Collect current configured values
try {
    $PSValue = (Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol)
    if ($PSValue.state -eq 'Disabled')
{
    # SMBv1 is Disabled.
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
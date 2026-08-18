<# 
.DESCRIPTION
Detects if device is vulnerable to PKFail. Only detection.
#>

$PSString = "PKFail"

# Collect current values
try {
    $PSValue = ([System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI PK).bytes) -match "DO NOT TRUST|DO NOT SHIP")
    if ($PSValue -match 'False')
{
    # Untrusted Certificates not present.
    Write-Host "$PSValue, this device is not vulnerable to $PSString."
    exit 0
}
else {
    # Remediation needed!
    Write-Host "$PSValue, device is vulneraboe to $PSString."
    exit 0
}
}
catch {
Write-Error $_.Exception
exit 1
}
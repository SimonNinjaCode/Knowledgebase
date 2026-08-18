# Remediates SMBv1 (based on Windows feature)
try
{
    Disable-WindowsOptionalFeature -Online -FeatureName smb1protocol -Norestart
    exit 0
else {
    Write-Host "Failed to remediate SMBv1!"
    exit 1
}
}
catch {
Write-Error $_.Exception
exit 1
}
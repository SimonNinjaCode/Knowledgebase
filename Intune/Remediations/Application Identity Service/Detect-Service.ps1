# Collect current configured values
try {
	$registryPath = "Registry::HKLM\SYSTEM\CurrentControlSet\Services\AppIDSvc"
	$name = "Start"
    $Value = (Get-ItemProperty -Path $registryPath -Name $name -ErrorAction SilentlyContinue)
    if ($Value.Start -eq '2')
{
    # Application Identity already set to auto!
    Write-Host "Application Identity already set to auto!"
    exit 0
}
else {
    # Remediation needed!
    Write-Host "Application Identity not configured remediation needed!"
    exit 1
}
}
catch {
Write-Error $_.Exception
exit 1
}
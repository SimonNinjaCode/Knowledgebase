try
{
$registryPath = "Registry::HKLM\SYSTEM\CurrentControlSet\Services\AppIDSvc"
$name = "Start"
$value = "2"
$ServiceName = 'AppIDSvc'
Set-ItemProperty -Path $registryPath -Name $name -value $value
Start-Service $ServiceName

    Write-Host "Application Identity turned ON!"
    exit 0
else {
    Write-Host "Failed to turn on the Application Identity"
    exit 1
}
}
catch {
Write-Error $_.Exception
exit 1
}
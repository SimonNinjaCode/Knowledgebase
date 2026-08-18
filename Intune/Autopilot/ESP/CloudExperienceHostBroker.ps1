$ESPProcesses = Get-Process -Name 'CloudExperienceHostBroker' -ErrorAction 'SilentlyContinue'

if ($ESPProcesses.Count -gt 0) {
    Write-Host 'ESP is running.'
    exit 0
}
else {
    Write-Host 'ESP is not running.'
    exit 1
}
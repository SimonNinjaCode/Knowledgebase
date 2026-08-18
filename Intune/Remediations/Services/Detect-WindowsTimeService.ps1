$Service = (Get-service -name W32Time | Select-Object -Property Name,DisplayName,Status)
if ($Service.Status -eq "Running") {
	Write-Host "Windows Time service is already running."
	exit 0
} Else {
	Write-Host "Windows Time Service is not running, proceeding with startup..."
	Exit 1
}
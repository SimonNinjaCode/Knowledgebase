# Get Sense service
$senseService = Get-Service "Sense" -ErrorAction SilentlyContinue

# Check if service has been found
if($null -eq $senseService) {
    Write-Output "Sense service not found."
    exit 1
} else {
    Write-Output "Sense service found. OK."
    exit 0
}
# Add Microsoft.Windows.Sense.Client
try {

    Add-WindowsCapability -Name "Microsoft.Windows.Sense.Client~~~~" -Online
    Write-Output "Added WindowsCapability Microsoft.Windows.Sense.Client. Reboot required."
    exit 0

} catch {
    # error occured
    $errMsg = $_.Exception.Message
    Write-Output "Error: $errMsg"
    exit 1
}
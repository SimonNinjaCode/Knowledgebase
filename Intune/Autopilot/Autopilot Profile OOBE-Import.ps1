#Pre-Req
Set-Executionpolicy Unrestricted -force
$APFilePath = "C:\Windows\Provisioning\Autopilot"

Write-Host "Enter Administrator UPN, then press enter..."
$adminUser = Read-Host

if (!(Test-path -path "$clientPath\AutopilotConfigurationFile.json" -ErrorAction SilentlyContinue)) 
#Install PSHell-Modules WindowsAutoPilotIntune & AzureAD
{
    
    if ((get-module -listavailable -name WindowsAutoPilotIntune).count -ne 1) {
        install-module -name WindowsAutoPilotIntune -scope allusers -Force
    }
    else {
        update-module -name WindowsAutoPilotIntune
    }
    import-module -name WindowsAutoPilotIntune

    if ((get-module -listavailable -name AzureAD).count -ne 1) {
        install-module -name AzureAD -scope allusers -Force
    }
    else {
        update-module -name AzureAD
    }
    import-module -name AzureAD
#Connect to Autopilot
    Connect-AutoPilotIntune -user $adminUser
    $appolicies = Get-AutoPilotProfile
    if($appolicies.count -gt 1)
    {
        $appol = $appolicies | Out-GridView -PassThru
    }
    else {
        $appol = $appolicies
    }
    $appol | ConvertTo-AutoPilotConfigurationJSON | Out-File "$APFilePath\AutopilotConfigurationFile.json" -Encoding ascii
}
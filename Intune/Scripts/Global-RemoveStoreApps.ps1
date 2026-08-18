# Version 2
param ([int]$Delay=0,
       [string] $Action="Remove")

$AppsList=@("microsoft.windowscommunicationsapps","Microsoft.XboxApp","Microsoft.SkypeApp",`
            "Microsoft.Office.OneNote","Microsoft.MicrosoftSolitaireCollection",`
            "Microsoft.MicrosoftOfficeHub","Microsoft.BingWeather","Microsoft.ZuneMusic",`
            "Microsoft.ZuneVideo")

Function RemoveStoreApp {
param ([string] $appName)

    Get-AppxPackage -Name $AppName|Remove-AppxPackage -ErrorAction Ignore
}

Function ShowStoreApp {
param ([string] $appName)

    Get-AppxPackage -Name $AppName
}

Start-Transcript -path "$Env:Temp\RemoveStoreApps.txt" -append

Write-Host "Running RemoveStoreApps script" -ForegroundColor Yellow
Write-Host "Remove following Apps:" -Foregroundcolor Yellow
foreach ($App in $AppsList) {$App}
Write-Host "Waiting $Delay Seconds.." -ForegroundColor Yellow
Start-Sleep -Seconds $Delay

foreach ($App in $AppsList) {
    Write-Host "Processing $App" -ForegroundColor Yellow
    if ($Action -eq "Remove") {
        RemoveStoreApp $App
        }
    else 
        {
        ShowStoreApp $App
    }
}

Stop-Transcript
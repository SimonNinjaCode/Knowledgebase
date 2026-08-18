#TEST
$Path = "$env:LOCALAPPDATA\Microsoft\Onedrive\"
$Exe = "OneDriveStandaloneUpdater.exe"
Start-Process "$Path$Exe" -Wait
#Finalized
Start-Process "$env:LOCALAPPDATA\Microsoft\Onedrive\OneDriveStandaloneUpdater.exe" -Wait
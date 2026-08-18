O365 Download
https://gallery.technet.microsoft.com/office/and-Install-Office365-1c996b2d

$O365Path = "C:\Temp\O365"
if (!(Test-Path $O365Path)) {new-item -ItemType Directory -Force -Path $O365Path  | Out-Null}
Set-Location $O365Path

#Pre-Req
Set-Location "C:\Users\sesha\OneDrive - Proact IT Group\Powershell\AppDeployment\O365"
$LogTime = Get-Date -Format "MM-dd-yyyy"
$Logfile = "O365download.log-$logtime.txt"

#Remove Old
Remove-Item .\Office -Force -Recurse -Verbose *> $Logfile

#Download
$Setup = "Setup.exe"
$Arguments = "/download configuration.xml"
Start-Process $Setup -argumentlist $Arguments -Wait

New-BurnToastNotification -text "O365 Download Complete!"
$O365Path = "C:\Temp\O365"
if (!(Test-Path $O365Path)) {new-item -ItemType Directory -Force -Path $O365Path  | Out-Null}
Set-Location $O365Path

#Download
$Setup = "Setup.exe"
$Arguments = "/download O365MonthlyConfiguration.xml"
Start-Process $Setup -argumentlist $Arguments -Wait

#Install
$Setup = "Setup.exe"
$Arguments = "/configure O365MonthlyConfiguration.xml"
Start-Process $Setup -argumentlist $Arguments -Wait


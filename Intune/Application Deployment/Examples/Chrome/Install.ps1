#Installs Chrome with Legacy Browser Support
#Install Google Chrome Version 70.0.3538.110
$exec = "$psscriptroot\70.0.3538.110\GoogleChromeStandaloneEnterprise64.msi"
Start-Process C:\Windows\System32\msiexec.exe -ArgumentList "/i $exec /qn /norestart" -wait

#Install Legacy Browser Support Version 5.5.0.0
$exec2 = "$psscriptroot\Legacy.Browser.Support.5.5.0.0\LegacyBrowserSupport_5.5.0.0_en_x64.msi"
Start-Process C:\Windows\System32\msiexec.exe -ArgumentList "/i $exec2 /qn /norestart" -wait
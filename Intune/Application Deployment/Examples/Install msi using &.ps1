$LogFile = $Env:TEMP + "\MyApp.log"
$MyInstaller = "C:\temp\1.0.2\OfficeEX.msi"
& msiexec /i $MyInstaller /qb /norestart /l $LogFile

#Install MSI
#$exec = "C:\temp\1.0.2\O2016.msi"
#Start-Process C:\Windows\System32\msiexec.exe -ArgumentList "/i $exec /qb /norestart"

Start-Process C:\Windows\System32\msiexec.exe -ArgumentList "/i C:\temp\1.0.2\mtm.msi /qn /norestart" -wait

#Install Legacy Browser Support Version 5.5.0.0
$exec2 = "$psscriptroot\LBS5.5.0.0\LegacyBrowserSupport_5.5.0.0_en_x64.msi"
Start-Process C:\Windows\System32\msiexec.exe -ArgumentList "/i $exec2" -wait
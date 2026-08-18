# Install Google Chrome Version 70.0.3538.110
$version = ((Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{AA1B5CB3-7646-3858-A35C-158DB3846A9F}").DisplayVersion)
if($version -lt "70.0.3538.110"){
    $Processes = get-process | where {$_.Name -like "*Chrome*"}
    foreach($process in $Processes){
    Stop-Process -Name $process.ProcessName -Force -ErrorAction SilentlyContinue
    }
    # Install Google Chrome Version 70.0.3538.110
    $exec = "$psscriptroot\70.0.3538.110\GoogleChromeStandaloneEnterprise64.msi"
    Start-Process C:\Windows\System32\msiexec.exe -ArgumentList "/i $exec /qn /norestart" -wait
}

# Install Legacy Browser Support Version 5.5.0.0
$version = ((Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{E82CE8E3-C81B-481F-978E-A229F89985FA}").DisplayVersion)
if($version -lt "4.9.4"){
    $Processes = get-process | where {$_.Name -like "*Chrome*"}
    foreach($process in $Processes){
    Stop-Process -Name $process.ProcessName -Force -ErrorAction SilentlyContinue
    }
    # Install Legacy Browser Support Version 5.5.0.0
    $exec2 = "$psscriptroot\Legacy.Browser.Support.5.5.0.0\LegacyBrowserSupport_5.5.0.0_en_x64.msi"
    Start-Process C:\Windows\System32\msiexec.exe -ArgumentList "/i $exec2 /qn /norestart" -wait
}
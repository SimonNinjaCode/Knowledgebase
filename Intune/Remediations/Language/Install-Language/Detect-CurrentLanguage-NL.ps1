$OSInfo = Get-WmiObject -Class Win32_OperatingSystem
$languagePacks = $OSInfo.MUILanguages

if ($languagePacks -contains "nl-NL")
    {
    write-output "Installed"
     Exit 0
    }
    else
    {
    write-output "Not installed"
     Exit 1
    }
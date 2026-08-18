$OSInfo = Get-WmiObject -Class Win32_OperatingSystem
$languagePacks = $OSInfo.MUILanguages

if ($languagePacks -contains "nl-NL")
    {
    write-output "Installed. Setting language: nl-NL."
     Exit 1
    }
    else
    {
    write-output "Not installed"
     Exit 0
    }
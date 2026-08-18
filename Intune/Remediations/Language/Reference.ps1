# US
Set-WinUILanguageOverride -Language en-us
Set-WinUserLanguageList en-us -Force
Set-WinSystemLocale -SystemLocale en-us
Set-Culture -CultureInfo en-us
Set-WinHomeLocation -GeoId 122

# Netherlands
Set-WinUILanguageOverride -Language nl-NL
Set-WinUserLanguageList nl-NL -Force
Set-WinSystemLocale -SystemLocale nl-NL
Set-Culture -CultureInfo nl-NL
Set-WinHomeLocation -GeoId 176

# Get Status
Get-WinUILanguageOverride
Get-WinUserLanguageList 
Get-WinSystemLocale 
Get-Culture 
Get-WinHomeLocation 
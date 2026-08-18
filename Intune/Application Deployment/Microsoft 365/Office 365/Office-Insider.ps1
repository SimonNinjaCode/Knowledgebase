#Powershell
if((Test-Path -LiteralPath "HKCU:\Software\Policies\Microsoft\office\16.0\common") -ne $true) {  New-Item "HKCU:\Software\Policies\Microsoft\office\16.0\common" -force -ea SilentlyContinue };
New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\Microsoft\office\16.0\common' -Name 'insiderslabbehavior' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;

#Registry HKCU
[HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\common]
"insiderslabbehavior"=dword:00000001
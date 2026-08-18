$Key1 = 'HKCU:\Software\Microsoft\Office\16.0\Registration'
IF(!(Test-Path $Key1))
{New-Item -Path $Key1 -Force}
New-ItemProperty -Path $Key1 -Name AcceptAllEulas -PropertyType DWord -Value "1"

$Key2 = 'HKCU:\Software\Microsoft\Office\16.0\Common\General'
IF(!(Test-Path $Key2))
{New-Item -Path $Key2 -Force}
New-ItemProperty -Path $Key2 -Name ShownFileFmtPrompt -PropertyType DWord -Value "1"
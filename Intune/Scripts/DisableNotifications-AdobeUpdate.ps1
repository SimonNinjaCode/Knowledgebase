$HKLMregistryPath = 'HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown'
IF(!(Test-Path $HKLMregistryPath))
{New-Item -Path $HKLMregistryPath -Force}

New-ItemProperty -Path $HKLMregistryPath -Name bUpdater -PropertyType DWord -Value "1"
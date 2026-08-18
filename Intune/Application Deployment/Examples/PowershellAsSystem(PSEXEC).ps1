Start-Process -FilePath cmd.exe -Verb Runas -ArgumentList '/k C:\Scripts\_Sysinternals\PsExec.exe -i -s powershell.exe'

Start-Process -FilePath cmd.exe -Verb Runas -ArgumentList '/k C:\Temp\PsExec\PSEXEC -i -s powershell.exe'
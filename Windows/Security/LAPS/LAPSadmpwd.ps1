https://learn-powershell.net/2016/10/08/setting-up-local-administrator-password-solution-laps/

#Install LAPS UI on Management-server (includes powershell-module)
#GPO-files from installer LAPS.x64.msi
C:\Windows\PolicyDefinitions\AdmPwd.admx
C:\Windows\PolicyDefinitions\en-us\AdmPwd.adml

Get-Command –Module AdmPwd.PS

#PreReq Update Schema (Requires Schema Admins)
Update-AdmPwdADSchema –Verbose

#Find out all Accounts with rights to see the password (based on All Extended Rights access under an OU)
Get-ADOrganizationalUnit -Filter *|Find-AdmPwdExtendedRights -PipelineVariable OU |ForEach{
    $_.ExtendedRightHolders|ForEach{
    [pscustomobject]@{
    OU=$Ou.ObjectDN
    Object = $_
    }
    }
    }

#Ensure that the systems which will be managed by LAPS will be able to update the new attributes on their active directory computer account object
$OU = "Computers-Windows10"
Set-AdmPwdComputerSelfPermission –Identity $OU –Verbose

$pwdadmins = "VIRTUALLAB\LAPS-pwdadmins"
#Grant specific group of users rights to read and reset password on the managed workstations
Set-AdmPwdResetPasswordPermission –Identity $OU –AllowedPrincipals $pwdadmins  –Verbose 
Set-AdmPwdReadPasswordPermission –Identity $OU –AllowedPrincipals $pwdadmins  –Verbose

#ClientSide Deploy via SCCM or Intune
msiexec /i LAPS.x64.msi /q 

#Deploy with custom-admin name
msiexec /i LAPS.x64.msi /q CUSTOMADMINNAME=NewLocalAdmin

#Verify LAPS
$Client = "PXE002"
Invoke-GPUpdate –Computer $Client –Verbose

Get-ADcomputer $Client -prop ms-Mcs-AdmPwd,ms-Mcs-AdmPwdExpirationTime

#GetPasswordWithTimeStamp
$Computer = (Get-ADComputer –Identity $Client -prop ms-Mcs-AdmPwd,ms-Mcs-AdmPwdExpirationTime)
[datetime]::FromFileTime($Computer."ms-Mcs-AdmPwdExpirationTime")
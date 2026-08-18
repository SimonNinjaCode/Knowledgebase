Add-Type -AssemblyName 'System.Web'

$userParams = @{
    Name = 'corpo'
    Description = 'LAPS Account'
    Password = [System.Web.Security.Membership]::GeneratePassword(16, 0) | ConvertTo-SecureString -AsPlainText -Force
}

# create user with random password
$user = New-LocalUser @userParams

# Add user to built-in administrators group
Add-LocalGroupMember -SID 'S-1-5-32-544' -Member $user
$username = "defaultuser0"
$currentuser = (Get-Process -IncludeUserName -Name explorer | Select-Object -ExpandProperty UserName).Split('\')[1]

if ($currentuser -eq $username) {

Exit 1
} else {

Write-Output 1
exit 0
}

# Integer
# 1
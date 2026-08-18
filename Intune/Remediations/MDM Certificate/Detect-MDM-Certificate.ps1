Try {
$Result = Get-ChildItem -Path cert: -Recurse | where { $_.notafter -le (get-date).AddDays(30) -AND $_.notafter -gt (get-date) -and $_.issuer -like "CN=Microsoft Intune MDM Device CA" }  | select issuer, notafter
$ID = $Result | measure-Object
If ($ID.Count -gt 0)
{
    Write-Output "Intune MDM certificate is going to expire $result"
  Exit 1001
}
Else
{
    Write-Output "Intune MDM certificate is NOT going to expire"
  Exit 0
}
}
catch
{
Write-Warning "Value Missing"
Exit 1001
}
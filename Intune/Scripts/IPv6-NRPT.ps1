# Add Azure AD NRPT rule.
$DnsServers = (
    "ns1-37.azure-dns.com.",
    "ns2-37.azure-dns.net.",
    "ns3-37.azure-dns.org.",
    "ns4-37.azure-dns.info."
)
$DnsServerIPs = $DnsServers | Foreach-Object {
    (Resolve-DnsName $_).IPAddress | Select-Object -Unique
}

# List the rules.
$existingRules = Get-DnsClientNrptRule | Where-Object {
    $_.DisplayName -match "AZURE-AD-NRPT" -or $_.Namespace -match "login.microsoftonline.com"
}
if ($existingRules) { 
    Write-Output ("Azure AD NRPT rule exists: {0}" -F $existingRules) 
} 
else { 
    Write-Output "Adding Azure AD NRPT DNS rule for login.microsoftonline.com ..." 
    $params = @{
        Namespace = "login.microsoftonline.com"
        NameServers = $DnsServerIPs
        DisplayName = "AZURE-AD-NRPT"
    }
    Add-DnsClientNrptRule @params
}  
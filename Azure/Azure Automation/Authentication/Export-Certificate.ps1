$displayName = "Microsoft Graph PowerShell Client Credentials"
$notAfter = $(Get-Date).AddYears(1)
$cert = New-SelfSignedCertificate -CertStoreLocation cert:\currentuser\my -DnsName graph.microsoft.com -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" -NotAfter $notAfter -FriendlyName $displayName
$export = Export-Certificate -Cert "cert:\currentuser\my\$($cert.Thumbprint)" -FilePath "c:\temp\$displayName.cer"
Write-Output "Exported certificate '$($cert.Thumbprint)' to '$($export.FullName)'"

https://docs.microsoft.com/en-us/graph/powershell/app-only?tabs=azure-portal
https://tech.nicolonsky.ch/azure-ad-application-based-authentication-with-intune-using-certificate/
https://thesleepyadmins.com/2020/11/22/using-microsoft-graph-powershell-sdk/
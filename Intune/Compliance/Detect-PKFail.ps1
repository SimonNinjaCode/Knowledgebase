$PKFailSecureBoot = [System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI PK).bytes) -match "DO NOT TRUST|DO NOT SHIP"
$jsondata = @{PKFailSecureBoot = $PKFailSecureBoot}
return $jsondata | ConvertTo-Json -Compress
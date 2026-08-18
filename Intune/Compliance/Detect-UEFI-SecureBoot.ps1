<# 
.DESCRIPTION
Compliance Test
#>

$UEFIStatus = Confirm-SecureBootUEFI

$hash = @{`
    UEFISecureBOOT = $UEFIStatus;`
}
return $hash | ConvertTo-Json -Compress
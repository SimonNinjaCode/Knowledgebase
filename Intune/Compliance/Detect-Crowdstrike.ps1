<# 
.DESCRIPTION
Detects Crowdstrike Falcon Sensor
#>

$FalconSensor = Get-CimInstance Win32_OperatingSystem


$hash = @{`
    Crowdstrike = $FalconSensor; 
}
return $hash | ConvertTo-Json -Compress
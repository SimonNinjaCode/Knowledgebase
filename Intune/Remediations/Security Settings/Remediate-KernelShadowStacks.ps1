$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\KernelShadowStacks"
$Name = "Enabled"
$Type = "DWORD"
$Value = 1

Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value

$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\KernelShadowStacks"
$Name = "WasEnabledBy"
$Type = "DWORD"
$Value = 2

Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value
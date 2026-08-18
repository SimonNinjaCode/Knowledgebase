$PC = $env:computername  
$LicenseInfo = Get-WmiObject SoftwareLicensingProduct -ComputerName $PC-ErrorAction Stop | Where-Object { $_.PartialProductKey -and $_.ApplicationID -eq "55c92734-d682-4d71-983e-d6ec3f16059f" } | Select-Object PartialProductKey, Description, ProductKeyChannel, @{ N = "LicenseStatus"; E = { $lstat["$($_.LicenseStatus)"] } } 
$win32os = Get-WmiObject Win32_OperatingSystem -computer $PC -ErrorAction Stop 
$WindowsEdition = $win32os.Caption 
$ServicePack = $win32os.CSDVersion 
$OSArchitecture = $win32os.OSArchitecture 
$BuildNumber = $win32os.BuildNumber 
$RegisteredTo = $win32os.RegisteredUser  
$ProductID = $win32os.SerialNumber 
$PartialProductKey = $LicenseInfo.PartialProductKey 

Write-Output $LicenseInfo
Write-Output $win32os
Write-Output $WindowsEdition
Write-Output $ServicePack
Write-Output $OSArchitecture
Write-Output $BuildNumber
Write-Output $RegisteredTo
Write-Output $ProductID
Write-Output $PartialProductKey
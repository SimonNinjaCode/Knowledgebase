<# 
https://github.com/0x6d69636b/windows_hardening

Directory: C:\Windows_Hardening-Kitty

Content:                                                                                                                          
lists                                                              
HardeningKitty.psd1                                                
HardeningKitty.psm1

#>

Import-Module .\HardeningKitty.psm1
Invoke-HardeningKitty -Mode Audit -Log -Report
Invoke-HardeningKitty -EmojiSupport
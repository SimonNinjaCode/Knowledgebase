#AAD Groups
#Install-Module AzureADPreview -Force
$AADCred = Get-Credential
AzureADPreview\Connect-AzureAD -Credential $AADCred

#All Autopilot Devices
$AllAutoPilotDevices = (AzureADPreview\New-AzureADMSGroup -Description "All Autopilot Devices" -DisplayName "All Autopilot Devices" -mailEnabled 0 -mailnickname 0 -securityEnabled 1 -Verbose).id
AzureADPreview\Set-AzureADMSGroup -id $AllAutoPilotDevices -GroupTypes "DynamicMembership" -MembershipRule '(device.devicePhysicalIDs -any _ -contains "[ZTDId]")' -MembershipRuleProcessingState "On" -Verbose

#OfflineAutopilotProfile
$OfflineAutoPilotProfile = (AzureADPreview\New-AzureADMSGroup -Description "Offline Autopilot Profile" -DisplayName "OfflineAutopilotProfile" -mailEnabled 0 -mailnickname 0 -securityEnabled 1 -Verbose).id
AzureADPreview\Set-AzureADMSGroup -id $OfflineAutoPilotProfile -GroupTypes "DynamicMembership" -MembershipRule "(device.enrollmentProfileName -eq ""OfflineAutopilotProfile-$OfflineAutoPilotProfile "")" -MembershipRuleProcessingState "On"

#OfflineHybridAutoPilotProfile
$OfflineHybridAutoPilotProfile = (AzureADPreview\New-AzureADMSGroup -Description "Offline Hybrid AutoPilot Profile" -DisplayName "OfflineHybridAutoPilotProfile" -mailEnabled 0 -mailnickname 0 -securityEnabled 1 -Verbose).id
AzureADPreview\Set-AzureADMSGroup -id $OfflineHybridAutoPilotProfile -GroupTypes "DynamicMembership" -MembershipRule "(device.enrollmentProfileName -eq ""OfflineHybridAutoPilotProfile-$OfflineHybridAutoPilotProfile"")" -MembershipRuleProcessingState "On"
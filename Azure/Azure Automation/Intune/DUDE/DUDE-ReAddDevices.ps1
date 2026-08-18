# Use the following script to add back devices to device groups based on Entra ID Audit Log.
# Connect-AzAccount (Log Analytics Workspace ID - Entra ID Diagnostic Audit Logs)

$WorkspaceId = ""

$Query = "AuditLogs
| where TimeGenerated > ago(9h)
| where OperationName == 'Remove member from group' and Identity == 'EUS-FunctionApp-DynamicUserandDeviceEnumeration'
| project TimeGenerated, OperationName, Identity, TargetResources"
$Log = @()
$Log = Invoke-AzOperationalInsightsQuery -WorkspaceId $WorkspaceID -Query $Query -ErrorAction Stop | select -ExpandProperty Results

$Changes = @()
foreach ($Entry in $Log) {

    $TargetResources = $Entry.TargetResources | ConvertFrom-Json
    $TargetResources = $TargetResources | Where-Object { $_.type -eq "Device" }
    if ($TargetResources.id.count -ge "2") {
        Write-Host "Device count is greater than 2"
        Break
    }

    if ($TargetResources.id.count -eq "1") {
        $Changes += [PSCustomObject][Ordered]@{
            TimeGenerated = $Entry.TimeGenerated
            OperationName = $Entry.OperationName
            Identity      = $Entry.Identity
            DeviceName    = $TargetResources.displayName
            DeviceId      = $TargetResources.id
            OldGroupId    = ($TargetResources.modifiedProperties | Where-Object { $_.displayName -eq "Group.ObjectID" }).oldValue
            NewGroupId    = ($TargetResources.modifiedProperties | Where-Object { $_.displayName -eq "Group.ObjectID" }).newValue
        }
    }
}

$Changes | ogv

<#
foreach ($Change in $Changes) {
    $GroupId = @()
    $GroupId = $Change.OldGroupId -replace "`""
    Add-AzADGroupMember -TargetGroupObjectId $GroupId -MemberObjectId $Change.DeviceId -ErrorAction SilentlyContinue
}
#>
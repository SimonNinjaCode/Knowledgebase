# Input bindings are passed in via param block.
param($Timer)

#region Variables
$RunWithSecret = $false
if ($RunWithSecret) {
    $AppID = Read-Host "Enter AppID"
    $AppSecret = Read-Host "Enter AppSecret"
    $TenantId = Read-Host "Enter TenantId"
}
$ResourceGroup = ""
$StorageAccount = ""
$UsersTableName = "CsiUsers"
$ADUsersTableName = "ADUserStatus"
$ConditionalAccessProtectedGroups = `
    "Identity-Conditional Access Baseline Users", `
    "Identity-Conditional Access Operators", `
    "Identity-Conditional Access Service Accounts", `
    "Identity-Conditional Access SMTP Accounts"
$Date = Get-Date
#$Date = (Get-Date).AddDays(-1)
$RetentionDate = $Date.AddDays(-7)
#endregion

#region Functions
if ($RunWithSecret) {
    function Get-GraphAccessToken {
        try {
            $GraphHost = "https://graph.microsoft.com/"
            $Body = @{client_id = $AppID; client_secret = $AppSecret; grant_type = "client_credentials"; scope = "$GraphHost/.default"; }
            $OAuthReq = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token" -Body $Body
            $GraphAccessToken = @{ "Authorization" = "Bearer $($OAuthReq.access_token)" }
            return $GraphAccessToken
        }
        catch {
            Write-Error $_.Exception
        }
    }
}
else {
    function Get-GraphAccessToken {
        try {
            $ResourceURI = "https://graph.microsoft.com/"
            $TokenAuthURI = $env:IDENTITY_ENDPOINT + "?resource=$ResourceURI&api-version=2019-08-01"
            $TokenResponse = Invoke-RestMethod -Method Get -Headers @{"X-IDENTITY-HEADER" = "$env:IDENTITY_HEADER" } -Uri $TokenAuthURI -ErrorAction Stop
            $GraphAccessToken = @{ "Authorization" = "Bearer $($TokenResponse.access_token)" }
            return $GraphAccessToken
        }
        catch {
            Write-Error $_.Exception
        }
    }
}

function Invoke-GraphCall {
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $false)]
        [ValidateSet("Get", "Post", "Patch", "Delete")]
        [string]$Method = 'Get',

        [parameter(Mandatory = $false)]
        [hashtable]$GraphAccessToken = $script:GraphAccessToken,

        [parameter(Mandatory = $true)]
        [string]$Uri,

        [parameter(Mandatory = $false)]
        [string]$ContentType = 'Application/Json',

        [parameter(Mandatory = $false)]
        [hashtable]$Body
    )
    try {
        $params = @{
            Method      = $Method
            Headers     = $GraphAccessToken
            Uri         = $Uri
            ContentType = $ContentType
        }
        if ($Body) {
            $params.Body = $Body | ConvertTo-Json -Depth 20
        }
        if ($Method -eq "Get") {
            $request = Invoke-RestMethod @params
            $pages = $request.'@odata.nextLink'
            while ($null -ne $pages) {
                $addtional = Invoke-RestMethod -Method Get -Uri $pages -Headers $GraphAccessToken
                if ($pages) {
                    $pages = $addtional."@odata.nextLink"
                }
                $request.value += $addtional.value
            }
            return $request
        }
        else {
            $request = Invoke-RestMethod @params
            return $request
        }
    }
    catch {
        Write-Warning $_.Exception.Message
    }
}
#endregion

#region Get GraphAccessToken
$script:GraphAccessToken = Get-GraphAccessToken
#endregion

#region Connect AzAccount & Get StorageAccount
if ($RunWithSecret -eq $false) {
    Connect-AzAccount -Identity | Out-Null
}
else {
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $AppID, $($AppSecret | ConvertTo-SecureString -AsPlainText -Force)
    Connect-AzAccount -ServicePrincipal -Credential $Credential -Tenant $TenantId | Out-Null
}
$StorageAccount = Get-AzStorageAccount -Name $StorageAccount -ResourceGroupName $ResourceGroup
#endregion

#region Get UsersTable
$UsersTable = (Get-AzStorageTable –Context $StorageAccount.Context | Where-Object { $_.Name -eq $UsersTableName }).CloudTable
if ($UsersTable.Name.Count -ne "1") {
    Write-Error "Could not get UsersTable" -ErrorAction Stop
}
#endregion

#region Get UsersTableContentToday
$UsersTableContentToday = @{}
try {
    $UsersTableContentTodayData = Get-AzTableRow -table $UsersTable -PartitionKey $Date.ToString("yyyy-MM-dd")
    foreach ($Entity in $UsersTableContentTodayData) {
        $UsersTableContentToday.Add($Entity.RowKey, $Entity)
    }
    Write-Output "UsersTableContentToday = $($UsersTableContentToday.Count)"
}
catch {
    Write-Error "Could not get UsersTableContentToday" -ErrorAction Stop
}
#endregion

#region Get UsersTableContentToRemove
$UsersTableContentToRemove = @{}
try {
    $Filter = "PartitionKey lt '" + $RetentionDate.ToString("yyyy-MM-dd") + "'"
    $UsersTableContentToRemoveData = Get-AzTableRow -table $UsersTable -customFilter $Filter
    foreach ($Entity in $UsersTableContentToRemoveData) {
        $UsersTableContentToRemove.Add($Entity.RowKey, $Entity)
    }
    Write-Output "UsersTableContentToRemove = $($UsersTableContentToRemove.Count)"
}
catch {
    Write-Error "Could not get UsersTableContentToRemove" -ErrorAction Stop
}
#endregion

#region Get ADUsersTable
$ADUsersTable = (Get-AzStorageTable –Context $StorageAccount.Context | Where-Object { $_.Name -eq $ADUsersTableName }).CloudTable
if ($ADUsersTable.Name.Count -ne "1") {
    Write-Error "Could not get ADUsersTable" -ErrorAction Stop
}
#endregion

#region Get ADUsersTableContent
$ADUsersTableContent = @{}
try {
    $ADUsersTableContentData = Get-AzTableRow -table $ADUsersTable
    foreach ($Entity in $ADUsersTableContentData) {
        $ADUsersTableContent.Add($Entity.RowKey, $Entity)
    }
    Write-Output "ADUsersTableContent = $($ADUsersTableContent.Count)"
}
catch {
    Write-Error "Could not get ADUsersTableContent" -ErrorAction Stop
}
#endregion

#region Get AllUsers
$AllUsers = @{}
$AllUsersData = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/users").value
foreach ($User in $AllUsersData) {
    $AllUsers.Add($User.userPrincipalName, $User)
}
if ($AllUsers.Count -eq 0) {
    Write-Error "Could not get AllUsers"
    Break
}
Write-Output "AllUsers = $($AllUsers.Count)"
Remove-Variable -Name AllUsersData
#endregion

#region Get UserRegistrationDetails
$UserRegistrationDetails = @{}
$UserRegistrationDetailsData = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/reports/authenticationMethods/userRegistrationDetails").value
foreach ($User in $UserRegistrationDetailsData) {
    $UserRegistrationDetails.Add($User.id, $User)
}
if ($UserRegistrationDetails.Count -eq 0) {
    Write-Error "Could not get UserRegistrationDetails"
    Break
}
Write-Output "UserRegistrationDetails = $($UserRegistrationDetails.Count)"
Remove-Variable -Name UserRegistrationDetailsData
#endregion

#region Get ConditionalAccessProtectedUsers
$ConditionalAccessProtectedUsers = @{}
foreach ($Group in $ConditionalAccessProtectedGroups) {
    $GroupInfo = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups?`$filter=displayName eq '$Group'").value
    $GroupMembers = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups/$($GroupInfo.Id)/transitivemembers").value | Where-Object { $_.'@odata.type' -eq '#microsoft.graph.user' }
    foreach ($User in $GroupMembers) {
        $Values = [PSCustomObject][ordered]@{
            GroupId   = $GroupInfo.Id
            GroupName = $GroupInfo.DisplayName
            UserId    = $User.Id
        }
        $ConditionalAccessProtectedUsers.Add("$($GroupInfo.Id)-$($User.Id)", $Values)
    }
}
Write-Output "ConditionalAccessProtectedUsers = $($ConditionalAccessProtectedUsers.Count)"
#endregion

#region Get ConditionalAccessExcludedUsers
$ConditionalAccessExcludedUsers = @{}
$ConditionalAccessPolicies = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/identity/conditionalAccess/policies").value | Where-Object { $_.State -eq "Enabled" -and $_.DisplayName -notlike "old_*" }
foreach ($Policy in $ConditionalAccessPolicies) {
    $ExcludedUsers = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/identity/conditionalAccess/policies/$($Policy.Id)").Conditions.Users.ExcludeUsers
    $ExcludedGroups = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/identity/conditionalAccess/policies/$($Policy.Id)").Conditions.Users.ExcludeGroups
    foreach ($Group in $ExcludedGroups) {
        $GroupMembers = (Invoke-GraphCall -Uri "https://graph.microsoft.com/beta/groups/$Group/transitivemembers").value | Where-Object { $_.'@odata.type' -eq '#microsoft.graph.user' }
        foreach ($Member in $GroupMembers) {
            $ExcludedUsers += $Member.Id
        }
    }
    $ExcludedUsers = $ExcludedUsers | Sort-Object -Unique
    foreach ($User in $ExcludedUsers) {
        $Values = [PSCustomObject][ordered]@{
            PolicyId   = $Policy.Id
            PolicyName = $Policy.DisplayName
            UserId     = $User
        }
        $ConditionalAccessExcludedUsers.Add("$($Policy.Id)-$($User)", $Values)
    }
}
Write-Output "ConditionalAccessExcludedUsers = $($ConditionalAccessExcludedUsers.Count)"
#endregion

#region Add info to AllUsers
foreach ($User in $AllUsers.Values) {

    # Add AuthenticationMethods
    if ($UserRegistrationDetails.ContainsKey($User.id)) {
        $User | Add-Member -MemberType NoteProperty -Name "DefaultMfaMethod" -Value "$($UserRegistrationDetails[$User.id].DefaultMfaMethod)"
        $User | Add-Member -MemberType NoteProperty -Name "IsMfaCapable" -Value "$($UserRegistrationDetails[$User.id].IsMfaCapable)"
        $User | Add-Member -MemberType NoteProperty -Name "IsPasswordlessCapable" -Value "$($UserRegistrationDetails[$User.id].IsPasswordlessCapable)"
        $User | Add-Member -MemberType NoteProperty -Name "IsSsprCapable" -Value "$($UserRegistrationDetails[$User.id].IsSsprCapable)"
    }
    else {
        $User | Add-Member -MemberType NoteProperty -Name "DefaultMfaMethod" -Value "none"
        $User | Add-Member -MemberType NoteProperty -Name "IsMfaCapable" -Value "False"
        $User | Add-Member -MemberType NoteProperty -Name "IsPasswordlessCapable" -Value "False"
        $User | Add-Member -MemberType NoteProperty -Name "IsSsprCapable" -Value "False"
    }

    # Add ConditionalAccessProtection
    if ($ConditionalAccessProtectedUsers.Keys -match $User.id) {
        $ProtectedGroups = @()
        $Keys = $ConditionalAccessProtectedUsers.Keys -match $User.id
        foreach ($Key in $Keys) {
            $ProtectedGroups += $ConditionalAccessProtectedUsers[$Key].GroupName
        }
        $ProtectedGroups = $ProtectedGroups -join ", "
        $User | Add-Member -MemberType NoteProperty -Name "ConditionalAccessProtected" -Value "True"
        $User | Add-Member -MemberType NoteProperty -Name "ConditionalAccessProtectedGroup" -Value $ProtectedGroups
    }
    else {
        $User | Add-Member -MemberType NoteProperty -Name "ConditionalAccessProtected" -Value "False"
        $User | Add-Member -MemberType NoteProperty -Name "ConditionalAccessProtectedGroup" -Value ""
    }

    # Add ConditionalAccessExcluded
    if ($ConditionalAccessExcludedUsers.Keys -match $User.id) {
        $ExclusionGroups = @()
        $Keys = $ConditionalAccessExcludedUsers.Keys -match $User.id
        foreach ($Key in $Keys) {
            $ExclusionGroups += $ConditionalAccessExcludedUsers[$Key].PolicyName
        }
        $ExclusionGroups = $ExclusionGroups -join ", "
        $User | Add-Member -MemberType NoteProperty -Name "ConditionalAccessExcluded" -Value "True"
        $User | Add-Member -MemberType NoteProperty -Name "ConditionalAccessExcludedPolicy" -Value $ExclusionGroups
    }
    else {
        $User | Add-Member -MemberType NoteProperty -Name "ConditionalAccessExcluded" -Value "False"
        $User | Add-Member -MemberType NoteProperty -Name "ConditionalAccessExcludedPolicy" -Value ""
    }
}
#endregion

#region Add ADUsers to AllUsers
$Count = 0
foreach ($User in $ADUsersTableContent.Values) {
    if (!($AllUsers.ContainsKey($User.userPrincipalName))) {
        $Add = @()
        $Add = [PSCustomObject][Ordered]@{
            userPrincipalName               = $User.userPrincipalName
            companyName                     = $User.company
            SID                             = $User.SID
            AccountEnabled                  = $User.Enabled
            onPremisesExtensionAttributes   = [PSCustomObject]@{
                extensionattribute13 = $User.extensionattribute13
            }
            city                            = $User.l
            sAMAccountName                  = $User.sAMAccountName
            country                         = $User.co
            department                      = $User.department
            DefaultMfaMethod                = "none"
            IsMfaCapable                    = "False"
            IsPasswordlessCapable           = "False"
            IsSsprCapable                   = "False"
            ConditionalAccessProtected      = "False"
            ConditionalAccessProtectedGroup = ""
            ConditionalAccessExcluded       = "False"
            ConditionalAccessExcludedPolicy = ""
        }
        $AllUsers.Add($User.userPrincipalName, $Add)
        $Count++
    }
}
Write-Output "Added ADUsers to AllUsers = $Count"
#endregion

#region Update Users Table
foreach ($User in $AllUsers.Values) {
    $AddUser = $false
    if ($User.SID -eq $null) {
        $Source = "Entra ID"
        $RowKey = "$($Date.ToString("yyyy-MM-dd"))-$($User.Id)"
    }
    else {
        $Source = "AD"
        $RowKey = "$($Date.ToString("yyyy-MM-dd"))-$($User.SID)"
    }

    # Check if table is empty or if device already exist in the table
    if ($UsersTableContentToday.Count -eq "0") {
        $AddUser = $true
    }
    if ($AddUser -eq $false) {
        <#
        if ($TableContentHashTable.ContainsKey($Device.id)) {
            # Check if values are correct
            if ($TableContentHashTable[$Device.id].id -ne $Device.id -or `
                    $TableContentHashTable[$Device.id].azureADDeviceId -ne $Device.azureADDeviceId -or `
                    $TableContentHashTable[$Device.id].deviceName -ne $Device.deviceName -or `
                    $TableContentHashTable[$Device.id].operatingSystem -ne $Device.operatingSystem -or `
                    $TableContentHashTable[$Device.id].JoinType -ne $Device.JoinType -or `
                    $TableContentHashTable[$Device.id].userPrincipalName -ne "$($Device.userPrincipalName)" -or `
                    $TableContentHashTable[$Device.id].complianceState -ne $Device.complianceState) {
                # Get the entity
                $DeviceEntity = @()
                $DeviceEntity = Get-AzTableRow -PartitionKey $Device.id -Table $Table

                # Change the entity
                $DeviceEntity.id = $Device.id
                $DeviceEntity.azureADDeviceId = $Device.azureADDeviceId
                $DeviceEntity.deviceName = $Device.deviceName
                $DeviceEntity.operatingSystem = $Device.operatingSystem
                $DeviceEntity.JoinType = $Device.JoinType
                $DeviceEntity.userPrincipalName = "$($Device.userPrincipalName)"
                $DeviceEntity.complianceState = $Device.complianceState

                # Update the entity
                try {
                    $Update = $DeviceEntity | Update-AzTableRow -table $Table
                }
                catch {
                    Write-Error "Could not update MdmDeviceId $($Device.id) AadDeviceId $($Device.azureADDeviceId) DeviceName $($Device.deviceName) in the $($TableName) Table" -ErrorAction Stop
                }
            }
        }
        else {
            $AddDevice = $true
        }
        #>
    }
    if ($AddUser -eq $true) {
        try {
            $Add = Add-AzTableRow `
                -Table $UsersTable `
                -PartitionKey $Date.ToString("yyyy-MM-dd") `
                -RowKey $RowKey `
                -property @{
                "id"                              = "$($User.id)"
                "source"                          = "$($Source)"
                "AccountEnabled"                  = "$($User.AccountEnabled)"
                "AssignedLicenses"                = "$($User.AssignedLicenses)"
                "BusinessPhones"                  = "$($User.BusinessPhones)"
                "City"                            = "$($User.City)"
                "CompanyName"                     = "$($User.CompanyName)"
                "Country"                         = "$($User.Country)"
                "CreatedDateTime"                 = "$($User.CreatedDateTime)"
                "Department"                      = "$($User.Department)"
                "DisplayName"                     = "$($User.DisplayName)"
                "ExtensionAttribute13"            = "$($User.OnPremisesExtensionAttributes.ExtensionAttribute13)"
                "JobTitle"                        = "$($User.JobTitle)"
                "MobilePhone"                     = "$($User.MobilePhone)"
                "OfficeLocation"                  = "$($User.OfficeLocation)"
                "OnPremisesDistinguishedName"     = "$($User.OnPremisesDistinguishedName)"
                "PostalCode"                      = "$($User.PostalCode)"
                "StreetAddress"                   = "$($User.StreetAddress)"
                "UsageLocation"                   = "$($User.UsageLocation)"
                "UserPrincipalName"               = "$($User.UserPrincipalName)"
                "UserType"                        = "$($User.UserType)"
                "ConditionalAccessProtected"      = "$($User.ConditionalAccessProtected)"
                "ConditionalAccessProtectedGroup" = "$($User.ConditionalAccessProtectedGroup)"
                "ConditionalAccessExcluded"       = "$($User.ConditionalAccessExcluded)"
                "ConditionalAccessExcludedPolicy" = "$($User.ConditionalAccessExcludedPolicy)"
                "DefaultMfaMethod"                = "$($User.DefaultMfaMethod)"
                "IsMfaCapable"                    = "$($User.IsMfaCapable)"
                "IsPasswordlessCapable"           = "$($User.IsPasswordlessCapable)"
                "IsSsprCapable"                   = "$($User.IsSsprCapable)"
            }
        }
        catch {
            Write-Error "Could not add User $($User.id) UPN $($User.UserPrincipalName) to the $($UsersTable.Name) Table" -ErrorAction Stop
        }
    }
}
Write-Output "Verified User records = $($AllUsers.Values.Id.Count)"
#endregion

#region Remove UsersTableContentToRemove
foreach ($User in $UsersTableContentToRemove.Values) {
    try {
        $Remove = Remove-AzTableRow -Table $UsersTable -PartitionKey $User.PartitionKey -RowKey $User.RowKey
    }
    catch {
        Write-Error "Could not remove User $($User.id) from the $($UsersTable.Name) Table" -ErrorAction Stop
    }
}
Write-Output "Removed User records = $($UsersTableContentToRemove.Values.Id.Count)"
#endregion
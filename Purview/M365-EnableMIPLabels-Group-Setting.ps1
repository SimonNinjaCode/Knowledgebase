<#
.SYNOPSIS
    Enable sensitivity labels (MIP labels) for Microsoft 365 Groups and Teams.

.DESCRIPTION
    Configures the Entra ID "Group.Unified" directory setting to enable
    Microsoft Information Protection (MIP) labels for M365 Groups.

    If the Group.Unified setting does not exist, it is created from the
    directory setting template. If it already exists, EnableMIPLabels is
    updated to True.

.NOTES
    Module:      Microsoft.Graph.Beta.Identity.DirectoryManagement
    Permissions: Directory.ReadWrite.All
    Reference:   https://learn.microsoft.com/en-us/entra/fundamentals/groups-settings-cmdlets
#>

# ── 1) Prerequisites ────────────────────────────────────────────────────────
if (-not (Get-Module -ListAvailable Microsoft.Graph.Beta.Identity.DirectoryManagement)) {
    Install-Module Microsoft.Graph.Beta.Identity.DirectoryManagement -Scope CurrentUser
}

# ── 2) Connect with the minimum required permissions ─────────────────────────
Connect-MgGraph -Scopes "Directory.ReadWrite.All"

# ── 3) Show current Group.Unified settings (if any) ─────────────────────────
$currentValues = Get-MgBetaDirectorySetting |
    Where-Object { $_.DisplayName -eq "Group.Unified" } |
    Select-Object -ExpandProperty Values
Write-Output "*** Current Group.Unified Settings ***"
$currentValues

# ── 4) Show template defaults for reference ──────────────────────────────────
$templateDefaults = Get-MgBetaDirectorySettingTemplate |
    Where-Object { $_.DisplayName -eq "Group.Unified" } |
    Select-Object -ExpandProperty Values |
    Select-Object Name, DefaultValue, Type, Description
Write-Output "*** Template Default Settings ***"
$templateDefaults

# ── 5) Enable MIP labels ────────────────────────────────────────────────────
$setting = Get-MgBetaDirectorySetting | Where-Object { $_.DisplayName -eq "Group.Unified" }

if (-not $setting) {
    # Group.Unified does not exist — create from template
    $templateObj = Get-MgBetaDirectorySettingTemplate |
        Where-Object { $_.DisplayName -eq "Group.Unified" }
    $params = @{
        templateId = $templateObj.Id
        values     = @(
            @{ name = "EnableMIPLabels"; value = "True" }
        )
    }
    $setting = New-MgBetaDirectorySetting -BodyParameter $params
    Write-Output "Group.Unified created from template with EnableMIPLabels = True"
}
else {
    # Group.Unified exists — update EnableMIPLabels
    $existing = $setting.Values | Where-Object { $_.Name -eq "EnableMIPLabels" }
    if ($existing) {
        $existing.Value = "True"
        Write-Output "EnableMIPLabels updated to True"
    }
    else {
        $setting.Values += @{ Name = "EnableMIPLabels"; Value = "True" }
        Write-Output "EnableMIPLabels added with value True"
    }
    Update-MgBetaDirectorySetting -DirectorySettingId $setting.Id -BodyParameter @{
        Values = @($setting.Values)
    }
}

# ── 6) Verify final settings ────────────────────────────────────────────────
$finalValues = Get-MgBetaDirectorySetting |
    Where-Object { $_.DisplayName -eq "Group.Unified" } |
    Select-Object -ExpandProperty Values
Write-Output "*** Final Group.Unified Settings ***"
$finalValues
# Detection - New Teams
if ((Get-AppxPackage -AllUsers | Where-Object { $_.Name -eq "MSTeams" }).Name.Count -ge "1") {
    Write-Host "Installed"
}

# Detection - Classic Teams
If([String](Get-Item -Path "$Env:ProgramFiles\Teams Installer\Teams.exe","${Env:ProgramFiles(x86)}\Teams Installer\Teams.exe" -ErrorAction SilentlyContinue).VersionInfo.FileVersion -ge "1.5.00.17656"){
    Write-Host "Installed"
    }
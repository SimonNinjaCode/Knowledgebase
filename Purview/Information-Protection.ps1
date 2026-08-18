## Install AIP Service Module & Connect to the service
Install-Module AipService -Scope AllUsers -Force -Verbose
Connect-Aipservice

## Check status of Information Protection integration
Get-AipService

## Enable Service
Enable-AipService

## Get status of Scoped Onboarding (Scope All)
Get-AipServiceOnboardingControlPolicy

## Set scoped onboarding for specific group
$Groupid = "fbb99ded-32a0-45f1-b038-38b519009503"
Set-AipServiceOnboardingControlPolicy -UseRmsUserLicense $False -SecurityGroupObjectId $Groupid

## Opt-out of scoped deployment
Set-AipServiceOnboardingControlPolicy -UseRmsUserLicense $False
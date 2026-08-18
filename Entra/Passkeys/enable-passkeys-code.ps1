# Authenticator for iOS: 90a3ccdf-635c-4729-a248-9b709135078f
# Authenticator for Android: de1e552d-db1d-4423-a619-566b625cdc84

Connect-MgGraph -Scopes Policy.Read.All, Policy.ReadWrite.AuthenticationMethod

$body = @{
    "@odata.type" = "#microsoft.graph.fido2AuthenticationMethodConfiguration"
    "includeTargets" = @(
        @{
          "id" = "all_users"
          "isRegistrationRequired" = $false
          "targetType" = "group"
        }
    )
    "isAttestationEnforced" = $false
    "keyRestriction" = @{
        isEnforced = $true
        enforcementType = "allow"
        aaGuids = @(
            "90a3ccdf-635c-4729-a248-9b709135078f",
            "de1e552d-db1d-4423-a619-566b625cdc84"
        )
    }
}

Invoke-MgGraphRequest -Method PATCH -Uri "/beta/authenticationMethodsPolicy/authenticationMethodConfigurations/FIDO2" -Body $body

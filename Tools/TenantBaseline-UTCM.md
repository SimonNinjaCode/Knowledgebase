### Quick Start
```
After installing, launch the interactive management console:

TenantBaseline

Or use individual commands:

# Connect with setup permissions (first time only)
Connect-TBTenant -Scenario Setup

# Provision the UTCM service principal and grant permissions
Install-TBServicePrincipal

# Reconnect with day-to-day permissions
Connect-TBTenant -Scenario Manage

# Create a monitor to track Conditional Access policies
New-TBMonitor -DisplayName 'CA Monitor' -Resources @(
    @{ resourceType = 'microsoft.entra.conditionalaccesspolicy'; displayName = 'CA Policy' }
)

# Check for configuration drift
Get-TBDrift

# Generate an HTML drift report
New-TBDriftReport -OutputPath ./drift-report.html
```

### Links
https://github.com/ugurkocde/TenantBaseline

https://learn.microsoft.com/en-us/graph/unified-tenant-configuration-management-concept-overview
# Install Pester and Maester https://maester.dev/docs/installation
Install-Module Pester -SkipPublisherCheck -Force -Scope CurrentUser
Install-Module Maester -Scope CurrentUser

# Internal Navigation + Create Maester test folders
cd ./Azure/
cd ./Maester/
md maester-tests
cd maester-tests

# Install CISA Pre-requisites
Install-Module Az -Scope CurrentUser
Install-Module ExchangeOnlineManagement -Scope CurrentUser

# Install Maester Tests
Install-MaesterTests

# Connect to Maester including Azure & Exchange Online (CISA)
Connect-Maester -Service All

# Invoke Tests
Invoke-Maester
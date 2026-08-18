# Global Variables
$Tenant          = "4d2b1c1b-741f-485a-91d0-31aa9cff5461"
$Subscription    = "39c4591e-44ce-40a5-b762-581e1d6b64c3"
$TemplateFile    = "/Users/simon/Library/CloudStorage/OneDrive-Exobe/Powershell/Security Copilot/Template.json"

# Microsoft Copilot for Security - Capacity Resource
$Location        = "westeurope"
$ResourceGroup   = "Infrastructure-SecurityCopilot" 
$ResourceName    = "shodancopilotsecurity"
$crossGeoCompute = "Allowed"
$numberOfUnits   = 1 
$Geo             = "eu" 
$ResourceType    = "microsoft.securitycopilot/capacities"
$DeploymentName  = "Deploy" + $ResourceName

Connect-AzAccount -Tenant $Tenant -Subscription $Subscription -Verbose

# Create Resource Group
Write-Host "Creating RG $ResourceGroup"
New-AzResourceGroup -Name $ResourceGroup -Location $Location -Force -Verbose

# Deploy 1 SCU for Security Copilot
Write-host "Deploying 1 SCU for Security Copilot. Please be patient..."
New-AzResourceGroupDeployment `
    -Verbose `
    -Name $DeploymentName `
    -ResourceGroupName $ResourceGroup `
    -TemplateFile $TemplateFile `
    -capacityName $ResourceName `
    -location $Location `
    -crossGeoCompute $crossGeoCompute `
    -geo $Geo `
    -numberOfUnits $numberOfUnits

# Delete Resource Group + Security Copilot Capacity 
Write-Host "Deleting your RG $ResourceGroup Be patient!"
Remove-AzResourceGroup -Name $ResourceGroup -Force -Verbose

# Create Resource Group again for proper billing monitoring.
New-AzResourceGroup -Name $ResourceGroup -Location $Location -Force -Verbose
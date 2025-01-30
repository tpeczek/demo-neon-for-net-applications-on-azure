targetScope = 'subscription'

param location string = 'westeurope'

var projectResourceGroupName = 'rg-neon-simple-asp-net-core-on-app-service' 

resource projectResourceGroup 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: projectResourceGroupName
  location: location
}

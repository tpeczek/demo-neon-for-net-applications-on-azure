targetScope = 'subscription'

param location string = 'westus3'
param projectName string = 'simple-asp-net-core-on-app-service-with-neon'

var projectResourceGroupName = 'rg-${projectName}' 

resource projectResourceGroup 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: projectResourceGroupName
  location: location
}

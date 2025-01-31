targetScope = 'subscription'

param location string = 'westus3'
param projectName string = 'simple-asp-net-core-on-app-service-with-neon'
@secure()
param neonConnectionString string

var projectResourceGroupName = 'rg-${projectName}' 

resource projectResourceGroup 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: projectResourceGroupName
  location: location
}

module projectResourceGroupModule 'simple-asp-net-core-on-app-service-rg.bicep' = {
  name: 'simple-asp-net-core-on-app-service-rg'
  scope: projectResourceGroup
  params: {
    location: projectResourceGroup.location
    projectName: projectName
    neonConnectionString: neonConnectionString
  }
}

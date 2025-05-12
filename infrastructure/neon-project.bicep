targetScope = 'subscription'

param organizationName string = 'net-applications-on-azure'
param projectName string

var projectResourceGroupName = 'rg-neon-${organizationName}' 

resource projectResourceGroup 'Microsoft.Resources/resourceGroups@2024-11-01' existing = {
  name: projectResourceGroupName
}

module projectResourceGroupModule 'neon-project-rg.bicep' = {
  name: 'neon-project-rg'
  scope: projectResourceGroup
  params: {
    organizationName: organizationName
    projectName: projectName
    location: projectResourceGroup.location
  }
}

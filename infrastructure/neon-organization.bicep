targetScope = 'subscription'

@secure()
param userPrincipalName string
param location string = 'westus3'
param organizationName string = 'net-applications-on-azure'

var projectResourceGroupName = 'rg-neon-${organizationName}' 

resource projectResourceGroup 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: projectResourceGroupName
  location: location
}

module projectResourceGroupModule 'neon-organization-rg.bicep' = {
  name: 'neon-organization-rg'
  scope: projectResourceGroup
  params: {
    organizationName: organizationName
    userPrincipalName: userPrincipalName
    location: projectResourceGroup.location
  }
}

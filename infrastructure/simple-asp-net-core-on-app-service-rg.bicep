targetScope = 'resourceGroup'

param location string = resourceGroup().location
param projectName string
@secure()
param neonConnectionString string 

var projectKeyVaultName = 'kv-${uniqueString(resourceGroup().id)}'

resource projectKeyVault 'Microsoft.KeyVault/vaults@2024-11-01' = {
  name: projectKeyVaultName
  location: location
  properties: {
    createMode: 'default'
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enablePurgeProtection: null
    enableRbacAuthorization: true
    enableSoftDelete: false
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: subscription().tenantId
  }

  resource neonConnectionStringSecret 'secrets' = {
    name: 'neon-connection-string'
    properties: {
      value: neonConnectionString
    }
  }
}

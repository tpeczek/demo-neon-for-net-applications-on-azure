targetScope = 'resourceGroup'

param location string = resourceGroup().location
param projectName string
@secure()
param neonConnectionString string 

var projectKeyVaultName = 'kv-${uniqueString(resourceGroup().id)}'
var projectAppServiceName = 'app-${length(projectName) > 56 ? substring(projectName, 0, 56) : projectName}'
var projectAppServicePlanSku = 'F1'
var projectAppServicePlanName = 'asp-${length(projectName) > 36 ? substring(projectName, 0, 36) : projectName}'
var projectManagedIdentityName = 'id-${projectName}'
var projectContainerRegistryName = 'cr${length(replace(projectName, '-', '')) > 48 ? substring(replace(projectName, '-', ''), 0, 48) : replace(projectName, '-', '')}'

resource projectManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: projectManagedIdentityName
  location: location
}

resource projectKeyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
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

resource keyVaultSecretsUserRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '4633458b-17de-408a-b874-0445c86b69e6' // Key Vault Secrets User
  scope: subscription()
}

resource keyVaultSecretsUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: projectKeyVault
  name: guid(projectKeyVault.id, projectManagedIdentity.id, keyVaultSecretsUserRoleDefinition.id)
  properties: {
    roleDefinitionId: keyVaultSecretsUserRoleDefinition.id
    principalId: projectManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource projectContainerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: projectContainerRegistryName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: false
  }
}

resource acrPullRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '7f951dda-4ed3-4680-a7ca-43fe172d538d' // AcrPull
  scope: subscription()
}

resource acrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: projectContainerRegistry
  name: guid(projectContainerRegistry.id, projectManagedIdentity.id, acrPullRoleDefinition.id)
  properties: {
    roleDefinitionId: acrPullRoleDefinition.id
    principalId: projectManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource projectAppServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: projectAppServicePlanName
  location: location
  sku: {
    name: projectAppServicePlanSku
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource projectAppService 'Microsoft.Web/sites@2024-04-01' = {
  name: projectAppServiceName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${projectManagedIdentity.id}': {}
    }
  }
  properties: {
    serverFarmId: projectAppServicePlan.id
    siteConfig: {
      acrUseManagedIdentityCreds: true
      acrUserManagedIdentityID: projectManagedIdentity.properties.clientId
      appSettings: [
        {
          name: 'WEBSITES_PORT'
          value: '8080'
        }
      ]
    }
  }
}

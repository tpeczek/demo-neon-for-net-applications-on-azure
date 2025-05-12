targetScope = 'resourceGroup'

param organizationName string
param projectName string
param location string = resourceGroup().location

resource neonOrganization 'Neon.Postgres/organizations@2025-03-01' existing = {
  name: 'neon-${organizationName}'
}

resource neonProject 'Neon.Postgres/organizations/projects@2025-03-01' = {
  name: projectName
  parent: neonOrganization
  properties: {
    regionId: location
    pgVersion: 17
  }
}

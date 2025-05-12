targetScope = 'resourceGroup'

param organizationName string
@secure()
param userPrincipalName string
param location string = resourceGroup().location

resource neonOrganization 'Neon.Postgres/organizations@2025-03-01' = {
  name: 'neon-${organizationName}'
  location: location
  properties: {
    companyDetails: { }
    marketplaceDetails: {
      subscriptionId: subscription().id
      offerDetails: {
        publisherId: 'neon1722366567200'
        offerId: 'neon_serverless_postgres_azure_prod'
        planId: 'neon_serverless_postgres_azure_prod_free'
        termUnit: 'P1M'
        termId: 'gmz7xq9ge3py'
      }
    }
    partnerOrganizationProperties: {
      organizationName: organizationName
    }
    userDetails: {
      upn: userPrincipalName
    }
  }
}

# Exploring Neon as a Serverless Postgres Alternative for .NET Applications on Azure

Sample projects that explore Neon as a serverless Postgres alternative for .NET applications on Azure.

## Running the Projects

To run any project in this repository, you can follow the steps below.

1. Fork the repository 😉.
2. [Configure a federated identity credential in Azure](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure-openid-connect) and set the `AZURE_CLIENT_ID`, `AZURE_SUBSCRIPTION_ID`, and `AZURE_TENANT_ID` GitHub Actions secrets, so that the GitHub Actions workflows can authenticate to Azure.
3. Set the `AZURE_UPN` GitHub Actions secret to the email address of the `Entra ID user` who will be the administrator creating a Neon organization. 
4. Run the `01. Deploy Neon Organization as an Azure Native ISV Service` GitHub Actions workflow, which will deploy a Neon organization as an Azure Native ISV Service.
5. Navigate to the created Neon organization resource in Azure Portal, go to the Overview blade, and click on the link that leads to the Neon Console. In the Neon Console, create an [API key](https://neon.tech/docs/manage/api-keys) and set the `NEON_API_KEY` GitHub Actions secret.
6. [Create a GitHub personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) with `Write access to secrets` for the repository and set the `REPOSITORY_SECRETS_PAT` GitHub Actions secret.
7. Run the `02. Create Neon Project` GitHub Actions workflow, which will create a Neon project with a database for a selected project.
8. Run the GitHub Actions workflow to deploy the selected project.

## Donating

My blog and open source projects are result of my passion for software development, but they require a fair amount of my personal time. If you got value from any of the content I create, then I would appreciate your support by [sponsoring me](https://github.com/sponsors/tpeczek) (either monthly or one-time).

## Copyright and License

Copyright © 2025 Tomasz Pęczek

Licensed under the [MIT License](https://github.com/tpeczek/demo-neon-for-net-applications-on-azure/blob/master/LICENSE.md)

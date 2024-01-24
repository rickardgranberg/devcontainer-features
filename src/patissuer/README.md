
# PAT Issuer (patissuer)

Installs the Azure DevOps Personal Access Token Issuer

## Example Usage

```json
"features": {
    "ghcr.io/rickardgranberg/devcontainer-features/patissuer:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select or enter a patissuer version | string | 0.2.1 |
| aadTenantID | Select or enter the AAD Tenant ID | string | common |
| aadClientID | Select or enter the AAD Client ID | string | - |
| azdoOrganization | Enter the name of your Azure DevOps organization | string | org |
| azdoProject | Enter the name of your Azure DevOps project | string | project |
| azdoFqdn | Enter the fqdn of Azure DevOps | string | dev.azure.com |
| azdoNpmArtifactFeed | Enter the name of the AzDO NPM Artifact feed. This will lead to a .npmrc being created. Mostly useful for NPM repos | string | - |
| gitAlias | Enter the desired git alias. This will be added as an 'insteadOf' in the git config. Mostly useful for Golang repos | string | - |
| tokenScope | Select or enter the AzDO PAT Scope(s) | string | vso.code |
| tokenVariable | Select or enter the PAT Token env variable name | string | PAT_TOKEN |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/rickardgranberg/devcontainer-features/blob/main/src/patissuer/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._

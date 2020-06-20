# Module : terraform-github-cicd-bootstrap
This [**Terraform**](https://www.terraform.io/) module build a basic [**GitHub**](https://github.com/) repository to use **Terraform** **GitHub Actions** for Terraform **Cloud/Enterprise** projects.

A **backend** to connect to enable **Terraform** Cloud/Enterprise state management is created.



## How to use

You can use this module with Terraform **OSS** or Terraform **Cloud**/**Enterprise** to create your repository.

Just import the module and set required variables :  

```typescript
module "cicd_bootstrap" {
  source = "recarnot/cicd-bootstrap/github"

  github_token        = "GITHUB_TOKEN_HERE"
  github_organization = "GITHUB_ORGANIZATION_HERE"
  repository_name     = "REPOSITORY_NAME"
  secret_tfc_token    = "TF_TOKEN_HERE"
}
```



Or in full version : 

```typescript
module "cicd_bootstrap" {
  source = "recarnot/cicd-bootstrap/github"

  github_token        = "GITHUB_TOKEN_HERE"
  github_organization = "GITHUB_ORGANIZATION_HERE"
  repository_name     = "REPOSITORY_NAME"
  secret_tfc_token    = "TF_TOKEN_HERE"

  homepage_url  = "https://www.example.com"
  has_issues    = true
  has_projects  = true
  has_wiki      = true
  has_downloads = true
}
```



## Managed resources

This module creates : 

- A GitHub repository
- A GitHub secret for Terraform Token
- Push some files into repository to define GitHub Actions : 
  - "*scripts*" folder with some useful shell scripts
  - "*terraform_deploy.yml*" for GitHub Actions 



## And after...

Just edit the "*terraform_deploy.yml*" file to customize your workflow.

Mostly the variables : 

- TFE_ORGANIZATION
- TFE_WORKSPACE_NAME

You can add variable to workspace using the "*Creates TFC Workspace variables*" step.



```yaml
name: 'Terraform'

on:
  push:
    branches:
      - master
  pull_request:

jobs:
  terraform-deploy:
    name: 'Terraform deploy'
    runs-on: ubuntu-latest

    env:
      TFE_TOKEN: ${{ secrets.TF_API_TOKEN }}
      TFE_ORGANIZATION: "YOUR_TFC_ORGANIZATION_HERE"
      TFE_WORKSPACE_NAME: "YOUR_TFC_WORKSPACE_HERE"
      TFE_WORKSPACE_ID: ""

    steps:
      - name: Checkout sources
        uses: actions/checkout@v2

      - name: Setup Terraform CLI
        uses: hashicorp/setup-terraform@v1
        with:
          cli_config_credentials_token: ${{ secrets.TF_API_TOKEN }}

      - name: Setup TFC Workspace
        run: |
          chmod +x ./scripts/setupWorkspace.sh && ./scripts/setupWorkspace.sh

      - name: Creates TFC Workspace variables
        run: |
          chmod +x ./scripts/createVariable.sh
          #plain variable ./scripts/createVariable.sh "VAR_NAME" "VAR_VALUE" false
          #secured variable ./scripts/createVariable.sh "VAR_NAME" "VAR_VALUE" true

      - name: Terraform Init
        run: terraform init -no-color

      - name: Terraform fmt
        run: terraform fmt -no-color

      - name: Terraform Plan
        id: plan
        run: terraform plan -no-color

      - name: Terraform Apply
        if: github.ref == 'refs/heads/master' && github.event_name == 'push'
        run: terraform apply -auto-approve -no-color
```


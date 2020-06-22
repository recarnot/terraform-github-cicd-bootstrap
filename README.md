# Module : terraform-github-cicd-bootstrap
This [**Terraform**](https://www.terraform.io/) module build a basic [**GitHub**](https://github.com/) repository to use **Terraform** **GitHub Actions** for Terraform **Cloud/Enterprise** projects.

A **backend** to connect to enable **Terraform** Cloud/Enterprise state management is created.

Static security check can be added in workflow using GitHub Actions for [Checkov](https://www.checkov.io/) or [Bridgecrew](https://www.bridgecrew.cloud/) solutions.



## How to use

You can use this module with Terraform **OSS** or Terraform **Cloud**/**Enterprise** to create and configure your new GitHub repository.

Just import the module and set variables :  

```typescript
module "cicd_bootstrap" {
  source = "recarnot/cicd-bootstrap/github"

  github_token        = "GITHUB_TOKEN_HERE"
  github_organization = "GITHUB_ORGANIZATION_HERE"
  
  repository_name     = "my-new-repo"
  
  tf_organization = "my-tf-organization"
  tf_token        = "TF_TOKEN_HERE"
  tf_workspace    = "my-target-workspace"
}
```



## Security check

Add static security check using Open Source [Checkov](https://www.checkov.io/) :

```typescript
module "cicd_bootstrap" {
  source = "recarnot/cicd-bootstrap/github"

  github_token        = "GITHUB_TOKEN_HERE"
  github_organization = "GITHUB_ORGANIZATION_HERE"
  
  repository_name     = "REPOSITORY_NAME"
    
  tf_organization = "my-tf-organization"
  tf_token        = "TF_TOKEN_HERE"
  tf_workspace    = "my-target-workspace"
    
  security_check = true
}
```

Or with [Bridgecrew](https://www.bridgecrew.cloud/) :
```typescript
module "cicd_bootstrap" {
  source = "recarnot/cicd-bootstrap/github"

  github_token        = "GITHUB_TOKEN_HERE"
  github_organization = "GITHUB_ORGANIZATION_HERE"
  
  repository_name     = "REPOSITORY_NAME"
  
  tf_organization = "my-tf-organization"
  tf_token        = "TF_TOKEN_HERE"
  tf_workspace    = "my-target-workspace"
    
  security_check            = true
  security_bridgecrew_token = "BC_TOKEN_HERE"
}
```




## Managed resources

This module creates : 

- A GitHub repository
- GitHub secrets for Terraform Token, Bridgecrew token, ...
- Push some files into repository to define GitHub Actions : 
  - "*scripts*" folder with some useful shell scripts
  - "*terraform_deploy.yml*" for GitHub Actions 
  - An empty Terraform configuration file to start



## And after...

Just edit the "*terraform_deploy.yml*" file to customize your workflow.

For example you can add variables to workspace using the "*Creates TFC Workspace variables*" step.

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
      TF_TOKEN: ${{ secrets.TF_API_TOKEN }}
      TF_ORGANIZATION: "YOUR_TFC_ORGANIZATION_HERE"
      TF_WORKSPACE_NAME: "YOUR_TFC_WORKSPACE_HERE"
      TF_WORKSPACE_ID: ""

    steps:
      - name: Checkout sources
        uses: actions/checkout@v2

      - name: Setup Terraform CLI
        uses: hashicorp/setup-terraform@v1
        with:
          cli_config_credentials_token: ${{ secrets.TF_API_TOKEN }}

      - name: Setup Workspace
        run: |
          chmod +x ./scripts/setupWorkspace.sh && ./scripts/setupWorkspace.sh

      - name: Create variables
        run: |
          chmod +x ./scripts/createVariable.sh
          #plain variable ./scripts/createVariable.sh "VAR_NAME" "VAR_VALUE" false
          #secured variable ./scripts/createVariable.sh "VAR_NAME" "VAR_VALUE" true

      - name: Terraform init
        run: terraform init -no-color

      - name: Terraform validate
        run: terraform validate -no-color

      - name: Terraform plan
        id: plan
        run: terraform plan -no-color

      - name: Terraform apply
        if: github.ref == 'refs/heads/master' && github.event_name == 'push'
        run: terraform apply -auto-approve -no-color
```


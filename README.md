# Module : terraform-github-cicd-bootstrap

<p align="left">
  <a href="https://github.com/recarnot/terraform-github-cicd-bootstrap/actions"><img alt="Plan check" src="https://github.com/recarnot/terraform-github-cicd-bootstrap/workflows/Plan%20check/badge.svg" /></a>
  <a href="https://github.com/recarnot/terraform-github-cicd-bootstrap/actions"><img alt="Security check" src="https://github.com/recarnot/terraform-github-cicd-bootstrap/workflows/Security%20check/badge.svg" /></a>
</p>

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
jobs:
  terraform-deploy:
    name: 'Terraform deploy'
    runs-on: ubuntu-latest

    steps:
      - name: Checkout sources
        uses: actions/checkout@v2
      
      - name: Static security check with Checkov
        id: Checkov
        uses: bridgecrewio/checkov-action@master
        
      - name: Setup Terraform CLI
        uses: hashicorp/setup-terraform@v1
        with:
          cli_config_credentials_token: ${{ secrets.TF_API_TOKEN }}

      - name: Setup Terraform Workspace
        uses: recarnot/terraform-github-workspace-setup-action@master
        with:
          organization: "my-organization"
          workspace: "my-workspace"
          token: ${{ secrets.TF_API_TOKEN }}
          vars: '
            {
              "key": "region",
              "value": "eu-west-3",
              "sensitive": "false"
            },
            {
              "key": "access_id",
              "value": "${{ secrets.ACCESS_ID }}",
              "sensitive": "true"
            },
            {
              "key": "secret_key",
              "value": "${{ secrets.SECRET_KEY }}",
              "sensitive": "true"
            }'

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
        
      - name: Terraform doc
        uses: Dirrk/terraform-docs@master
        with:
          tf_docs_output_file: USAGE.md
          tf_docs_output_method: replace
          tf_docs_git_commit_message: "Documentation updated"
          tf_docs_git_push: true
```


# Module : terraform-github-cicd-bootstrap
This [**Terraform**](https://www.terraform.io/) module build a basic [**GitHub**](https://github.com/) repository to use **Terraform** **GitHub Actions** for Terraform **Cloud/Enterprise** projects.



## How to use

You can use this module with Terraform **OSS** or Terraform **Cloud**/**Enterprise** to create your repository.

Just import the module and set required variables :  

```typescript
module "cicd_bootstrap" {
  source = "app.terraform.io/terraform-deepdive/cicd-bootstrap/github"

  github_token        = "GITHUB_TOKEN_HERE"
  github_organization = "GITHUB_ORGANIZATION_HERE"
  repository_name     = "REPOSITORY_NAME"
  secret_tfc_token    = "TF_TOKEN_HERE"
}
```


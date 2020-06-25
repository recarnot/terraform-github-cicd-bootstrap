variable "github_token" {
  description = "GitHub token"
  type = string
}

module "bootstrap" {
  source = "../"

  github_token        = var.github_token
  github_organization = "recarnot"

  repository_name = "my-new-repo-on-github"

  tf_organization = "my-tf-organization"
  tf_token        = "my-tf-token"
  tf_workspace    = "my-tf-workspace"

  security_check  = true
}
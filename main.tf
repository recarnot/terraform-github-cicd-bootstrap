#Creates a new GitHub repository
resource "github_repository" "project" {
  name          = var.repository_name
  description   = var.repository_description
  private       = var.repository_private
  auto_init     = true
  homepage_url  = var.repository_homepage_url
  has_issues    = var.repository_has_issues
  has_projects  = var.repository_has_projects
  has_wiki      = var.repository_has_wiki
  has_downloads = var.repository_has_downloads

  topics = ["cicd", "terraform", "github", "github-actions"]
}

#Creates GitHub secret to store Terraform Cloud/Enterprise API token
resource "github_actions_secret" "tf_token" {
  repository      = github_repository.project.name
  secret_name     = "TF_API_TOKEN"
  plaintext_value = var.tf_token
}

#Creates GitHub secret to store Terraform hostname
resource "github_actions_secret" "tf_host" {
  repository      = github_repository.project.name
  secret_name     = "TF_HOSTNAME"
  plaintext_value = var.tf_hostname
}

#Creates GitHub secret to store Bridgecrew API token if enabed
resource "github_actions_secret" "bc_token" {
  count = length(var.security_bridgecrew_token) > 0 && var.security_check ? 1 : 0

  repository      = github_repository.project.name
  secret_name     = "BC_API_TOKEN"
  plaintext_value = var.security_bridgecrew_token
}

#Push backend file
resource "github_repository_file" "backend" {
  repository = github_repository.project.name
  file       = "backend.tf"

  content = templatefile("${path.module}/template/backend.tpl",
    {
      TF_HOSTNAME : var.tf_hostname,
      TF_ORGANIZATION : var.tf_organization,
      TF_WORKSPACE : var.tf_workspace
    }
  )
}

#Push an empty Terraform configuration file after script files
resource "github_repository_file" "empty" {
  repository = github_repository.project.name
  file       = "main.tf"
  content    = file("${path.module}/template/empty.tpl")

  depends_on = [github_repository_file.backend]
}

locals {
  checkov_step    = file("${path.module}/template/checkov.tpl")
  bridgecrew_step = file("${path.module}/template/bridgecrew.tpl")
  security_step   = var.security_check ? length(var.security_bridgecrew_token) > 0 ? local.bridgecrew_step : local.checkov_step : ""
}

#And then push the GitHub workflow file
resource "github_repository_file" "workflow" {
  count = var.auto_deploy_workflow ? 1 : 0

  repository = github_repository.project.name
  file       = ".github/workflows/terraform_deploy.yml"

  content = templatefile("${path.module}/template/terraform_deploy.yml",
    {
      SECURITY_CHECK_STEP : local.security_step,
      TF_ORGANIZATION : var.tf_organization,
      TF_WORKSPACE : var.tf_workspace
    }
  )

  depends_on = [github_repository_file.empty]
}


#Creates a new GitHub repository
resource "github_repository" "project" {
  name          = var.repository_name
  description   = var.repository_description
  private       = var.repository_private
  auto_init     = true
  homepage_url  = var.homepage_url
  has_issues    = var.has_issues
  has_projects  = var.has_projects
  has_wiki      = var.has_wiki
  has_downloads = var.has_downloads

  topics = ["cicd", "terraform", "github", "github-actions"]
}

#Creates GitHub secret to store Terraform Cloud/Enterprise API token
resource "github_actions_secret" "tfc_token" {
  repository      = github_repository.project.name
  secret_name     = "TF_API_TOKEN"
  plaintext_value = var.secret_tfc_token
}

#Creates GitHub secret to store Bridgecrew API token if enabed
resource "github_actions_secret" "bc_token" {
  count = length(var.secret_bc_token) > 0 && var.security_check ? 1 : 0

  repository      = github_repository.project.name
  secret_name     = "BC_API_TOKEN"
  plaintext_value = var.secret_bc_token
}

#List all script files to push
locals {
  scripts = [
    "backend.template",
    "createVariable.sh",
    "setupWorkspace.sh",
    "variable.payload.template",
    "workspace.payload.template"
  ]
}

#Push all scripts files
resource "github_repository_file" "scripts" {
  for_each = toset(local.scripts)

  repository = github_repository.project.name
  file       = "scripts/${each.value}"
  content    = file("${path.module}/scripts/${each.value}")
}

#Push an empty Terraform configuration file after script files
resource "github_repository_file" "empty" {
  repository = github_repository.project.name
  file       = "main.tf"
  content    = file("${path.module}/template/empty.template")

  depends_on = [github_repository_file.scripts]
}

locals {
  checkov_step = file("${path.module}/template/checkov.tpl")
  bridgecrew_step = file("${path.module}/template/bridgecrew.tpl")
  security_step = var.security_check ? length(var.secret_bc_token) > 0 ? local.bridgecrew_step : local.checkov_step : ""
}

#And then push the GitHub workflow file
resource "github_repository_file" "workflow" {
  repository = github_repository.project.name
  file       = ".github/workflows/terraform_deploy.yml"
  #content    = file("${path.module}/template/terraform_deploy.yml")
  content = templatefile("${path.module}/template/terraform_deploy.yml", {SECURITY_CHECK_STEP: local.security_step} )

  depends_on = [github_repository_file.empty]
}


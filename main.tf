resource "github_repository" "project" {
  name        = var.repository_name
  description = var.repository_description
  private     = var.repository_private
  auto_init   = true

  homepage_url  = ""
  has_issues    = true
  has_projects  = false
  has_wiki      = false
  has_downloads = false
  topics        = ["cicd", "terraform", "github", "github-actions"]
}

resource "github_actions_secret" "tfc_token" {
  repository      = github_repository.project.name
  secret_name     = "tfc_token"
  plaintext_value = var.secret_tfc_token
}

resource "github_repository_file" "workflow" {
  repository = github_repository.project.name
  file       = ".github/workflows/terraform_deploy.yml"
  content    = file("${path.module}/template/terraform_deploy.yml")
}

locals {
  scripts = [
    "backend.template",
    "createVariable.sh",
    "setupWorkspace.sh",
    "variable.payload.template",
    "workspace.payload.template"
  ]
}

resource "github_repository_file" "scripts" {
  for_each = toset(local.scripts)

  repository = github_repository.project.name
  file       = "scripts/${each.value}"
  content    = file("${path.module}/scripts/${each.value}")
}

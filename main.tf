resource "github_repository" "project" {
  name        = var.repository_name
  description = var.repository_description
  private     = var.repository_private
  auto_init   = true
  homepage_url  = var.homepage_url
  has_issues    = var.has_issues
  has_projects  = var.has_projects
  has_wiki      = var.has_wiki
  has_downloads = var.has_downloads

  topics        = ["cicd", "terraform", "github", "github-actions"]
}

resource "github_actions_secret" "tfc_token" {
  repository      = github_repository.project.name
  secret_name     = "TF_API_TOKEN"
  plaintext_value = var.secret_tfc_token
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

resource "github_repository_file" "workflow" {
  repository = github_repository.project.name
  file       = ".github/workflows/terraform_deploy.yml"
  content    = file("${path.module}/template/terraform_deploy.yml")

  depends_on = [github_repository_file.scripts]
}


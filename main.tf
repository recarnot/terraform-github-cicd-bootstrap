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

locals {
  files = {
    workflow = {
      source : "template/terraform_deploy.yml"
      target : ".github/workflows/terraform_deploy.yml"
    }

    backend = {
      source : "scripts/backend.template"
      target : "scripts/backend.template"
    }
  }
}

resource "github_repository_file" "workflow" {
  for_each = local.files

  repository = github_repository.project.name
  file       = each.value.target
  content    = file("${path.module}/${each.value.source}")
}

/*
resource "github_repository_file" "backend_template" {
  repository = github_repository.project.name
  file       = "scripts/backend.template"
  content    = file("${path.module}/scripts/backend.template")
}
*/
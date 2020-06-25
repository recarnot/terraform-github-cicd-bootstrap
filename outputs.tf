output "repository_name" {
  description = "Name of the repository."
  value       = github_repository.project.name
}

output "repository_fullname" {
  description = "A string of the form 'orgname/reponame'."
  value       = github_repository.project.full_name
}

output "repository_http_clone_url" {
  description = "URL that can be provided to git clone to clone the repository via HTTPS."
  value       = github_repository.project.http_clone_url
}

output "repository_ssh_clone_url" {
  description = "URL that can be provided to git clone to clone the repository via SSH."
  value       = github_repository.project.ssh_clone_url
}

output "tf_organization" {
  description = "Terraform organization"
  value       = var.tf_organization
}

output "tf_workspace" {
  description = "Terraform workspace"
  value       = var.tf_workspace
}

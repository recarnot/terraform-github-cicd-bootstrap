output "fullname" {
  description = "A string of the form 'orgname/reponame'."
  value       = github_repository.project.full_name
}

output "http_clone_url" {
  description = "URL that can be provided to git clone to clone the repository via HTTPS."
  value       = github_repository.project.http_clone_url
}

output "ssh_clone_url" {
  description = "URL that can be provided to git clone to clone the repository via SSH."
  value       = github_repository.project.ssh_clone_url
}
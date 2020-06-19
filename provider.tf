variable "github_token" {
  default = "This is the GitHub personal access token."
  type    = string
}

variable "github_organization" {
  description = "This is the target GitHub organization to manage. The account corresponding to the token will need 'owner' privileges for this organization."
  type        = string
}

provider "github" {
  token        = var.github_token
  organization = var.github_organization
}
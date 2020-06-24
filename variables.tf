variable "tf_organization" {
  description = "Terraform Cloud/Enterprise organization to use."
  type        = string
}

variable "tf_token" {
  description = "Terraform Cloud API token where to deploy"
  type        = string
}

variable "tf_workspace" {
  description = "Terraform workspace to use."
  type        = string
}

variable "tf_hostname" {
  description = "Terraform hostname."
  type        = string
  default     = "app.terraform.io"
}

variable "security_check" {
  description = "(Optional) Set to true to use static security check. If true and 'secret_bc_token' is not set, we use Checkov engine otherwise use Bridgecrew one. Default false"
  type        = bool
  default     = false
}

variable "security_bridgecrew_token" {
  description = "(Optional) Bridgecrew API token"
  type        = string
  default     = ""
}

variable "repository_name" {
  description = "The name of the repository."
  type        = string
}

variable "repository_description" {
  description = "A description of the repository."
  type        = string
  default     = ""
}

variable "repository_private" {
  description = "Set to true to create a private repository."
  type        = bool
  default     = true
}

variable "repository_homepage_url" {
  description = "(Optional) URL of a page describing the project."
  default     = ""
}

variable "repository_has_issues" {
  description = "Optional) Set to true to enable the GitHub Issues features on the repository. Default false"
  type        = bool
  default     = false
}

variable "repository_has_projects" {
  description = "(Optional) Set to true to enable the GitHub Projects features on the repository. Default false"
  type        = bool
  default     = false
}

variable "repository_has_wiki" {
  description = "(Optional) Set to true to enable the GitHub Wiki features on the repository. Default false"
  type        = bool
  default     = false
}

variable "repository_has_downloads" {
  description = "(Optional) Set to true to enable the (deprecated) downloads features on the repository. Default false"
  type        = bool
  default     = false
}
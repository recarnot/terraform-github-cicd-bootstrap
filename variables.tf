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

variable "secret_tfc_token" {
  description = "Terraform Cloud Token"
  type        = string
}

variable "homepage_url" {
  description = "(Optional) URL of a page describing the project."
  default     = ""
}

variable "has_issues" {
  description = "Optional) Set to true to enable the GitHub Issues features on the repository. Default false"
  type        = bool
  default     = false
}

variable "has_projects" {
  description = "(Optional) Set to true to enable the GitHub Projects features on the repository. Default false"
  type        = bool
  default     = false
}

variable "has_wiki" {
  description = "(Optional) Set to true to enable the GitHub Wiki features on the repository. Default false"
  type        = bool
  default     = false
}

variable "has_downloads" {
  description = "(Optional) Set to true to enable the (deprecated) downloads features on the repository. Default false"
  type        = bool
  default     = false
}
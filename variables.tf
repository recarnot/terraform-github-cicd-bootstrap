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
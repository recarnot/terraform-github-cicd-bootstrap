terraform {
  backend "remote" {
    organization = "TF_ORGANIZATION"

    workspaces {
      name = "TF_WORKSPACE"
    }
  }
}
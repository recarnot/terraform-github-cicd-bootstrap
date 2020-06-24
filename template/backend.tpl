terraform {
  backend "remote" {
    hostname     = "${TF_HOSTNAME}"
    organization = "${TF_ORGANIZATION}"

    workspaces {
      name = "${TF_WORKSPACE}"
    }
  }
}
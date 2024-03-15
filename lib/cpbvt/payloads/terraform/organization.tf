terraform {
  backend "remote" {
    organization = "${UserOrgName}"
    workspaces {
      name = "${UserWorkspaceName}"
    }
  }
}
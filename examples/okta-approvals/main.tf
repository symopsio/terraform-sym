provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

module "okta_approvals" {
  source                   = "../../modules/okta-approvals"
  account_id               = data.aws_caller_identity.current.account_id
  app                      = var.app
  authroles                = var.authroles
  external_id              = var.external_id
  okta_application_id      = var.okta_application_id
  okta_org_url             = var.okta_org_url
  region                   = var.aws_region
  resources                = var.resources
  role_assignment_strategy = var.role_assignment_strategy
}

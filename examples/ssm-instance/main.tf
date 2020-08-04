terraform {
  required_version = ">= 0.12.7"
}

provider "aws" {
  version = "~> 2.0"
  region  = var.aws_region
}

data "aws_caller_identity" "current" { }

module "lambda_approvals" {
  source                   = "../../modules/lambda-approvals"
  account_id               = data.aws_caller_identity.current.account_id
  app                      = var.app
  external_id              = var.external_id
  region                   = var.aws_region
  resources                = var.resources
  role_assignment_strategy = var.role_assignment_strategy
  okta_application_id      = var.okta_application_id
  okta_org_url             = var.okta_org_url
}

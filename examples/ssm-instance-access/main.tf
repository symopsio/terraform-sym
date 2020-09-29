terraform {
  required_version = ">= 0.12.7"
}

provider "aws" {
  version = "~> 2.0"
  region  = var.aws_region
}

module "ssm_user_access" {
  source                = "../../modules/ssm-instance-access"
  policy_name           = var.app
}

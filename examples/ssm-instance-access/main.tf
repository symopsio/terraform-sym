terraform {
  required_version = ">= 0.12.7"
}

provider "aws" {
  version = "~> 2.0"
  region  = var.aws_region
}

data "aws_caller_identity" "current" {}

module "ssm_instance_access" {
  source                = "../../modules/ssm-instance-access"
  ansible_bucket_name   = "sym-ansible-${data.aws_caller_identity.current.account_id}"
  policy_name           = var.app
}

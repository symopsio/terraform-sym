terraform {
  required_version = ">= 0.12.7"
}

provider "aws" {
  version = "~> 2.0"
  region  = var.aws_region
}

data "aws_caller_identity" "current" { }

module "ssm_user_access" {
  source                = "../../modules/ssm-user-access"
  ansible_bucket_name   = "sym-ansible-*"
  policy_name           = var.app
  instance_tag_options  = var.instance_tag_options
}

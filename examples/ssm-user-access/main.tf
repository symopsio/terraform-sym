provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

module "ssm_user_access" {
  source               = "../../modules/ssm-user-access"
  ansible_bucket_name  = "sym-ansible-*"
  policy_name          = var.app
  instance_tag_options = var.instance_tag_options
}

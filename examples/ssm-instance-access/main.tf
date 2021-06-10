provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

module "ssm_instance_access" {
  source              = "../../modules/ssm-instance-access"
  ansible_bucket_name = "sym-ansible-${data.aws_caller_identity.current.account_id}"
  policy_name         = var.app
}

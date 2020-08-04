terraform {
  required_version = ">= 0.12.7"
}

provider "aws" {
  version = "~> 2.0"
  region  = var.aws_region
}

data "aws_caller_identity" "current" { }

# Let principals from the calling user's account ID assume roles
data "aws_iam_policy_document" "current_account_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

resource "aws_iam_role" "staging_ssm_role" {
  name               = "${var.app}-staging"
  assume_role_policy = data.aws_iam_policy_document.current_account_assume_role.json
}

module "staging_user_access" {
  source      = "../../modules/ssm-user-access"
  tag_key     = "Environment"
  tag_value   = "staging"
  policy_name = "${var.app}-user-staging"
}


resource "aws_iam_role_policy_attachment" "staging_ssm_user_attach" {
  role       = aws_iam_role.staging_ssm_role.name
  policy_arn = module.staging_user_access.policy_arn
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"
    values = [
      "amazon",
    ]
  }
}

module "staging_instance" {
  source      = "../../demo/ec2-instance"
  ami_id      = data.aws_ami.amazon_linux.id
  subnet_id   = var.aws_subnet_id
}

module "staging_instance_access" {
  source      = "../../modules/ssm-instance-access"
  policy_name = "${var.app}-instance-access"
}

# Use the standard Amazon SSM policy to let the instances accept SSM sessions
resource "aws_iam_role_policy_attachment" "staging_ssm_instance_attach" {
  role       = module.staging_instance.instance_role_name
  policy_arn = module.staging_instance_access.policy_arn
}


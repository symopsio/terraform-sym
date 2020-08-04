terraform {
  required_version = ">= 0.12.7"
}

provider "aws" {
  version = "~> 3.0"
  region  = var.aws_region
}

data "aws_caller_identity" "current" { }

module "lambda_approvals" {
  source                   = "../../modules/lambda-approvals"
  account_id               = data.aws_caller_identity.current.account_id
  app                      = var.app
  filename                 = "${path.root}/../../modules/lambda-approvals/lambda/dist/sym-okta-golang-approvals.zip"
  group_map                = var.group_map
  region                   = var.aws_region
  resource_ids             = var.resource_ids
  role_assignment_strategy = var.role_assignment_strategy
  role_map                 = var.role_map
  okta_application_id      = var.okta_application_id
  okta_org_url             = var.okta_org_url
}

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

module "staging_access" {
  source      = "../../modules/ssm-access"
  tag_key     = "Environment"
  tag_value   = "staging"
  policy_name = "${var.app}-staging"
}


resource "aws_iam_role_policy_attachment" "staging_ssm_user_attach" {
  role       = aws_iam_role.staging_ssm_role.name
  policy_arn = module.staging_user_policy.policy_arn
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

# Use the standard Amazon SSM policy to let the instances accept SSM sessions
resource "aws_iam_role_policy_attachment" "staging_ssm_instance_attach" {
  role       = module.staging_instance.instance_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


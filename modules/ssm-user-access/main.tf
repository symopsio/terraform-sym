data "aws_iam_policy_document" "conditions" {
  for_each = var.instance_tag_options
  statement {
    effect = "Allow"
    actions = [
      "ssm:StartSession",
      "ssm:SendCommand"
    ]
    resources = [
      "arn:aws:ec2:*:*:instance/*",
    ]
    condition {
      test = "StringLike"
      variable = "ssm:resourceTag/${each.key}"
      values = [ each.value ]
    }
  }
}

locals {
  source_documents = [for k in keys(var.instance_tag_options) : data.aws_iam_policy_document.conditions[k].json]
  trimmed_ansible_path = trim(var.ansible_bucket_path, "/")
  full_ansible_path = local.trimmed_ansible_path == "" ? "/*" : "/${local.trimmed_ansible_path}/*"
}

module "policy_aggregator" {
  source           = "github.com/cloudposse/terraform-aws-iam-policy-document-aggregator"
  source_documents = local.source_documents
}

data "aws_iam_policy_document" "ssm_user" {
  source_json = module.policy_aggregator.result_document
  statement {
    effect = "Allow"
    actions = [
      "ssm:SendCommand",
      "ssm:StartSession"
    ]
    resources = [
      "arn:aws:ssm:*:*:document/AWS-*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ssm:DescribeInstanceProperties",
      "ssm:DescribeSessions",
      "ssm:GetConnectionStatus",
      "ssm:GetCommandInvocation",
      "ssm:ListCommands",
      "ssm:ListCommandInvocations"
    ]
    resources = [ "*" ]
  }
  statement {
    effect = "Allow"
    actions = [ "ssm:TerminateSession" ]
    resources = [ "arn:aws:ssm:*:*:session/*" ]
  }
  statement {
    effect = "Allow"
    actions = [ 
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    resources = [
      "arn:aws:s3:::sym-doctor-*/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      "arn:aws:s3:::${var.ansible_bucket_name}${local.full_ansible_path}",
    ]
  }
}

resource "aws_iam_policy" "ssm_user_policy" {
  name = var.policy_name
  description = "Grants users SSM access to tagged instances"
  policy = data.aws_iam_policy_document.ssm_user.json
}

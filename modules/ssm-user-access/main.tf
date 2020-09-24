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

data "aws_iam_policy_document" "doctor" {
  statement {
    effect = "Allow"
    actions = [ 
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = [ "arn:aws:s3:::sym-doctor-*/*" ]
  }
}

locals {
  condition_policies = [for k in keys(var.instance_tag_options) : data.aws_iam_policy_document.conditions[k].json]
  all_policies = var.enable_sym_doctor ? concat([data.aws_iam_policy_document.doctor.json], local.condition_policies) : local.condition_policies
}

module "policy_aggregator" {
  source           = "github.com/cloudposse/terraform-aws-iam-policy-document-aggregator"
  source_documents = local.all_policies
}

data "aws_iam_policy_document" "ssm_user" {
  source_json = module.policy_aggregator.result_document
  statement {
    effect = "Allow"
    actions = [ "ssm:StartSession" ]
    resources = [
      "arn:aws:ssm:*:*:document/AWS-StartSSHSession"
    ]
  }
  statement {
    effect = "Allow"
    actions = [ "ssm:SendCommand" ]
    resources = [
      "arn:aws:ssm:*:*:document/AWS-RunShellScript"
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
    resources = [ "*" ]
    condition {
      test = "StringLike"
      variable = "ssm:resourceTag/aws:ssmmessages:session-id"
      values = [ "$${aws:userid}" ]
    }
  }
  statement {
    effect = "Allow"
    actions = [ "ssm:TerminateSession" ]
    resources = [ "arn:aws:ssm:*:*:session/$${aws:username}-*" ]
  }
}

resource "aws_iam_policy" "ssm_user_policy" {
  name = var.policy_name
  description = "Grants users SSM access to tagged instances"
  policy = data.aws_iam_policy_document.ssm_user.json
}

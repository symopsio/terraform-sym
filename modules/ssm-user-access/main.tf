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
}

module "policy_aggregator" {
  source           = "github.com/cloudposse/terraform-aws-iam-policy-document-aggregator"
  source_documents = local.source_documents
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
      "ssm:ListCommandInvocations",
      "ssm:TerminateSession"
    ]
    resources = [ "*" ]
  }
}

resource "aws_iam_policy" "ssm_user_policy" {
  name = var.policy_name
  description = "Grants users SSM access to tagged instances"
  policy = data.aws_iam_policy_document.ssm_user.json
}

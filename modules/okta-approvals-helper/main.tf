locals {
  ssm_prefix                 = var.app
  defaults = {
    account_alias = null,
    group_name = null,
    role_name = null
  }
  resources_with_defaults    = {for k, v in var.resources : k => merge(local.defaults, v)}
  role_map_no_aliases        = {for k, v in local.resources_with_defaults : k => v.role_name if v.account_alias == null}
  role_map_with_aliases      = {for k, v in local.resources_with_defaults : k => "[${v.account_alias}] -- ${v.role_name}" if v.account_alias != null}
  env_vars = {
    APPLICATION_ID           = var.okta_application_id
    OKTA_CLIENT_ORGURL       = var.okta_org_url
    SSM_PREFIX               = local.ssm_prefix
    ROLE_ASSIGNMENT_STRATEGY = var.role_assignment_strategy
    GROUP_MAP                = jsonencode({for k, v in local.resources_with_defaults : k => v.group_name if v.group_name != null})
    ROLE_MAP                 = jsonencode(merge(local.role_map_no_aliases, local.role_map_with_aliases))
  }
}

resource "aws_ssm_parameter" "authroles" {
  name  = "/${local.ssm_prefix}/AUTHROLES"
  type  = "String"
  value = jsonencode(var.authroles)
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    effect  = "Allow"
    actions = ["ssm:GetParameter"]
    resources = [
      "arn:aws:ssm:${var.region}:${var.account_id}:parameter/${var.app}/*"
    ]
  }
}

resource "aws_iam_role" "sym_execute" {
  name               = "SymExecute-${var.app}"
  path               = "/sym/"
  assume_role_policy = data.aws_iam_policy_document.sym_execute_assume_role.json
}

data "aws_iam_policy_document" "sym_execute_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.sym_account_id}:root"]
    }
    condition {
      test = "StringEquals"
      variable = "sts:ExternalId"
      values = [ var.external_id ]
    }
  }
}


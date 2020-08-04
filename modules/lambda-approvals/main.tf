locals {
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
    SSM_PREFIX               = var.app
    ROLE_ASSIGNMENT_STRATEGY = var.role_assignment_strategy
    GROUP_MAP                = jsonencode({for k, v in local.resources_with_defaults : k => v.group_name if v.group_name != null})
    ROLE_MAP                 = jsonencode(merge(local.role_map_no_aliases, local.role_map_with_aliases))
  }
}

resource "aws_lambda_function" "approve" {
  function_name = "${var.app}-approve"

  s3_bucket = var.s3_bucket
  s3_key = var.s3_key

  handler = "bin/lambda"
  runtime = "go1.x"

  environment {
    variables = local.env_vars
  }

  role = aws_iam_role.lambda_exec.arn

  lifecycle {
    ignore_changes = [filename]
  }
}

resource "aws_lambda_function" "expire" {
  function_name = "${var.app}-expire"

  s3_bucket = var.s3_bucket
  s3_key = var.s3_key

  handler = "bin/lambda"
  runtime = "go1.x"

  environment {
    variables = local.env_vars
  }

  role = aws_iam_role.lambda_exec.arn

  lifecycle {
    ignore_changes = [filename]
  }
}

resource "aws_iam_role" "lambda_exec" {
  name               = "${var.app}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.app}-lambda"
  description = "${var.app} execution policy"
  policy      = data.aws_iam_policy_document.lambda_policy.json
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/${var.app}*:*"
    ]
  }
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
      variable = "sts.ExternalId"
      values = [ var.external_id ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "sym_execute_policy_attach" {
  role       = aws_iam_role.sym_execute.name
  policy_arn = aws_iam_policy.sym_execute_policy.arn
}

resource "aws_iam_policy" "sym_execute_policy" {
  name        = "SymExecute-${var.app}"
  description = "Sym Cross-Account Invocation for ${var.app}"
  policy      = data.aws_iam_policy_document.sym_execute_policy.json
}

data "aws_iam_policy_document" "sym_execute_policy" {
  statement {
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [
      aws_lambda_function.approve.arn,
      aws_lambda_function.expire.arn
    ]
  }
}

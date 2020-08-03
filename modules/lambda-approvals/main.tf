locals {
  env_vars = merge({
    APPLICATION_ID           = var.okta_application_id
    OKTA_CLIENT_ORGURL       = var.okta_org_url
    RESOURCE_IDS             = join(",", var.resource_ids)
    SSM_PREFIX               = var.app
    ROLE_ASSIGNMENT_STRATEGY = var.role_assignment_strategy
  }, var.group_map, var.role_map)
}

resource "aws_lambda_function" "approve" {
  function_name = "${var.app}-approve"

  filename = var.filename

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

  filename = var.filename

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

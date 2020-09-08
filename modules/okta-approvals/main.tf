module "okta_approvals_helper" {
  source                   = "../okta-approvals-helper"
  account_id               = var.account_id
  app                      = var.app
  authroles                = var.authroles
  external_id              = var.external_id
  okta_application_id      = var.okta_application_id
  okta_org_url             = var.okta_org_url
  region                   = var.region
  resources                = var.resources
  role_assignment_strategy = var.role_assignment_strategy
  sym_account_id           = var.sym_account_id
}

resource "aws_lambda_function" "sym" {
  function_name = var.app

  s3_bucket = var.s3_bucket
  s3_key = var.s3_key

  handler = "bin/okta-approvals"
  runtime = "go1.x"

  environment {
    variables = module.okta_approvals_helper.lambda_env_vars
  }

  role = aws_iam_role.lambda_exec.arn
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

  source_json = module.okta_approvals_helper.lambda_policy.json

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
}

resource "aws_iam_role_policy_attachment" "sym_execute_policy_attach" {
  role       = module.okta_approvals_helper.sym_execute_role_name
  policy_arn = aws_iam_policy.sym_execute_policy.arn
}

resource "aws_iam_policy" "sym_execute_policy" {
  name        = module.okta_approvals_helper.sym_execute_role_name
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
      aws_lambda_function.sym.arn,
    ]
  }
}

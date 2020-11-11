locals {
  ssm_prefix = var.app
}

resource "aws_lambda_function" "sym" {
  function_name = var.app

  s3_bucket = var.s3_bucket
  s3_key = var.s3_key

  handler = "handler.dispatch"
  runtime = "python3.8"

  timeout = var.timeout

  environment {
    variables = {
      "SSM_PREFIX" = local.ssm_prefix
      "READ_TIMEOUT" = max(4, (var.timeout - 1))
    }
  }

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_ssm_parameter" "function_map" {
  name  = "/${local.ssm_prefix}/FUNCTION_MAP"
  type  = "String"
  value = jsonencode(var.function_map)
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.app}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_policy" "lambda_policy" {
  name = "${var.app}-lambda"
  description = "${var.app} execution policy"
  policy = data.aws_iam_policy_document.lambda_policy.json
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
    effect = "Allow"
    actions = [ "ssm:GetParameter" ]
    resources = [
      "arn:aws:ssm:${var.region}:${var.account_id}:parameter/${var.app}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [ "lambda:InvokeFunction" ]
    resources = distinct(values(var.function_map))
  }
}

module "sym_execute" {
  source          = "github.com/symopsio/terraform-sym//modules/sym-lambda-execute?ref=133e2e8"

  app             = var.app
  lambda_arns     = [ aws_lambda_function.sym.arn ]
  sym_account_id  = var.sym_account_id
}

locals {
  env_vars = merge( {
    APPLICATION_ID = var.okta_application_id
    OKTA_CLIENT_ORGURL = var.okta_org_url
    RESOURCE_IDS = join(",", var.resource_ids)
    SSM_PREFIX = var.app
    ROLE_ASSIGNMENT_STRATEGY = var.role_assignment_strategy
  }, var.group_map, var.role_map )
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
    ignore_changes = [ filename ]
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
    ignore_changes = [ filename ]
  }
}

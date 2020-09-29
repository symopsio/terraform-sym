resource "aws_iam_role" "sym_execute" {
  name = "SymExecute-${var.app}"
  path = "/sym/"
  assume_role_policy = data.aws_iam_policy_document.sym_execute_assume_role.json
}

data "aws_iam_policy_document" "sym_execute_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${var.sym_account_id}:root"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "sym_execute_policy_attach" {
  role       = aws_iam_role.sym_execute.name
  policy_arn = aws_iam_policy.sym_execute_policy.arn
}

resource "aws_iam_policy" "sym_execute_policy" {
  name = "SymExecute-${var.app}"
  description = "Sym Cross-Account Invocation for ${var.app}"
  policy = data.aws_iam_policy_document.sym_execute_policy.json
}

data "aws_iam_policy_document" "sym_execute_policy" {
  statement {
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = var.lambda_arns
  }
}

output "lambda_env_vars" {
  description = "The env vars that the lambda needs to function"
  value       = local.env_vars
}

output "lambda_policy" {
  description = "The additional IAM policy elements the lambda needs to function"
  value       = data.aws_iam_policy_document.lambda_policy
}

output "sym_execute_role_name" {
  description = "The name of the cross-account invocation role"
  value       = aws_iam_role.sym_execute.name
}

output "sym_execute_role_arn" {
  description = "The ARN of the cross-account invocation role"
  value       = aws_iam_role.sym_execute.arn
}

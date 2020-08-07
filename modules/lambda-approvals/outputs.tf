output "approve_function_arn" {
  description = "The arn of the approve function"
  value       = aws_lambda_function.approve.arn
}

output "expire_function_arn" {
  description = "The arn of the expire function"
  value       = aws_lambda_function.expire.arn
}

output "safelist_function_arn" {
  description = "The arn of the safelist function"
  value       = aws_lambda_function.safelist.arn
}

output "sym_execute_role_arn" {
  description = "The ARN of the cross-account invocation role"
  value       = aws_iam_role.sym_execute.arn
}

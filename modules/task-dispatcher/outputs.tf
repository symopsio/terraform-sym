output "sym_function_arn" {
  description = "The arn of the sym function"
  value       = aws_lambda_function.sym.arn
}

output "sym_execute_role_arn" {
  description = "The ARN of the cross-account invocation role"
  value       = module.sym_execute.sym_execute_role_arn
}

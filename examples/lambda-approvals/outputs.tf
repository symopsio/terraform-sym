output "function_arn" {
  description = "The ARN of the Sym lambda function"
  value       = module.lambda_approvals.function_arn
}

output "sym_execute_role_arn" {
  description = "The ARN of the cross-account invocation role"
  value       = module.lambda_approvals.sym_execute_role_arn
}

output "lambda_approve_function_arn" {
  description = "The ARN of the approve lambda function"
  value       = module.lambda_approvals.approve_function_arn
}

output "lambda_authz_function_arn" {
  description = "The ARN of the authz lambda function"
  value       = module.lambda_approvals.authz_function_arn
}

output "lambda_expire_function_arn" {
  description = "The ARN of the expire lambda function"
  value       = module.lambda_approvals.expire_function_arn
}

output "sym_execute_role_arn" {
  description = "The ARN of the cross-account invocation role"
  value       = module.lambda_approvals.sym_execute_role_arn
}

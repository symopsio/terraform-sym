output "sym_function_arn" {
  description = "The arn of the sym function"
  value       = module.task_dispatcher.sym_function_arn
}

output "sym_execute_role_arn" {
  description = "The ARN of the cross-account invocation role"
  value       = module.task_dispatcher.sym_execute_role_arn
}

output "sym_execute_role_arn" {
  description = "The ARN of the cross-account invocation role"
  value       = aws_iam_role.sym_execute.arn
}

output "policy_arn" {
  description = "The ARN of the user access policy"
  value       = module.ssm_user_access.policy_arn
}

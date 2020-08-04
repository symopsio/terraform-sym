output "policy_arn" {
  description = "The ARN of the policy that grants users access to the tagged instances"
  value       = aws_iam_policy.ssm_user_policy.arn
}

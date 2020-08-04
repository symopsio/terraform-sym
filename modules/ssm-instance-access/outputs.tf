output "policy_arn" {
  description = "The ARN of the policy that allows instances to use Sym SSM"
  value       = aws_iam_policy.ssm_instance_policy.arn
}

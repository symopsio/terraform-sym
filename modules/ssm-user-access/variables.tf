variable "policy_name" {
  description = "The name of the IAM policy to create"
}

variable "tags" {
  description = "Instance tag key-value pairs that the policy grants access to (limit 9)"
  default = {}
  type = map(string)
}

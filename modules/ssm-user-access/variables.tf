variable "ansible_bucket_name" {
  description = "The name of the bucket to use for the Sym ansible integration"
}

variable "ansible_bucket_path" {
  description = "The path within the ansible bucket to use for the Sym ansible integration"
  default = ""
}

variable "instance_tag_options" {
  description = "Instance tag key-value pairs that the policy grants access to (limit 9)"
  default = {}
  type = map(string)
}

variable "policy_name" {
  description = "The name of the IAM policy to create"
}

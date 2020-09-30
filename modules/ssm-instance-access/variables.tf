variable "ansible_bucket_name" {
  description = "The name of the bucket to use for the Sym ansible integration"
}

variable "ansible_bucket_tags" {
  description = "Optional tags to apply to the bucket used for the Sym ansible integration"
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "The name of the IAM policy to create"
}

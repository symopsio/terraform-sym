variable "app" {
  description = "Application name"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to provision into"
}

variable "instance_tag_options" {
  description = "Instance tag key-value pairs that the policy grants access to (limit 9)"
  default = {}
  type = map(string)
}

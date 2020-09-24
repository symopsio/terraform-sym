variable "app" {
  description = "Application name"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to provision into"
}

variable "enable_sym_doctor" {
  description = "Enable logging to the sym doctor bucket"
  default = true
  type = bool
}

variable "instance_tag_options" {
  description = "Instance tag key-value pairs that the policy grants access to (limit 9)"
  default = {}
  type = map(string)
}

variable "app" {
  description = "Application name"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to provision into"
}

variable "tags" {
  description = "Tag map"
  default = {}
  type = map(string)
}

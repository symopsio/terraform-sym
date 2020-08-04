variable "app" {
  description = "Application name for the approvals lambda"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to provision into"
}

variable "aws_subnet_id" {
  description = "The subnet_id to put the demo instance in"
}

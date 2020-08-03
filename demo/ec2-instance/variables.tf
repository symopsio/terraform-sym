variable "ami_id" {
  description = "The ID of the AMI to use for the EC2 Instance"
}

variable "instance_name" {
  description = "The name of the EC2 instance to create"
  default     = "ssm-instance"
}

variable "instance_role_name" {
  description = "The name of the IAM role to create"
  default     = "SSMInstance"
}

variable "subnet_id" {
  description = "The subnet_id to put the demo instance in"
}

variable "tag_key" {
  description = "The tag key you want to filter access by"
  default     = "Environment"
}

variable "tag_value" {
  description = "The tag value you want to filter access by"
  default     = "staging"
}

variable "account_id" {
  description = "AWS Account ID"
}

variable "app" {
  description = "App name"
  default     = "sym-example-task"
}

variable "region" {
  default = "us-east-1"
}

variable "s3_bucket" {
  description = "S3 Bucket with the lambda code"
  default     = "sym-releases"
}

variable "s3_key" {
  description = "S3 Key with the path to the lambda code"
  default     = "sym-awslambda-py/example-task-latest.zip"
}

variable "sleep" {
  description = "Amount of time to sleep the example task"
  default     = 0
  type        = number
}

variable "timeout" {
  description = "Invocation timeout for tasks, in seconds"
  default     = 3
  type        = number
}

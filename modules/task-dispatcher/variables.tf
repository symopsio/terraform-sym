variable "account_id" {
  description = "AWS Account ID"
}

variable "app" {
  description = "App name"
  default     = "sym-task-dispatcher"
}

variable "function_map" {
  description = "Mapping of Sym resource IDs to function ARNs"
  default     = {}
  type        = map(string)
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
  default     = "sym-awslambda-py/task-dispatcher-latest.zip"
}

variable "sym_account_id" {
  description = "Account ID for Sym Cross-Account Invocation"
  default     = "803477428605"
}

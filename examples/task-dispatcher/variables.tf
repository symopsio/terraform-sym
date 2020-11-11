variable "app" {
  description = "Name of the application to deploy"
  default     = "sym-example-task-dispatcher"
}

variable "region" {
  default = "us-east-1"
}

variable "sym_account_id" {
  description = "Account ID for Sym Cross-Account Invocation"
  default     = "803477428605"
}

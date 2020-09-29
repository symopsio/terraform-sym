variable "app" {
  description = "App name"
}

variable "lambda_arns" {
  description = "The ARNS that this execution role should be able to invoke"
  type        = list(string)
}

variable "sym_account_id" {
  description = "Account ID for Sym Cross-Account Invocation"
  default     = "803477428605"
}

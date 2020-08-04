terraform {
  experiments = [variable_validation]
}

variable "account_id" {
  description = "AWS Account ID"
}

variable "app" {
  description = "App name"
}

variable "okta_application_id" {
  description = "Okta Application ID (for role-based assignment)"
  default     = ""
}

variable "okta_org_url" {
  description = "Okta Org Url"
}

variable "region" {
  default = "us-east-1"
}

variable "resources" {
  description = "Mapping of resources to roles or groups. Seem tfvars.sample."
  type        = map
}

variable "role_assignment_strategy" {
  description = "Role assignment strategy"
  type        = string

  validation {
    condition     = contains(["individual", "group"], var.role_assignment_strategy)
    error_message = "Role assignment strategy should be individual or group."
  }
}

variable "s3_bucket" {
  description = "S3 Bucket with the lambda code"
  default     = "sym-releases"
}

variable "s3_key" {
  description = "S3 Key with the path to the lambda code"
  default     = "sym-lambda-golang/sym-lambda-golang-latest.zip"
}

variable "sym_account_id" {
  description = "Account ID for Sym Cross-Account Invocation"
  default     = "803477428605"
}

terraform {
  experiments = [variable_validation]
}

variable "account_id" {
  description = "AWS Account ID"
}

variable "app" {
  description = "App name"
}

variable "authroles" {
  description = "Map of roles to lists of authorized users. See tfvars.sample."
  default     = {}
  type        = map(list(string))
}

variable "external_id" {
  description = "The cross-account external id used when Sym invokes your cross-account role"
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
  description = "Mapping of resources to roles or groups. See tfvars.sample."
  type        = map(map(string))
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
  default     = "sym-lambda-golang/sym-okta-golang-approvals-latest.zip"
}

variable "sym_account_id" {
  description = "Account ID for Sym Cross-Account Invocation"
  default     = "803477428605"
}

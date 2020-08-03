terraform {
  experiments = [variable_validation]
}

variable "account_id" {
  description = "AWS Account ID"
}

variable "app" {
  description = "App name"
}

variable "role_assignment_strategy" {
  description = "Role assignment strategy"
  type        = string

  validation {
    condition     = contains(["individual", "group"], var.role_assignment_strategy)
    error_message = "Role assignment strategy should be individual or group."
  }
}

variable "filename" {
  description = "Local file with the initial function code"
}

variable "group_map" {
  description = "Mapping of resource ids to Okta group names"
  type        = map(string)
  default     = {}
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

variable "resource_ids" {
  description = "List of supported resource ids"
  type        = list(string)
}

variable "role_map" {
  description = "Mapping of resource ids to AWS role names"
  type        = map(string)
  default     = {}
}

variable "sym_account_id" {
  description = "Account ID for Sym Cross-Account Invocation"
  default     = "803477428605"
}

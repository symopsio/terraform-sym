variable "aws_account_id" {
  description = "AWS account ID"
  type        = number
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "okta_application_id" {
  description = "Okta application ID"
  type        = string
}

variable "okta_org_url" {
  description = "Okta org URL"
  type        = string
}

variable "resource_ids" {
  description = "List of supported resource IDs"
  type        = list(string)
}

variable "role_assignment_strategy" {
  description = "Role assignment strategy"
  type        = string
}

variable "role_map" {
  description = "Mapping of resource IDs to AWS role names"
  type        = map(string)
}

variable "group_map" {
  description = "Mapping of resource IDs to Okta group names"
  type        = map(string)
}

variable "lambda_approvals_app_name" {
  description = "Application name for the approvals lambda"
  type        = string
}

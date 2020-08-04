variable "app" {
  description = "Application name for the approvals lambda"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to provision into"
}

variable "okta_application_id" {
  description = "Okta application ID"
  type        = string
}

variable "okta_org_url" {
  description = "Okta org URL"
  type        = string
}

variable "resources" {
  description = "Mapping of resources to roles or groups. Seem tfvars.sample."
  type        = map
}

variable "role_assignment_strategy" {
  description = "Role assignment strategy"
  type        = string
}

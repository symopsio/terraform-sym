variable "app" {
  description = "Application name for the approvals lambda"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to provision into"
}

variable "external_id" {
  description = "The cross-account external id used when Sym invokes your cross-account role"
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

variable "safelist" {
  description = "List of users that are able to make requests"
  default     = []
  type        = list(string)
}

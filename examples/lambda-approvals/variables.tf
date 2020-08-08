variable "app" {
  description = "Application name for the approvals lambda"
  type        = string
}

variable "authroles" {
  description = "Map of roles to lists of authorized users. See tfvars.sample."
  default     = {}
  type        = map(list(string))
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
  type        = map(map(string))
}

variable "role_assignment_strategy" {
  description = "Role assignment strategy"
  type        = string
}

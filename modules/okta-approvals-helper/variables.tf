variable "account_id" {
  description = "AWS Account ID"
}

variable "app" {
  description = "App name"
}

variable "authroles" {
  description = "Map of roles to lists of authorized users. See tfvars.sample."
  default     = {}
  type        = map
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
}

variable "sym_account_id" {
  description = "Account ID for Sym Cross-Account Invocation"
  default     = "803477428605"
}

variable "app" {
  description = "Application name for the approvals lambda"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to provision into"
}

variable "aws_subnet_id" {
  description = "The subnet_id to put the demo instance in"
}

variable "group_map" {
  description = "Mapping of resource IDs to Okta group names"
  type        = map(string)
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

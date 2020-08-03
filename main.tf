module "lambda_approvals" {
  source                   = "./modules/lambda-approvals"
  account_id               = var.aws_account_id
  region                   = var.aws_region
  okta_application_id      = var.okta_application_id
  okta_org_url             = var.okta_org_url
  resource_ids             = var.resource_ids
  role_assignment_strategy = var.role_assignment_strategy
  role_map                 = var.role_map
  group_map                = var.group_map
  app                      = var.lambda_approvals_app_name
}

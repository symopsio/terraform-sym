terraform {
  required_version = ">= 0.12.7"
}

provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

provider "local" {
  version = "~> 1.4"
}

data "aws_caller_identity" "current" { }

module "example_task" {
  source           = "../../modules/example-task/"
  account_id       = data.aws_caller_identity.current.account_id
  app              = "${var.app}-example"
  region           = var.region
}

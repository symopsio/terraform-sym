## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_id | AWS Account ID | `any` | n/a | yes |
| app | App name | `any` | n/a | yes |
| authroles | Map of roles to lists of authorized users. See tfvars.sample. | `map(map(list(string)))` | `{}` | no |
| external\_id | The cross-account external id used when Sym invokes your cross-account role | `any` | n/a | yes |
| okta\_application\_id | Okta Application ID (for role-based assignment) | `string` | `""` | no |
| okta\_org\_url | Okta Org Url | `any` | n/a | yes |
| region | n/a | `string` | `"us-east-1"` | no |
| resources | Mapping of resources to roles or groups. See tfvars.sample. | `map(map(string))` | n/a | yes |
| role\_assignment\_strategy | Role assignment strategy | `string` | n/a | yes |
| s3\_bucket | S3 Bucket with the lambda code | `string` | `"sym-releases"` | no |
| s3\_key | S3 Key with the path to the lambda code | `string` | `"sym-lambda-golang/sym-okta-approvals-golang-latest.zip"` | no |
| sym\_account\_id | Account ID for Sym Cross-Account Invocation | `string` | `"803477428605"` | no |

## Outputs

| Name | Description |
|------|-------------|
| function\_arn | The arn of the sym lambda function |
| sym\_execute\_role\_arn | The ARN of the cross-account invocation role |


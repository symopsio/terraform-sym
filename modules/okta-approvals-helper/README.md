## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

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
| sym\_account\_id | Account ID for Sym Cross-Account Invocation | `string` | `"803477428605"` | no |

## Outputs

| Name | Description |
|------|-------------|
| lambda\_env\_vars | The env vars that the lambda needs to function |
| lambda\_policy | The additional IAM policy elements the lambda needs to function |
| sym\_execute\_role\_arn | The ARN of the cross-account invocation role |
| sym\_execute\_role\_name | The name of the cross-account invocation role |


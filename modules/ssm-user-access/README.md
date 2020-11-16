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
| instance\_tag\_options | Instance tag key-value pairs that the policy grants access to (limit 9) | `map(string)` | `{}` | no |
| policy\_name | The name of the IAM policy to create | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy\_arn | The ARN of the policy that grants users access to the tagged instances |


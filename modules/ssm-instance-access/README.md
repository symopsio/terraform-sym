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
| policy\_name | The name of the IAM policy to create | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy\_arn | The ARN of the policy that allows instances to use Sym SSM |


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.10.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ses"></a> [ses](#module\_ses) | ../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to create resources. | `string` | `"eu-central-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dkim_tokens"></a> [dkim\_tokens](#output\_dkim\_tokens) | n/a |
| <a name="output_ses_domain_identity_arn"></a> [ses\_domain\_identity\_arn](#output\_ses\_domain\_identity\_arn) | n/a |
| <a name="output_ses_user_access_key_id"></a> [ses\_user\_access\_key\_id](#output\_ses\_user\_access\_key\_id) | n/a |
| <a name="output_ses_user_secret_access_key"></a> [ses\_user\_secret\_access\_key](#output\_ses\_user\_secret\_access\_key) | n/a |
| <a name="output_verification_token"></a> [verification\_token](#output\_verification\_token) | n/a |

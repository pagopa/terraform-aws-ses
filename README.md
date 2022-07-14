# terraform-aws-ses
Terraform module to create AWS SES

## Example usage

```hcl
module "ses" {
  source = "git::https://github.com/pagopa/terraform-aws-ses.git?ref=v1.0.0"
  domain = "pagopa.gov.it"

  iam_permissions = [
    "ses:SendCustomVerificationEmail",
    "ses:SendEmail",
    "ses:SendRawEmail",
    "ses:SendTemplatedEmail",
  ]

  ses_group_name = "PagoPaSES"
  user_name      = "ProjectPagoPa"

}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
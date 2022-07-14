terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.10.0"
      configuration_aliases = [aws.alternate]
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.tags
  }
}


module "ses" {
  source = "../"
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

output "verification_token" {
  value = module.ses.verification_token
}

output "dkim_tokens" {
  value = module.ses.dkim_tokens
}

output "ses_user_access_key_id" {
  value = module.ses.ses_user_access_key_id
}

output "ses_user_secret_access_key" {
  value     = module.ses.ses_user_secret_access_key
  sensitive = true
}
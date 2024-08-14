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
  source  = "../"
  domain  = "sandbox.pagopa.it"
  zone_id = "Z00625051S9P4M3WNA7H0"

  dmarc_policy = "v=DMARC1; p=none;"

  iam_permissions = [
    "ses:SendCustomVerificationEmail",
    "ses:SendEmail",
    "ses:SendRawEmail",
    "ses:SendTemplatedEmail",
  ]

  ses_group_name = "PagoPaSES"
  user_name      = "ProjectPagoPa"

}


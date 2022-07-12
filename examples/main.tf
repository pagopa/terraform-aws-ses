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
}

output "verification_token" {
  value = module.ses.verification_token
}

output "dkim_tokens" {
  value = module.ses.dkim_tokens
}
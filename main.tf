/*
Create SES domain identity
*/

resource "aws_ses_domain_identity" "this" {
  domain = var.domain
}

resource "aws_route53_record" "txt" {
  count = var.zone_id != null && var.verify_domain ? 1 : 0

  zone_id = var.zone_id
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  ttl     = "600"
  records = [join("", aws_ses_domain_identity.this.*.verification_token)]
}


resource "aws_ses_domain_dkim" "this" {
  count  = var.verify_domain ? 1 : 0
  domain = join("", aws_ses_domain_identity.this.*.domain)
}

resource "aws_route53_record" "cname" {
  count = var.zone_id != null && var.verify_dkim ? 3 : 0

  zone_id = var.zone_id
  name    = "${element(aws_ses_domain_dkim.this.0.dkim_tokens, count.index)}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.this.0.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

## Create iam group and user.

data "aws_iam_policy_document" "ses_policy" {
  count = var.user_name != null ? 1 : 0

  statement {
    actions   = var.iam_permissions
    resources = concat(aws_ses_domain_identity.this.*.arn, var.iam_allowed_resources)
  }
}

resource "aws_iam_group" "ses_users" {
  count = var.user_name != null ? 1 : 0

  name = var.ses_group_name
  path = var.ses_group_path
}

resource "aws_iam_group_policy" "ses_group_policy" {
  count = var.user_name != null ? 1 : 0

  name  = join("", [var.ses_group_name, "Policy"])
  group = aws_iam_group.ses_users[0].name

  policy = join("", data.aws_iam_policy_document.ses_policy.*.json)
}

resource "aws_iam_user" "ses_user" {
  count = var.user_name != null ? 1 : 0
  name  = var.user_name
  path  = var.user_path
}

resource "aws_iam_group_membership" "ses_group" {
  count = var.user_name != null ? 1 : 0
  name  = join("", [var.ses_group_name, "Membership"])

  users = [
    aws_iam_user.ses_user[0].name
  ]

  group = aws_iam_group.ses_users[0].name
}


resource "aws_iam_access_key" "ses_user" {
  count = var.user_name != null ? 1 : 0
  user  = aws_iam_user.ses_user[0].name
}
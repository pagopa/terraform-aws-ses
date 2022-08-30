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
    sid       = "SendEmail"
    actions   = var.iam_permissions
    resources = concat(aws_ses_domain_identity.this.*.arn, var.iam_allowed_resources)
  }

  dynamic "statement" {
    for_each = var.iam_additional_statements

    content {
      sid       = statement.value.sid
      actions   = statement.value.actions
      resources = statement.value.resources
    }
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

resource "aws_ses_domain_mail_from" "this" {
  count            = var.mail_from_subdomain != null ? 1 : 0
  domain           = aws_ses_domain_identity.this.domain
  mail_from_domain = join(".", [var.mail_from_subdomain, aws_ses_domain_identity.this.domain])
}

## Alarms

### Sendign quotas

module "daily_sending_quota_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"

  count               = var.alarms != null ? 1 : 0
  alarm_name          = "ses-daily-sading-quota"
  actions_enabled     = true
  alarm_description   = "Daily usage approaching your sending limits."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = var.alarms.daily_send_quota_threshold
  period              = var.alarms.daily_send_quota_period
  unit                = "Count"

  namespace   = "AWS/SES"
  metric_name = "Send"
  statistic   = "Sum"

  alarm_actions = var.alarms.actions
}

# The percentage of emails sent from your account that resulted in recipients reporting them as spam 
# based on a representative volume of email.
module "reputation_complaint_rate_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"

  count               = var.alarms != null ? 1 : 0
  alarm_name          = "ses-reputation-complaint-rate"
  actions_enabled     = true
  alarm_description   = "80% of emails sent from your account that resulted in recipients reporting them as spam."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = var.alarms.reputation_complaint_rate_threshold
  period              = var.alarms.reputation_complaint_rate_period
  unit                = "Count"
  namespace           = "AWS/SES"
  metric_name         = "Reputation.ComplaintRate"
  statistic           = "Average"

  alarm_actions = var.alarms.actions
}

### The percentage of emails sent from your account that resulted in a hard bounce based on a representative volume of email.
module "reputation_bounce_rate_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"

  count               = var.alarms != null ? 1 : 0
  alarm_name          = "ses-reputation-bounce-rate"
  actions_enabled     = true
  alarm_description   = "10% of emails sent from your account that resulted in hard bounce."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = var.alarms.reputation_bounce_rate_threshold
  period              = var.alarms.reputation_bounce_rate_period
  unit                = "Count"

  namespace   = "AWS/SES"
  metric_name = "Reputation.BounceRate"
  statistic   = "Average"

  alarm_actions = var.alarms.actions
}
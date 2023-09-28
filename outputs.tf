output "verification_token" {
  value = {
    name = "_amazonses"
  value : aws_ses_domain_identity.this.verification_token }
  description = "Verification token. TXT record."
}

output "dkim_tokens" {
  value = [for t in try(aws_ses_domain_dkim.this[0].dkim_tokens, []) : {
    name : format("%s._domainkey", t)
    value : format("%s.dkim.%s.amazonses.com", t, var.aws_region)
  }]
  description = "CNAME, dkim tokens."
}

output "ses_user_access_key_id" {
  value = try(aws_iam_access_key.ses_user[0].id, null)
}

output "ses_user_secret_access_key" {
  value     = try(aws_iam_access_key.ses_user[0].secret, null)
  sensitive = true
}

output "ses_domain_identity_arn" {
  value = try(aws_ses_domain_identity.this.arn, null)
}

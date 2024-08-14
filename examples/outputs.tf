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

output "ses_domain_identity_arn" {
  value = module.ses.ses_domain_identity_arn
}
variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "domain" {
  type        = string
  description = "The domain name to assign to SES"
}

variable "verify_domain" {
  type        = bool
  description = "Verify domain?"
  default     = true
}

variable "zone_id" {
  type        = string
  description = "R53 zone id."
  default     = null
}

variable "verify_dkim" {
  type        = bool
  description = "Verify dkim"
  default     = true
}

variable "iam_permissions" {
  type = list(string)
  default = [
    "ses:SendRawEmail"
  ]
  description = "Permission for the Iam user."
}

variable "iam_allowed_resources" {
  type        = list(string)
  description = "Specifies resource ARNs that are enabled to send email. Wildcards are acceptable."
  default     = []
}

variable "iam_additional_statements" {
  type = list(
    object({
      sid       = string
      actions   = list(string)
      resources = list(string)
    })
  )
  default     = []
  description = "Iam policy custom statements."

}

variable "ses_group_name" {
  type        = string
  description = "The name of the IAM group to create."
}


variable "ses_group_path" {
  type        = string
  description = "The IAM Path of the group to create"
  default     = "/"
}

variable "user_name" {
  type        = string
  description = "SES Iam user name. If null no user and group will be created."
}

variable "user_path" {
  type        = string
  default     = "/"
  description = "Path in which to create the user."
}

variable "mail_from_subdomain" {
  type        = string
  description = "Subdomain which is to be used as MAIL FROM address (Required for DMARC validation)"
  default     = null
}

variable "alarms" {
  type = object({
    daily_send_quota_threshold          = number
    daily_send_quota_period             = number
    reputation_complaint_rate_threshold = number
    reputation_complaint_rate_period    = number
    reputation_bounce_rate_threshold    = number
    reputation_bounce_rate_period       = number

    actions = list(string)
  })
  default = null
}
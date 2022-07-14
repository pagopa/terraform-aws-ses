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
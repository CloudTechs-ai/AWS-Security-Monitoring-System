variable "aws_region" {
  description = "AWS region where the monitoring system will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "notification_email" {
  description = "Optional email address for SNS security alerts. Leave null to deploy without an email subscription."
  type        = string
  default     = null
}

variable "api_key" {
  description = "Optional API key to store in Secrets Manager. If omitted, Terraform generates a demo value."
  type        = string
  sensitive   = true
  default     = null
}

variable "oauth_token" {
  description = "Optional OAuth token to store in Secrets Manager. If omitted, Terraform generates a demo value."
  type        = string
  sensitive   = true
  default     = null
}

variable "other_secret" {
  description = "Optional additional secret value. If omitted, Terraform generates a demo value."
  type        = string
  sensitive   = true
  default     = null
}

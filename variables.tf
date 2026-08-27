variable "api_key" {
  description = "API key secret value"
  type        = string
  sensitive   = true
}

variable "oauth_token" {
  description = "OAuth token secret value"
  type        = string
  sensitive   = true
}

variable "other_secret" {
  description = "Other secret value"
  type        = string
  sensitive   = true
}

variable "cloud_watch_logs_group_arn" {
  description = "ARN of the CloudWatch Logs Log Group for CloudTrail"
  type        = string
}

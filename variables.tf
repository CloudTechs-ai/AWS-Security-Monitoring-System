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

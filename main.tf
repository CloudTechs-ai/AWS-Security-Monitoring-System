terraform {
  required_version = ">= 1.8.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

locals {
  account_id      = data.aws_caller_identity.current.account_id
  region          = "us-east-1"
  trail_name      = "secrets-manager-trail"
  trail_arn       = "arn:aws:cloudtrail:${local.region}:${local.account_id}:trail/${local.trail_name}"
  trail_s3_prefix = "cloudtrail"

  # Each entry becomes a CloudWatch metric filter + alarm
  detections = {
    SecretAccessed = {
      pattern = "{ ($.eventName = \"GetSecretValue\") }"
    }
    RootAccountUsage = {
      pattern = "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"
    }
    IAMPolicyChange = {
      pattern = "{ ($.eventName = DeleteGroupPolicy) || ($.eventName = DeleteRolePolicy) || ($.eventName = DeleteUserPolicy) || ($.eventName = PutGroupPolicy) || ($.eventName = PutRolePolicy) || ($.eventName = PutUserPolicy) || ($.eventName = CreatePolicy) || ($.eventName = DeletePolicy) || ($.eventName = CreatePolicyVersion) || ($.eventName = DeletePolicyVersion) || ($.eventName = AttachRolePolicy) || ($.eventName = DetachRolePolicy) || ($.eventName = AttachUserPolicy) || ($.eventName = DetachUserPolicy) || ($.eventName = AttachGroupPolicy) || ($.eventName = DetachGroupPolicy) }"
    }
    ConsoleLoginFailure = {
      pattern = "{ ($.eventName = \"ConsoleLogin\") && ($.errorMessage = \"Failed authentication\") }"
    }
  }
}

# -------------------------------
# Secrets Manager
# -------------------------------
resource "aws_secretsmanager_secret" "monitoring_secret" {
  name        = "cloudtechs-monitoring-secret"
  description = "Secret created for CloudTrail/CloudWatch monitoring system"

  # Allows immediate delete/recreate on terraform destroy (demo project)
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "monitoring_secret_value" {
  secret_id = aws_secretsmanager_secret.monitoring_secret.id
  secret_string = jsonencode({
    api_key     = var.api_key
    oauth_token = var.oauth_token
    other       = var.other_secret
  })
}

# -------------------------------
# S3 Bucket for CloudTrail logs
# -------------------------------
resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket        = "cloudtechs-security-monitoring-${local.account_id}"
  force_destroy = true

  tags = {
    Name        = "CloudTrailLogBucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail_bucket" {
  bucket                  = aws_s3_bucket.cloudtrail_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_bucket" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  depends_on = [aws_s3_bucket_public_access_block.cloudtrail_bucket]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:GetBucketAcl"
        Resource  = aws_s3_bucket.cloudtrail_bucket.arn
        Condition = {
          StringEquals = { "aws:SourceArn" = local.trail_arn }
        }
      },
      {
        Sid       = "AWSCloudTrailWrite"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.cloudtrail_bucket.arn}/${local.trail_s3_prefix}/AWSLogs/${local.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
            "aws:SourceArn" = local.trail_arn
          }
        }
      }
    ]
  })
}

# -------------------------------
# CloudWatch Log Group
# -------------------------------
resource "aws_cloudwatch_log_group" "cloudtrail_log_group" {
  name              = "cloudtechs-secretsmanager-loggroup"
  retention_in_days = 90
}

# -------------------------------
# IAM Role for CloudTrail -> CloudWatch
# -------------------------------
resource "aws_iam_role" "cloudtrail_to_cloudwatch" {
  name = "cloudtrail-to-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "cloudtrail.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "cloudtrail_to_cloudwatch_policy" {
  name = "cloudtrail-to-cloudwatch-policy"
  role = aws_iam_role.cloudtrail_to_cloudwatch.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}:*"
    }]
  })
}

# -------------------------------
# CloudTrail
# -------------------------------
resource "aws_cloudtrail" "secrets_manager_trail" {
  depends_on = [
    aws_s3_bucket_policy.cloudtrail_bucket_policy,
    aws_iam_role_policy.cloudtrail_to_cloudwatch_policy
  ]

  name                          = local.trail_name
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.bucket
  s3_key_prefix                 = local.trail_s3_prefix
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  enable_logging                = true

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_to_cloudwatch.arn

  event_selector {
    read_write_type           = "All"
    include_management_events = true
    exclude_management_event_sources = [
      "kms.amazonaws.com",
      "rdsdata.amazonaws.com"
    ]
  }

  tags = {
    Name        = "SecretsManagerTrail"
    Environment = "Production"
  }
}

# -------------------------------
# SNS Topic + Subscription
# -------------------------------
resource "aws_sns_topic" "security_alarms" {
  name = "SecurityAlarms"
}

resource "aws_sns_topic_subscription" "security_alarms_email" {
  topic_arn = aws_sns_topic.security_alarms.arn
  protocol  = "email"
  endpoint  = "Ryan@cloudtechs.ai"
}

resource "aws_sns_topic_policy" "security_alarms_policy" {
  arn = aws_sns_topic.security_alarms.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudWatchAlarmsPublish"
        Effect    = "Allow"
        Principal = { Service = "cloudwatch.amazonaws.com" }
        Action    = "SNS:Publish"
        Resource  = aws_sns_topic.security_alarms.arn
        Condition = {
          StringEquals = { "aws:SourceAccount" = local.account_id }
        }
      }
    ]
  })
}

# -------------------------------
# Metric Filters + Alarms (one per detection)
# -------------------------------
resource "aws_cloudwatch_log_metric_filter" "detections" {
  for_each = local.detections

  name           = each.key
  log_group_name = aws_cloudwatch_log_group.cloudtrail_log_group.name
  pattern        = each.value.pattern

  metric_transformation {
    name      = each.key
    namespace = "SecurityMetrics"
    value     = "1"
    unit      = "Count"
  }
}

resource "aws_cloudwatch_metric_alarm" "detections" {
  for_each = local.detections

  alarm_name          = each.key
  alarm_description   = "Security detection: ${each.key}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1
  treat_missing_data  = "notBreaching"

  namespace   = "SecurityMetrics"
  metric_name = each.key
  statistic   = "Sum"
  period      = 300

  alarm_actions   = [aws_sns_topic.security_alarms.arn]
  actions_enabled = true

  depends_on = [aws_cloudwatch_log_metric_filter.detections]
}

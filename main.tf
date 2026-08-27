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

# -------------------------------
# Secrets Manager
# -------------------------------
resource "aws_secretsmanager_secret" "monitoring_secret" {
  name        = "cloudtechs-monitoring-secret"
  description = "Secret created for CloudTrail/CloudWatch monitoring system"
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
  bucket = "cloudtechs-secrets-manager-trail-no"

  tags = {
    Name        = "CloudTrailLogBucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck",
        Effect    = "Allow",
        Principal = { Service = "cloudtrail.amazonaws.com" },
        Action    = "s3:GetBucketAcl",
        Resource  = aws_s3_bucket.cloudtrail_bucket.arn
      },
      {
        Sid       = "AWSCloudTrailWrite",
        Effect    = "Allow",
        Principal = { Service = "cloudtrail.amazonaws.com" },
        Action    = "s3:PutObject",
        Resource  = "${aws_s3_bucket.cloudtrail_bucket.arn}/cloudtechs-secrets-manager-trail-no/*",
        Condition = {
          StringEquals = { "s3:x-amz-acl" = "bucket-owner-full-control" }
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
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "cloudtrail.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "cloudtrail_to_cloudwatch_policy" {
  role = aws_iam_role.cloudtrail_to_cloudwatch.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}:*"
    }]
  })
}
# -------------------------------
# CloudTrail
# -------------------------------

resource "aws_cloudtrail" "secrets_manager_trail" {
  depends_on = [
    aws_cloudwatch_log_group.cloudtrail_log_group,
    aws_iam_role.cloudtrail_to_cloudwatch
  ]

  name                          = "secrets-manager-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.bucket
  s3_key_prefix                 = "cloudtechs-secrets-manager-trail-no"
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  enable_logging                = true

  cloud_watch_logs_group_arn = var.cloud_watch_logs_group_arn
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_to_cloudwatch.arn

  sns_topic_name = aws_sns_topic.security_alarms.name

  kms_key_id = null

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
# Metric Filter for GetSecretValue
# -------------------------------
resource "aws_cloudwatch_log_metric_filter" "get_secret_value_filter" {
  name           = "GetSecretsValue"
  log_group_name = aws_cloudwatch_log_group.cloudtrail_log_group.name

  # Must be a quoted string
  pattern = "{ ($.eventName = \"GetSecretValue\") }"

  metric_transformation {
    name          = "Secret is accessed"
    namespace     = "SecurityMetrics"
    value         = "1"
    default_value = 0
    unit          = "Count"
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
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowCloudTrailPublish",
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action   = "SNS:Publish",
        Resource = aws_sns_topic.security_alarms.arn
      }
    ]
  })
}

# -------------------------------
# CloudWatch Alarm
# -------------------------------
resource "aws_cloudwatch_metric_alarm" "secret_accessed_alarm" {
  alarm_name          = "Secret is accessed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1
  treat_missing_data  = "notBreaching"

  namespace   = "SecurityMetrics"
  metric_name = "Secret is accessed"
  statistic   = "Average"
  period      = 300

  alarm_actions             = [aws_sns_topic.security_alarms.arn]
  ok_actions                = [aws_sns_topic.security_alarms.arn]
  insufficient_data_actions = [aws_sns_topic.security_alarms.arn]

  actions_enabled = true
}



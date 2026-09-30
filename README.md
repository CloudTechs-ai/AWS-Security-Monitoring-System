🛡️ AWS SECURITY MONITORING SYSTEM
Automated Cloud Security Monitoring & Alerting with AWS + Terraform
<p align="center"> <img src="https://img.shields.io/badge/AWS-Cloud-orange?logo=amazon-aws" alt="AWS"> <img src="https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform" alt="Terraform"> <img src="https://img.shields.io/badge/CloudTrail-Audit-blue" alt="CloudTrail"> <img src="https://img.shields.io/badge/CloudWatch-Monitoring-blue" alt="CloudWatch"> <img src="https://img.shields.io/badge/Security-Automation-red" alt="Security"> </p> <p align="center"> <strong> An Infrastructure-as-Code security monitoring platform that detects sensitive AWS activity, centralizes audit logs, generates security metrics, and automatically delivers alerts. </strong> </p>
📌 Overview

The AWS Security Monitoring System is an automated cloud security monitoring and alerting platform built with AWS-native services and Terraform.

The project demonstrates how multiple AWS services can be integrated into a centralized security monitoring pipeline capable of:

🔍 Capturing AWS API activity with CloudTrail

📊 Centralizing events with CloudWatch Logs

🚨 Detecting sensitive activity with CloudWatch Metric Filters

🔔 Triggering automated notifications through SNS

🔐 Managing sensitive values with AWS Secrets Manager

🗄️ Storing CloudTrail audit logs in Amazon S3

🔑 Controlling service access through IAM

🏗️ Provisioning infrastructure through Terraform

The goal is to demonstrate practical experience in AWS Security Engineering, Infrastructure as Code, Observability, IAM, Monitoring, and Automated Incident Detection.

🏗️ Architecture
<img width="506" height="225" alt="AWS Security Pipeline" src="https://github.com/user-attachments/assets/58797f82-312e-4af2-b2c5-312f8f308ae0" />
Security Monitoring Flow
AWS ACCOUNT
    |
    v
+-------------------+
|    AWS CloudTrail |
|-------------------|
| API Activity      |
| IAM Changes       |
| Authentication    |
| Secret Access     |
+---------+---------+
          |
          |
     +----+----+
     |         |
     v         v
+---------+  +------------------+
|   S3    |  | CloudWatch Logs  |
|---------|  |------------------|
| Audit   |  | Security Events  |
| Logs    |  | Event Analysis   |
+---------+  +--------+---------+
                       |
                       v
              +------------------+
              | Metric Filters   |
              |------------------|
              | Secret Access    |
              | IAM Activity     |
              | Authentication   |
              +--------+---------+
                       |
                       v
              +------------------+
              | CloudWatch Alarm |
              +--------+---------+
                       |
                       v
              +------------------+
              |       SNS        |
              |------------------|
              | Email Alerts     |
              +------------------+

Infrastructure Provisioning
Terraform
    |
    v
+--------------------+
| terraform init     |
+---------+----------+
          |
          v
+--------------------+
| terraform validate |
+---------+----------+
          |
          v
+--------------------+
| terraform plan     |
+---------+----------+
          |
          v
+--------------------+
| terraform apply    |
+---------+----------+
          |
          v
+----------------------------+
| AWS Security Infrastructure|
+----------------------------+
          |
          v
+----------------------------+
| Automated Monitoring       |
+----------------------------+

🎯 What This Project Does
Capability	AWS Service	Purpose
API Auditing	CloudTrail	Records AWS API activity
Log Aggregation	CloudWatch Logs	Centralizes security events
Event Detection	Metric Filters	Detects sensitive API operations
Alerting	CloudWatch Alarms	Evaluates security metrics
Notifications	SNS	Sends security alerts
Audit Storage	S3	Retains CloudTrail logs
Secret Management	Secrets Manager	Stores sensitive configuration
Access Control	IAM	Controls AWS service permissions
Automation	Terraform	Provisions the environment
🔐 Sensitive Secret Detection

One of the primary detection workflows monitors access to AWS Secrets Manager.

When a secret is accessed, the event travels through the following pipeline:

AWS Secrets Manager
        |
        v
   GetSecretValue
        |
        v
     CloudTrail
        |
        v
 CloudWatch Logs
        |
        v
  Metric Filter
        |
        v
 Security Metric
        |
        v
 CloudWatch Alarm
        |
        v
       SNS
        |
        v
 Email Notification


The Terraform configuration creates a CloudWatch Metric Filter for:

GetSecretValue


This converts a raw CloudTrail event into a measurable CloudWatch security metric.

🔍 AWS CloudTrail

AWS CloudTrail provides the primary audit layer for the monitoring system.

The project configures CloudTrail for:

Multi-region logging

Management events

Read/write API activity

CloudWatch integration

S3 audit storage

Log file validation

CloudTrail acts as the primary source of security event data for the monitoring pipeline.

📊 Amazon CloudWatch

Amazon CloudWatch provides the monitoring, detection, and alerting layer.

CloudWatch Logs

Centralizes CloudTrail events for investigation and analysis.

Metric Filters

Search CloudTrail events for specific security-sensitive operations.

Current detection:

GetSecretValue

CloudWatch Alarms

Evaluate security metrics and trigger notifications when configured thresholds are reached.

🚨 Automated Alerting

Amazon SNS provides the notification layer.

Security Event
      |
      v
CloudTrail
      |
      v
CloudWatch Logs
      |
      v
Metric Filter
      |
      v
CloudWatch Alarm
      |
      v
SNS
      |
      v
Email Notification


This reduces the need for engineers to continuously inspect CloudTrail logs manually.

🗄️ S3 Audit Storage

Amazon S3 provides durable storage for CloudTrail audit logs.

The infrastructure is designed to provide:

🔒 Encrypted storage

🗂️ Versioning

🔑 Restricted access

📋 CloudTrail-specific bucket policies

🌎 Multi-region CloudTrail logging

Unique Bucket Naming

S3 bucket names must be globally unique.

The project therefore generates the bucket name using the AWS account ID and a unique suffix.

Example:

cloudtechs-security-monitoring-123456789012-a7f32c91


This allows different AWS accounts to deploy the project without manually choosing a globally unique bucket name.

🔑 IAM & Least Privilege

The project creates a dedicated IAM role for the CloudTrail-to-CloudWatch integration.

CloudTrail
    |
    v
IAM Service Role
    |
    v
CloudWatch Logs


The role provides CloudTrail with the permissions required to:

Create CloudWatch log streams

Publish CloudTrail events to CloudWatch Logs

This separates AWS service permissions from the user's own IAM credentials and follows the principle of least privilege.

🔐 Secrets Management

Sensitive configuration values are handled through Terraform variables and AWS Secrets Manager.

Example variables include:

api_key
oauth_token
other_secret


Sensitive Terraform variables should be marked as sensitive and should never be committed to source control.

The repository includes:

secrets.tfvars.example


Create your own local file:

secrets.tfvars


and keep it out of Git.

🏗️ Infrastructure as Code

The entire monitoring environment is provisioned using Terraform.

Terraform Configuration
        |
        v
terraform init
        |
        v
terraform validate
        |
        v
terraform plan
        |
        v
terraform apply
        |
        v
AWS Infrastructure
        |
        v
Security Monitoring


Terraform provides:

♻️ Reproducible deployments

📝 Version-controlled infrastructure

🔍 Reviewable infrastructure changes

🔐 Consistent security configuration

🧹 Automated resource cleanup

🚀 Faster environment provisioning

🚀 Deployment
Prerequisites

Install:

AWS CLI

Terraform

Git

An AWS account

Verify your AWS identity:

aws sts get-caller-identity

1. Clone the Repository
git clone https://github.com/CloudTechs-ai/AWS-Security-Monitoring-System.git

cd AWS-Security-Monitoring-System

2. Configure Secrets

Copy the example configuration:

cp secrets.tfvars.example secrets.tfvars


Edit the file with your own values.

Never commit secrets.tfvars.

3. Initialize Terraform
terraform init

4. Format & Validate
terraform fmt
terraform validate

5. Review the Deployment

Always inspect the Terraform plan before applying:

terraform plan

6. Deploy
terraform apply


Review the resources Terraform intends to create and confirm the deployment.

7. Destroy

When the environment is no longer required:

terraform destroy

📧 SNS Email Notifications

If email notifications are enabled, Amazon SNS sends a subscription confirmation message to the configured email address.

The recipient must confirm the subscription before receiving security notifications.

Terraform
    |
    v
SNS Subscription
    |
    v
Confirmation Email
    |
    v
User Confirms
    |
    v
Security Alerts Enabled

🧪 Testing

After deployment, the detection pipeline can be tested by accessing the monitored secret.

Expected event flow:

AWS Secrets Manager
        |
        v
   GetSecretValue
        |
        v
     CloudTrail
        |
        v
 CloudWatch Logs
        |
        v
  Metric Filter
        |
        v
 Security Metric
        |
        v
 CloudWatch Alarm
        |
        v
       SNS


This provides an end-to-end test of the monitoring architecture.

🛡️ Security Design

The project demonstrates several cloud security principles.

Defense in Depth

Multiple AWS services contribute to the security monitoring architecture.

IAM
 |
 v
CloudTrail
 |
 v
CloudWatch
 |
 +---- Logs
 |
 +---- Metrics
 |
 +---- Alarms
 |
 v
SNS
 |
 v
Security Notification

Least Privilege

IAM roles are scoped to the AWS services and resources that require access.

Centralized Logging

CloudTrail provides an auditable source of AWS API activity.

Secure Storage

S3 provides durable storage for CloudTrail audit logs.

Secret Isolation

Sensitive application values are stored through AWS Secrets Manager rather than hard-coded into infrastructure.

Automated Detection

CloudWatch transforms security events into metrics and alarms.

Infrastructure Reproducibility

Terraform allows the environment to be recreated from source-controlled configuration.

📈 SRE & Observability
Principle	Implementation
Observability	CloudTrail + CloudWatch
Logging	CloudWatch Logs + S3
Metrics	CloudWatch Metric Filters
Alerting	CloudWatch Alarms + SNS
Auditability	CloudTrail
Automation	Terraform
Incident Detection	Security Event Filters
Secret Management	AWS Secrets Manager
Access Control	IAM
Infrastructure Lifecycle	Terraform
🧰 Technology Stack
☁️ AWS

AWS CloudTrail

Amazon CloudWatch

Amazon CloudWatch Logs

Amazon S3

Amazon SNS

AWS Secrets Manager

AWS IAM

🏗️ Infrastructure

Terraform

AWS CLI

Git

GitHub

🔐 Security

Cloud security monitoring

Audit logging

IAM

Least privilege

Secrets management

Security event detection

Automated alerting

⚙️ Operations

Observability

Monitoring

Alerting

Incident detection

Infrastructure automation

Operational logging

Infrastructure lifecycle management

📁 Repository Structure
AWS-Security-Monitoring-System/
|
+-- main.tf
+-- variables.tf
+-- outputs.tf
+-- secrets.tfvars.example
+-- .gitignore
+-- .terraform.lock.hcl
+-- README.md


Terraform's local working directory and state files should not be committed to GitHub.

⚠️ Security Considerations

Never commit sensitive files such as:

terraform.tfstate
terraform.tfstate.*
*.tfvars
*.tfvars.json


The repository should contain:

secrets.tfvars.example


but not:

secrets.tfvars


Terraform state can contain sensitive infrastructure information and potentially secret values.

For production environments, Terraform state should be stored in a secured remote backend with appropriate encryption and access controls.

🔮 Future Enhancements

Potential improvements include:

AWS Security Hub integration

Amazon GuardDuty integration

AWS WAF monitoring

VPC Flow Logs

Lambda-based remediation

Automated incident response

Slack / Microsoft Teams notifications

SIEM integration

Amazon OpenSearch dashboards

Multi-account monitoring

Cross-account CloudTrail

Automated compliance checks

Terraform modules

Policy-as-code

GitHub Actions CI/CD

Automated security testing

💼 Skills Demonstrated

This project demonstrates practical experience with:

AWS Security
CloudTrail
CloudWatch
S3
SNS
Secrets Manager
IAM

Infrastructure as Code
Terraform

Security Engineering
Audit Logging
Secret Management
Least Privilege
Event Detection
Automated Alerting

SRE / Operations
Observability
Monitoring
Incident Detection
Infrastructure Automation
Operational Logging

⭐ Project Highlights
🔐 Security

Automated monitoring of sensitive AWS API activity.

🏗️ Infrastructure as Code

The AWS monitoring environment is provisioned through Terraform.

📊 Observability

CloudTrail, CloudWatch Logs, metrics, and alarms provide centralized visibility.

🚨 Automated Detection

Security events can automatically generate notifications through SNS.

♻️ Reproducibility

Infrastructure configuration and resource naming are designed for repeatable deployments across AWS accounts.

🧠 Engineering Focus

Combines:

Cloud Security + AWS + Terraform + IAM + Observability + Automation

📌 Project Summary

The AWS Security Monitoring System demonstrates how AWS-native services can be integrated into a repeatable security monitoring architecture.

The core workflow is:

COLLECT
   |
   v
CloudTrail
   |
   v
STORE
   |
   +----> S3
   |
   +----> CloudWatch Logs
             |
             v
          DETECT
             |
             v
       Metric Filters
             |
             v
          ANALYZE
             |
             v
      CloudWatch Alarms
             |
             v
           ALERT
             |
             v
            SNS

Built With
AWS
  +
Terraform
  +
Cloud Security
  +
Observability
  +
Automation

<p align="center"> <strong>🛡️ Built to demonstrate practical AWS Security Engineering, Infrastructure as Code, and Cloud Observability.</strong> </p>

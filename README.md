🛡️ AWS Security Monitoring System
Automated Cloud Security Monitoring & Alerting with AWS + Terraform
<p align="center"> <img src="https://img.shields.io/badge/AWS-Cloud-orange?logo=amazon-aws" alt="AWS"> <img src="https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform" alt="Terraform"> <img src="https://img.shields.io/badge/CloudTrail-Audit-blue" alt="CloudTrail"> <img src="https://img.shields.io/badge/CloudWatch-Monitoring-blue" alt="CloudWatch"> <img src="https://img.shields.io/badge/Security-Automation-red" alt="Security"> </p> <p align="center"> <strong>An Infrastructure-as-Code security monitoring platform that detects sensitive AWS activity, stores audit logs, generates security metrics, and automatically delivers alerts.</strong> </p>
📌 Overview
The AWS Security Monitoring System is a cloud security and observability platform built using AWS-native services and Terraform.

The project creates an automated security monitoring pipeline capable of:

🔍 Capturing AWS API activity with CloudTrail

📊 Centralizing events with CloudWatch Logs

🚨 Detecting sensitive events with CloudWatch Metric Filters

🔔 Triggering automated notifications through SNS

🔐 Managing sensitive values with AWS Secrets Manager

🗄️ Storing CloudTrail audit logs in Amazon S3

🔑 Controlling service access through IAM

🏗️ Provisioning the entire environment with Terraform

The goal is to demonstrate practical AWS security engineering, Infrastructure as Code, observability, and automated incident detection.

🏗 Architecture
The system follows this flow:

<img width="506" height="225" alt="AWS-Security-Pipeline" src="https://github.com/user-attachments/assets/58797f82-312e-4af2-b2c5-312f8f308ae0" />

🎯 What This Project Does
Capability	AWS Service	Purpose
API auditing	CloudTrail	Records AWS API activity
Log aggregation	CloudWatch Logs	Centralizes security events
Event detection	Metric Filters	Detects sensitive API operations
Alerting	CloudWatch Alarms	Evaluates security metrics
Notifications	SNS	Sends security alerts
Audit storage	S3	Retains CloudTrail logs
Secret management	Secrets Manager	Stores sensitive configuration
Access control	IAM	Controls AWS service permissions
Automation	Terraform	Provisions the entire environment

🔐 Sensitive Secret Detection
One of the primary detection workflows monitors access to AWS Secrets Manager.

When a secret is accessed:

Secrets Manager
       │
       ▼
  GetSecretValue
       │
       ▼
   CloudTrail
       │
       ▼
CloudWatch Logs
       │
       ▼
 Metric Filter
       │
       ▼
Security Metric
       │
       ▼
CloudWatch Alarm
       │
       ▼
      SNS
       │
       ▼
Email Notification

The Terraform configuration creates a CloudWatch metric filter for:

GetSecretValue

This converts a raw CloudTrail event into a measurable CloudWatch security metric.

🔍 CloudTrail
AWS CloudTrail provides the audit layer for the monitoring system.

The project configures CloudTrail to support:

Multi-region logging

Management events

Read/write API activity

CloudWatch integration

S3 audit storage

Log file validation

CloudTrail acts as the primary source of security event data for the monitoring pipeline.

📊 CloudWatch
Amazon CloudWatch provides the detection and monitoring layer.

The project uses:

CloudWatch Logs
Centralizes CloudTrail events for analysis.

Metric Filters
Search CloudTrail events for specific security-sensitive operations.

Current detection:

GetSecretValue

CloudWatch Alarms
Evaluate security metrics and trigger notifications when configured thresholds are reached.

🚨 Automated Alerting
Amazon SNS provides the notification layer.

The alert workflow is:

Security Event
      │
      ▼
  CloudTrail
      │
      ▼
CloudWatch Logs
      │
      ▼
Metric Filter
      │
      ▼
CloudWatch Alarm
      │
      ▼
     SNS
      │
      ▼
Email Notification

This removes the need for engineers to continuously inspect CloudTrail logs manually.

🗄️ S3 Audit Storage
Amazon S3 provides durable storage for CloudTrail logs.

The infrastructure is designed to provide:

🔒 Encryption

🗂️ Versioning

🔑 Restricted access

📋 CloudTrail-specific bucket policies

🌎 Multi-region CloudTrail logging

The S3 bucket name is generated using the AWS account ID and a unique suffix so that different users can deploy the project without manually selecting a globally unique bucket name.

Example:

cloudtechs-security-monitoring-123456789012-a7f32c91

🔑 IAM & Least Privilege
The project creates a dedicated IAM role for the CloudTrail → CloudWatch integration.

CloudTrail
    │
    ▼
IAM Service Role
    │
    ▼
CloudWatch Logs

The role provides the permissions CloudTrail requires to create log streams and publish log events.

This demonstrates the principle of least privilege by separating AWS service permissions from the user's own IAM credentials.

🔐 Secrets Management
Sensitive values are handled through Terraform variables and AWS Secrets Manager.

Example variables include:

api_key
oauth_token
other_secret

Sensitive Terraform variables are marked appropriately and should never be committed to source control.

The repository includes an example configuration:

secrets.tfvars.example

Users should create their own local:

secrets.tfvars

and keep it out of Git.

🏗️ Infrastructure as Code
The entire environment is provisioned using Terraform.

Deployment workflow
          Terraform
              │
              ▼
      terraform init
              │
              ▼
     terraform validate
              │
              ▼
       terraform plan
              │
              ▼
      terraform apply
              │
              ▼
    AWS Infrastructure
              │
              ▼
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

2. Initialize Terraform
terraform init

3. Format & Validate
terraform fmt
terraform validate

4. Review the Deployment
Always inspect the Terraform plan before applying:

terraform plan

5. Deploy
terraform apply

Review the resources Terraform intends to create and confirm the deployment.

6. Destroy
When the environment is no longer needed:

terraform destroy

📧 SNS Email Notifications
If email notifications are enabled, AWS SNS will send a subscription confirmation message to the configured address.

The recipient must confirm the subscription before receiving notifications.

Terraform
    │
    ▼
SNS Subscription
    │
    ▼
Confirmation Email
    │
    ▼
User Confirms
    │
    ▼
Security Alerts Enabled

🧪 Testing
After deployment, the detection pipeline can be tested by accessing the monitored secret.

The expected event flow is:

AWS Secrets Manager
        │
        ▼
   GetSecretValue
        │
        ▼
     CloudTrail
        │
        ▼
 CloudWatch Logs
        │
        ▼
  Metric Filter
        │
        ▼
 Security Metric
        │
        ▼
 CloudWatch Alarm
        │
        ▼
       SNS

This provides an end-to-end test of the monitoring architecture.

🛡️ Security Design
The project demonstrates several cloud security principles.

Defense in Depth
Multiple AWS services contribute to the security monitoring architecture.

Least Privilege
IAM roles are scoped to the AWS services and resources that require access.

Centralized Logging
CloudTrail provides an auditable source of AWS API activity.

Secure Storage
S3 provides durable storage for audit logs.

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
Incident Detection	Security event filters
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
│
├── 📄 main.tf
├── 📄 variables.tf
├── 📄 outputs.tf
├── 📄 secrets.tfvars.example
├── 📄 .gitignore
├── 📄 .terraform.lock.hcl
└── 📄 README.md

.terraform/, Terraform state files, and local secret variable files should not be committed to GitHub.

⚠️ Security Considerations
Do not commit sensitive files such as:

terraform.tfstate
terraform.tfstate.*
*.tfvars
*.tfvars.json

The repository should contain:

secrets.tfvars.example

but not your actual:

secrets.tfvars

Terraform state can contain sensitive infrastructure information and secret values.

For production environments, Terraform state should be stored in a secured remote backend with appropriate encryption and access controls.

🔮 Future Enhancements
The architecture can be extended with:

 AWS Security Hub

 Amazon GuardDuty

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

AWS Cloud Architecture
        │
        ├── CloudTrail
        ├── CloudWatch
        ├── S3
        ├── SNS
        ├── Secrets Manager
        └── IAM

Infrastructure as Code
        │
        └── Terraform

Security Engineering
        │
        ├── Audit Logging
        ├── Secret Management
        ├── Least Privilege
        ├── Event Detection
        └── Automated Alerting

SRE / Operations
        │
        ├── Observability
        ├── Monitoring
        ├── Incident Detection
        └── Infrastructure Automation

⭐ Project Highlights
🔐 Security
Automated monitoring of sensitive AWS API activity.

🏗️ Infrastructure as Code
Entire AWS monitoring environment provisioned through Terraform.

📊 Observability
CloudTrail, CloudWatch Logs, metrics, and alarms provide centralized visibility.

🚨 Automated Detection
Security events can automatically generate notifications through SNS.

♻️ Reproducibility
Resource naming and infrastructure configuration are designed for repeatable deployments across AWS accounts.

🧠 Engineering Focus
Combines cloud security, automation, observability, IAM, and Infrastructure as Code into one practical AWS project.

📌 Project Summary
The AWS Security Monitoring System demonstrates how AWS-native services can be integrated into a repeatable security monitoring architecture.

The core workflow is:

COLLECT
   ↓
CloudTrail
   ↓
STORE
   ↓
S3 / CloudWatch
   ↓
DETECT
   ↓
Metric Filters
   ↓
ANALYZE
   ↓
CloudWatch Alarms
   ↓
ALERT
   ↓
SNS

Built with:

AWS + Terraform + Cloud Security + Observability + Automation

<p align="center"> <strong>Built to demonstrate practical AWS Security Engineering and Infrastructure as Code.</strong> </p>

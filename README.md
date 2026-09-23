# AWS-Security-Monitoring-System
A fully automated Security Monitoring System on AWS built with CloudTrail, CloudWatch, SNS, AWS Secrets Manager, S3, and Terraform. This project provides end‑to‑end visibility into sensitive operations, secret access, API activity, and infrastructure events—paired with alerting, logging, and secure storage.

📌 Overview
The AWS‑Security‑Monitoring‑System is designed to detect, log, and alert on critical security‑related events across your AWS environment. It uses Infrastructure as Code (IaC) to ensure repeatable, auditable deployments and integrates tightly with AWS native security services.

🏗 Architecture
The system follows this flow:


<img width="506" height="225" alt="AWS-Security-Pipeline" src="https://github.com/user-attachments/assets/58797f82-312e-4af2-b2c5-312f8f308ae0" />


AWS Secrets Manager  
Tracks secret access and rotation events.

AWS CloudTrail  
Captures all API calls, including secret access, IAM changes, and console logins.

Amazon S3  
Stores CloudTrail logs securely with versioning and encryption.

Amazon CloudWatch Logs  
Receives CloudTrail events for real‑time filtering.

CloudWatch Metric Filters  
Detect suspicious patterns (e.g., root login, secret access, IAM policy changes).

CloudWatch Alarms  
Trigger alerts when filters match.

Amazon SNS  
Sends notifications to email, Slack, or webhook endpoints.

Terraform  
Automates provisioning of all AWS resources.

✨ Features
Terraform IaC — Automated provisioning of AWS security monitoring resources

CloudTrail Logging — Full API activity tracking

CloudWatch Monitoring — Real‑time log analysis and alerting

SNS Notifications — Email or webhook alerts

Secrets Manager Auditing — Track secret access and rotation

S3 Secure Storage — Encrypted, versioned log storage

Infrastructure Security — IAM roles, least privilege, secure defaults

AWS‑Security‑Monitoring‑System/
│── terraform/
├── main.tf
├── variables.tf
│── docs/
│── README.md

🔧 Prerequisites
AWS Account

IAM User with programmatic access

AWS CLI installed

Terraform installed

Email address for SNS alerts

🔐 Configure AWS Credentials
Before running Terraform, configure your AWS credentials:

bash
aws configure
You will be prompted for:

AWS Access Key ID

AWS Secret Access Key

Default region name

Default output format

These credentials must belong to an IAM user with permissions such as:

cloudtrail:*

cloudwatch:*

sns:*

s3:*

iam:PassRole

iam:CreateRole

🚀 Terraform Setup & Deployment
Run these commands inside the project directory:

bash
terraform init
terraform validate
terraform plan
terraform apply
To destroy the environment:

bash
terraform destroy

📡 Alerts & Monitoring
Once deployed:

CloudTrail logs flow into CloudWatch Logs

Metric filters detect suspicious events

CloudWatch Alarms trigger

SNS sends alerts to your configured email

You will receive notifications for events such as:

Root account login

IAM policy changes

Access to Secrets Manager secrets

Failed authentication attempts

Console logins from unusual locations

🤝 Contributing
Pull requests are welcome.
For major changes, please open an issue first to discuss what you’d like to modify.

🎯 Project Objectives

The system was designed to demonstrate how AWS infrastructure can be continuously monitored for security-sensitive activity without relying on manual inspection of logs.

The primary objectives are:

Centralize AWS API activity
Detect security-sensitive events
Automatically generate alerts
Securely retain audit logs
Monitor IAM activity
Track access to sensitive secrets
Automate the entire security monitoring infrastructure
Create repeatable and auditable deployments
Apply least-privilege security principles
Improve visibility for incident response and troubleshooting
🔍 AWS CloudTrail

AWS CloudTrail provides the primary audit trail for the environment.

The system captures API activity including:

AWS console logins
IAM changes
Authentication activity
Secrets Manager access
Infrastructure modifications
Security-sensitive API operations

CloudTrail provides the underlying event data used by the monitoring pipeline to identify potentially suspicious activity.

📊 CloudWatch Monitoring

CloudTrail events are forwarded into Amazon CloudWatch Logs for centralized monitoring and analysis.

CloudWatch is used to:

Collect security events
Search and analyze logs
Create metric filters
Detect security-sensitive activity
Generate alarms
Support incident investigation

Example detection patterns include:

Root account login
IAM policy changes
IAM role modifications
Secrets Manager access
Failed authentication attempts
Console authentication events
🚨 Automated Alerting

CloudWatch Metric Filters identify specific security events and convert matching log activity into measurable metrics.

CloudWatch Alarms monitor those metrics and trigger notifications through Amazon SNS.

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
SNS Notification
      │
      ▼
Security / Engineering Team

This creates an automated detection pipeline that can notify engineers without requiring continuous manual log inspection.

🔐 AWS Secrets Manager Monitoring

AWS Secrets Manager is used to manage sensitive application credentials and secrets.

The monitoring architecture tracks Secrets Manager API activity through CloudTrail, allowing security teams to identify events such as:

Secret retrieval
Secret modifications
Secret rotation activity
Unauthorized or unexpected access attempts

This provides additional visibility around sensitive credentials and helps support security investigations.

🗄️ Secure S3 Log Storage

Amazon S3 provides durable storage for CloudTrail audit logs.

The implementation uses:

Encryption
Object versioning
Restricted access
IAM-controlled permissions

The goal is to maintain an auditable history of AWS activity while protecting security logs from unnecessary exposure or accidental modification.

🔑 IAM & Least Privilege

The infrastructure applies IAM security principles to control access to AWS resources.

Security considerations include:

Role-based permissions
Least-privilege access
Controlled service permissions
Restricted access to security logs
Controlled access to monitoring resources
Separation of infrastructure responsibilities

IAM permissions are provisioned through Terraform where applicable, keeping security configuration version controlled alongside the infrastructure.

🏗️ Infrastructure as Code

The entire monitoring environment is deployed using Terraform.

Terraform manages the AWS resources required for:

CloudTrail
CloudWatch Logs
CloudWatch Metric Filters
CloudWatch Alarms
SNS
S3
IAM
Secrets Manager integration

This provides:

Repeatable deployments
Version-controlled infrastructure
Auditable configuration changes
Reduced manual configuration
Consistent environments
Faster infrastructure recovery

The architecture can be destroyed and recreated using Terraform without manually rebuilding the monitoring environment.

🔄 Infrastructure Deployment Workflow
Terraform Configuration
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
 AWS Security Infrastructure
          │
          ▼
 Automated Monitoring
🧪 Security Event Detection

The monitoring system is designed to identify events such as:

Event	Detection
Root account login	CloudTrail → CloudWatch
IAM policy modification	CloudTrail → Metric Filter
IAM role changes	CloudTrail → Metric Filter
Secrets Manager access	CloudTrail → CloudWatch
Failed authentication	CloudTrail → CloudWatch
Console authentication	CloudTrail → CloudWatch
Infrastructure API changes	CloudTrail → CloudWatch

These detections can be extended to support additional security and compliance requirements.

📈 SRE & Observability Principles

This project applies several SRE practices to cloud security infrastructure:

Observability

Centralized logs and metrics provide visibility into infrastructure activity.

Alerting

Automated alarms notify engineers when predefined security conditions occur.

Incident Response

Security events provide actionable information that can be used during investigation and troubleshooting.

Infrastructure Automation

Terraform enables consistent and repeatable infrastructure changes.

Auditability

Version-controlled infrastructure and CloudTrail logs provide traceability for infrastructure and security changes.

Reliability

Automated monitoring reduces dependence on manual log inspection and creates continuous visibility into AWS activity.

🛡️ Security Architecture

The system follows a defense-in-depth approach:

IAM
 │
 ├── Access Control
 │
 ▼
CloudTrail
 │
 ├── Audit Logging
 │
 ▼
CloudWatch
 │
 ├── Detection
 ├── Metrics
 └── Alerting
 │
 ▼
SNS
 │
 └── Incident Notification

S3
 └── Long-Term Audit Storage

Secrets Manager
 └── Sensitive Credential Management
🧰 Technology Stack
AWS
AWS CloudTrail
Amazon CloudWatch
Amazon CloudWatch Logs
Amazon S3
Amazon SNS
AWS Secrets Manager
AWS IAM
Infrastructure
Terraform
Infrastructure as Code
AWS CLI
GitHub
Security
Cloud security monitoring
Audit logging
IAM
Least privilege
Secret management
Security event detection
Automated alerting
Compliance-oriented logging
SRE / Operations
Observability
Monitoring
Alerting
Incident detection
Troubleshooting
Infrastructure automation
Operational logging
🚀 Deployment
Prerequisites

Install:

AWS CLI
Terraform
Git
An AWS account
An email address for SNS notifications

Configure AWS credentials:

aws configure

Validate the configured identity:

aws sts get-caller-identity
Deploy with Terraform

Clone the repository:

git clone https://github.com/CloudTechs-ai/AWS-Security-Monitoring-System.git
cd AWS-Security-Monitoring-System

Initialize Terraform:

terraform init

Validate the configuration:

terraform validate

Review the deployment:

terraform plan

Deploy:

terraform apply
Destroy the Environment

To remove the infrastructure:

terraform destroy
📬 Alert Workflow

After deployment, security events are processed through the monitoring pipeline:

AWS API Event
     ↓
CloudTrail
     ↓
CloudWatch Logs
     ↓
Metric Filter
     ↓
CloudWatch Alarm
     ↓
SNS
     ↓
Engineer Notification

This allows engineers to receive notifications when predefined security-sensitive events occur.

🔮 Future Improvements

Potential enhancements include:

AWS Security Hub integration
GuardDuty integration
AWS WAF monitoring
VPC Flow Logs
Automated incident response
Lambda-based remediation
Slack/Teams integration
SIEM integration
OpenSearch security dashboards
Multi-account AWS monitoring
Cross-region logging
Automated compliance checks
Terraform modules
Policy-as-code
Automated security testing
📚 Skills Demonstrated
AWS Cloud Architecture
AWS Security
Terraform / Infrastructure as Code
CloudTrail
CloudWatch
IAM
Secrets Manager
S3
SNS
Security Monitoring
Observability
Incident Detection
Infrastructure Automation
SRE Practices
Cloud Compliance
Least-Privilege Security
Infrastructure Documentation

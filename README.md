# AWS-Security-Monitoring-System
A fully automated Security Monitoring System on AWS built with CloudTrail, CloudWatch, SNS, AWS Secrets Manager, S3, and Terraform. This project provides end‑to‑end visibility into sensitive operations, secret access, API activity, and infrastructure events—paired with alerting, logging, and secure storage.

📌 Overview
The AWS‑Security‑Monitoring‑System is designed to detect, log, and alert on critical security‑related events across your AWS environment. It uses Infrastructure as Code (IaC) to ensure repeatable, auditable deployments and integrates tightly with AWS native security services.

🏗 Architecture
The system follows this flow:

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

📂 Project Structure Code
AWS-Security-Monitoring-System/
│── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── cloudtrail.tf
│   ├── cloudwatch.tf
│   ├── sns.tf
│   ├── s3.tf
│   └── iam.tf
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

📘 Certifications & Skills Demonstrated

HashiCorp Certified Terraform Associate

AWS Solutions Architect Associate

Security+

Cloud Architecture

Platform Engineering

Site Reliability Engineering (SRE)

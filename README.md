# AWS-Security-Monitoring-System
A fully automated Security Monitoring System on AWS built with CloudTrail, CloudWatch, SNS, AWS Secrets Manager, S3, and Terraform. This project provides end‑to‑end visibility into sensitive operations, secret access, API activity, and infrastructure events—paired with alerting, logging, and secure storage.

📌 Overview
The AWS‑Security‑Monitoring‑System is designed to detect, log, and alert on critical security‑related events across your AWS environment. It uses Infrastructure as Code (IaC) to ensure repeatable, auditable deployments and integrates tightly with AWS native security services.

🏗 Architecture
The system follows this flow:


<img width="506" height="225" alt="AWS-Security-Pipeline" src="https://github.com/user-attachments/assets/58797f82-312e-4af2-b2c5-312f8f308ae0" />

The platform uses Terraform to provision and manage:

AWS CloudTrail

Amazon CloudWatch Logs

CloudWatch Metric Filters

CloudWatch Alarms

Amazon SNS

Amazon S3

AWS Secrets Manager

AWS IAM

The system focuses on a practical security engineering workflow:

AWS API Activity
       │
       ▼
   CloudTrail
       │
       ├──────────────► S3 Audit Storage
       │
       ▼
CloudWatch Logs
       │
       ▼
Metric Filters
       │
       ▼
CloudWatch Alarm
       │
       ▼
      SNS
       │
       ▼
Security Notification

The entire infrastructure can be provisioned, reviewed, modified, and destroyed through Terraform.

💼 Why I Built This
This project demonstrates practical experience across several areas of cloud engineering and security:

Cloud Security — monitoring sensitive AWS activity

Infrastructure as Code — reproducible Terraform deployments

Observability — centralized logging, metrics, and alerting

IAM — service roles and controlled AWS permissions

Incident Detection — automated detection of sensitive API activity

Secrets Management — secure handling through AWS Secrets Manager

Auditability — CloudTrail-based API activity logging

AWS Architecture — integrating multiple managed services into one security pipeline

Operational Engineering — automated infrastructure deployment and monitoring

The goal is to demonstrate how security controls can be implemented as infrastructure rather than relying entirely on manual AWS console configuration.

🏗️ Architecture
High-Level Architecture
                         AWS ACCOUNT
                              │
                              ▼
                    ┌──────────────────┐
                    │   AWS CloudTrail │
                    │                  │
                    │ API Activity     │
                    │ Management Events │
                    │ Secret Access    │
                    │ Authentication  │
                    └────────┬─────────┘
                             │
                ┌────────────┴────────────┐
                │                         │
                ▼                         ▼
       ┌─────────────────┐       ┌──────────────────┐
       │    Amazon S3    │       │ CloudWatch Logs  │
       │                 │       │                  │
       │ Audit Storage   │       │ Centralized Logs │
       │ Versioning      │       │ Event Analysis  │
       │ Encryption      │       │                  │
       └─────────────────┘       └────────┬─────────┘
                                         │
                                         ▼
                                ┌──────────────────┐
                                │  Metric Filter   │
                                │                  │
                                │ GetSecretValue   │
                                └────────┬─────────┘
                                         │
                                         ▼
                                ┌──────────────────┐
                                │ CloudWatch Alarm │
                                └────────┬─────────┘
                                         │
                                         ▼
                                ┌──────────────────┐
                                │       SNS        │
                                │                  │
                                │ Email Alerts     │
                                └──────────────────┘

                     Terraform
                         │
                         ▼
              Infrastructure Provisioning

🔍 Security Monitoring
AWS CloudTrail
CloudTrail provides the audit layer of the platform.

The trail is configured to capture AWS management activity and forward events into both:

Amazon S3 for durable audit storage

CloudWatch Logs for near-real-time analysis

The trail is configured for:

Multi-region logging

Management events

Read and write activity

Log file validation

CloudWatch integration

S3 audit storage

This creates an auditable record of AWS API activity that can be analyzed during security investigations.

🔐 Secrets Manager Monitoring
The project specifically monitors access to secrets through AWS Secrets Manager.

CloudTrail records Secrets Manager API activity, including operations such as:

GetSecretValue

A CloudWatch Logs metric filter detects GetSecretValue events and converts them into the:

SecurityMetrics / SecretAccessed

metric.

The CloudWatch alarm then evaluates the metric and publishes an alert through SNS when the configured threshold is reached.

Detection Pipeline
Secrets Manager API
        │
        ▼
    CloudTrail
        │
        ▼
CloudWatch Logs
        │
        ▼
 GetSecretValue
        │
        ▼
 Metric Filter
        │
        ▼
SecretAccessed Metric
        │
        ▼
CloudWatch Alarm
        │
        ▼
       SNS

This demonstrates a practical example of turning raw AWS audit events into an automated security detection.

🚨 Automated Alerting
Amazon SNS provides the notification layer.

When the CloudWatch alarm detects the configured security event, it publishes to the project's SNS topic.

An optional email subscription can be configured during deployment.

Example:

terraform apply -var="notification_email=your-email@example.com"

AWS then sends an SNS subscription confirmation email to the specified address.

The notification architecture is:

CloudWatch Alarm
       │
       ▼
   SNS Topic
       │
       ▼
Email Notification

🗄️ Secure Audit Storage
CloudTrail logs are stored in Amazon S3.

The Terraform configuration provisions:

S3 bucket encryption

S3 versioning

CloudTrail-specific bucket permissions

Restricted CloudTrail write paths

Account-specific bucket naming

The bucket name is generated using the AWS account ID and a Terraform-generated suffix, avoiding hard-coded globally unique names.

Example:

cloudtechs-security-monitoring-123456789012-a7f32c91

This allows different AWS accounts to deploy the project without requiring manual bucket-name changes.

🔑 IAM & Access Control
The project uses IAM to provide CloudTrail with the permissions required to publish logs to CloudWatch.

The Terraform configuration creates a dedicated service role for:

CloudTrail
    │
    ▼
IAM Role
    │
    ▼
CloudWatch Logs

The role is scoped to the project's CloudWatch log group and grants the service only the log operations required by the integration.

This demonstrates the principle of least privilege by separating AWS service permissions from the user's own credentials.

🔒 Secrets & Configuration Management
The project does not require users to commit API keys or credentials to the repository.

Terraform can generate demonstration secret values automatically through the Random provider.

Users can also provide their own values through variables when required.

Sensitive Terraform variables are marked:

sensitive = true

A secrets.tfvars.example template is provided for deployment configuration.

Actual secret files should remain local and are excluded through .gitignore.

Important
Terraform state can contain sensitive values. Production deployments should therefore store Terraform state in a secured backend with appropriate access controls.

♻️ Reusable Infrastructure
A major design goal of this project is reproducible deployment.

The infrastructure avoids hard-coded resource names by generating unique identifiers for:

S3 buckets

Secrets Manager secrets

CloudTrail trails

CloudWatch log groups

IAM roles

SNS topics

CloudWatch alarms

This allows the same Terraform configuration to be deployed into different AWS accounts without manually modifying resource names.

🏗️ Infrastructure as Code
Terraform manages the AWS infrastructure declaratively.

Deployment lifecycle
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
    AWS Infrastructure
          │
          ▼
 Security Monitoring Pipeline

The infrastructure can also be removed using:

terraform destroy

This provides a repeatable workflow for provisioning and teardown.

🚀 Getting Started
Prerequisites
Install:

AWS CLI

Terraform >= 1.8

Git

An AWS account

Verify AWS credentials:

aws sts get-caller-identity

The returned account should be the AWS account where the monitoring infrastructure will be deployed.

Clone the Repository
git clone https://github.com/CloudTechs-ai/AWS-Security-Monitoring-System.git

cd AWS-Security-Monitoring-System

Initialize Terraform
terraform init

Terraform will install the AWS and Random providers.

The .terraform.lock.hcl file should be committed to the repository to keep provider versions reproducible.

Configure Optional Email Alerts
Copy the example configuration:

cp secrets.tfvars.example secrets.tfvars

Edit:

secrets.tfvars

and configure your email address.

Example:

aws_region = "us-east-1"

notification_email = "your-email@example.com"

The actual secrets.tfvars file should never be committed to GitHub.

Validate
terraform fmt
terraform validate

Review Infrastructure Changes
Always review the Terraform plan before applying:

terraform plan

Deploy
terraform apply

Terraform will display the resources it plans to create and request confirmation before deployment.

📊 Terraform Outputs
After deployment, Terraform provides useful information such as:

AWS Account ID
AWS Region
S3 Bucket Name
CloudTrail Name
CloudWatch Log Group
SNS Topic ARN
Secrets Manager Secret Name
SNS Email Subscription Status

These outputs make it easier to identify and troubleshoot the deployed infrastructure.

🧪 Testing the Detection Pipeline
After deployment, the monitoring pipeline can be tested by accessing the Secrets Manager secret.

The expected flow is:

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
SecretAccessed
      │
      ▼
CloudWatch Alarm
      │
      ▼
SNS

The CloudWatch alarm evaluates the metric over its configured period and can generate an SNS notification when the threshold is reached.

🛡️ Security Design
The project demonstrates several security engineering concepts:

Defense in Depth
Multiple AWS services contribute to the monitoring architecture rather than relying on a single security control.

Least Privilege
Service roles are scoped to the resources and actions required for the CloudTrail → CloudWatch integration.

Centralized Audit Logging
CloudTrail provides a centralized source of AWS API activity.

Secure Log Storage
S3 provides durable storage for audit logs with encryption and versioning.

Secret Isolation
Secrets are stored in AWS Secrets Manager instead of being embedded directly in application infrastructure.

Automated Detection
CloudWatch transforms raw log events into measurable security metrics and alarms.

Infrastructure Reproducibility
Terraform allows the environment to be recreated consistently from source-controlled configuration.

📈 SRE & Observability Concepts
This project also demonstrates core SRE and operations concepts.

Principle	Implementation
Observability	CloudTrail + CloudWatch Logs
Metrics	CloudWatch Metric Filters
Alerting	CloudWatch Alarms + SNS
Auditability	CloudTrail + S3
Automation	Terraform
Reliability	Automated monitoring
Incident Detection	Security event metric filters
Configuration Management	Infrastructure as Code
Secret Management	AWS Secrets Manager
Access Control	IAM

🧰 Technology Stack
Cloud
AWS

AWS Services
AWS CloudTrail

Amazon CloudWatch

Amazon CloudWatch Logs

Amazon S3

Amazon SNS

AWS Secrets Manager

AWS IAM

Infrastructure
Terraform

AWS CLI

Git

GitHub

Security
Cloud security monitoring

Audit logging

IAM

Least privilege

Secrets management

Security event detection

Automated alerting

Compliance-oriented logging

Operations
Observability

Monitoring

Alerting

Incident detection

Infrastructure automation

Operational logging

Infrastructure lifecycle management

🧠 Engineering Skills Demonstrated
This project demonstrates practical experience with:

AWS Cloud Architecture

Cloud Security

Infrastructure as Code

Terraform

IAM

CloudTrail

CloudWatch

Secrets Manager

S3

SNS

Security Monitoring

Observability

Incident Detection

Automated Alerting

Least-Privilege Design

Infrastructure Automation

Git/GitHub

Operational Troubleshooting

🔮 Future Enhancements
Potential next iterations include:

AWS Security Hub integration

Amazon GuardDuty integration

AWS WAF monitoring

VPC Flow Logs

Lambda-based automated remediation

Automated incident response

Slack / Microsoft Teams integration

SIEM integration

OpenSearch security dashboards

Multi-account AWS monitoring

Cross-account CloudTrail

Cross-region security aggregation

Automated compliance checks

Terraform modules

Policy-as-code

Security testing in CI/CD

GitHub Actions deployment pipeline

📁 Project Structure
AWS-Security-Monitoring-System/
│
├── main.tf
├── variables.tf
├── secrets.tfvars.example
├── .gitignore
├── .terraform.lock.hcl
└── README.md

⚠️ Security Considerations
Never commit:

terraform.tfstate
terraform.tfstate.*
*.tfvars
*.tfvars.json

unless the file is specifically intended to be a non-sensitive example.

The repository should contain:

secrets.tfvars.example

but not:

secrets.tfvars

Terraform state should be treated as sensitive because it can contain infrastructure configuration and secret values.

For production environments, use a secured remote Terraform backend with appropriate encryption and access controls.

👨‍💻 What This Project Demonstrates
This project was built to demonstrate the practical intersection of:

Cloud Security
      +
AWS Architecture
      +
Infrastructure as Code
      +
Observability
      +
Incident Detection
      +
Automation

Rather than manually configuring individual AWS services, the project treats the security monitoring environment as version-controlled infrastructure that can be reviewed, deployed, tested, and reproduced through Terraform.

⭐ Key Takeaway
The AWS Security Monitoring System demonstrates how native AWS services can be combined into an automated security monitoring pipeline capable of:

collecting → storing → analyzing → detecting → alerting

on security-sensitive AWS activity.

It is designed as a practical demonstration of AWS security engineering, Terraform automation, observability, IAM, and operational monitoring.

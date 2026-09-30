<div align="center">

# AWS Security Monitoring System

**Automated cloud security detection and alerting, provisioned entirely with Terraform.**

![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform&logoColor=white)
![CloudTrail](https://img.shields.io/badge/CloudTrail-Audit_Logging-232F3E)
![CloudWatch](https://img.shields.io/badge/CloudWatch-Detection_&_Alerting-232F3E)
![Security](https://img.shields.io/badge/Focus-Cloud_Security-D13212)

</div>

---

## Overview

This project deploys an end-to-end security monitoring pipeline on AWS. It captures API activity with CloudTrail, centralizes events in CloudWatch Logs, converts sensitive operations into metrics, and sends alerts through SNS, all defined as version-controlled Terraform.

**The problem it solves:** sensitive actions in an AWS account (such as reading a secret) are easy to miss when engineers have to search raw audit logs by hand. This system turns those events into alerts automatically.

**Primary detection:** any call to `GetSecretValue` against AWS Secrets Manager triggers an email notification.

### Key Features

| Capability | AWS Service | Purpose |
|---|---|---|
| API auditing | CloudTrail | Multi-region record of management events (read and write) |
| Log aggregation | CloudWatch Logs | Centralized security events for investigation |
| Event detection | Metric Filters | Converts `GetSecretValue` events into a measurable metric |
| Alert evaluation | CloudWatch Alarms | Fires when the metric reaches the configured threshold |
| Notification | SNS | Delivers email alerts |
| Audit retention | S3 | Encrypted, versioned, access-restricted log storage |
| Secret storage | Secrets Manager | Holds sensitive configuration outside of code |
| Access control | IAM | Dedicated service role for CloudTrail-to-CloudWatch delivery |
| Provisioning | Terraform | Reproducible, reviewable infrastructure |

---

## Architecture


<img width="506" height="225" alt="AWS-Security-Pipeline" src="https://github.com/user-attachments/assets/58797f82-312e-4af2-b2c5-312f8f308ae0" />

### Detection Flow

1. A principal calls `GetSecretValue` on a secret in Secrets Manager.
2. CloudTrail records the API call and delivers it to S3 and CloudWatch Logs.
3. A metric filter matches the event and increments a custom metric.
4. A CloudWatch alarm evaluates the metric against its threshold.
5. SNS sends an email notification to the subscribed address.

---

## Security Design

- **Centralized, tamper-evident logging:** multi-region CloudTrail with log file validation enabled.
- **Secure log storage:** S3 bucket with encryption, versioning, restricted access, and a CloudTrail-specific bucket policy.
- **Least privilege:** a dedicated IAM service role grants CloudTrail only the permissions needed to create log streams and publish events to CloudWatch Logs.
- **Secret isolation:** sensitive values are passed through Terraform `sensitive` variables and stored in Secrets Manager, never hard-coded.
- **Globally unique bucket names:** generated from the AWS account ID plus a random suffix (for example `cloudtechs-security-monitoring-123456789012-a7f32c91`), so the project deploys in any account without edits.
- **Reproducibility:** the full environment can be created and destroyed from source control.

---

## Getting Started

### Prerequisites

| Tool | Purpose |
|---|---|
| [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) | Authenticate and test the pipeline |
| [Terraform](https://developer.hashicorp.com/terraform/install) | Provision the infrastructure |
| [Git](https://git-scm.com/downloads) | Clone the repository |
| An AWS account | Deployment target (IAM permissions to create the resources listed above) |

> **Cost note:** CloudTrail, CloudWatch, S3, and Secrets Manager are billed usage-based services. Run `terraform destroy` when you are finished.

### 1. Configure AWS credentials

```bash
aws configure
aws sts get-caller-identity   # confirm you are in the intended account
```

### 2. Clone the repository

```bash
git clone https://github.com/CloudTechs-ai/AWS-Security-Monitoring-System.git
cd AWS-Security-Monitoring-System
```

### 3. Configure variables and secrets

```bash
cp secrets.tfvars.example secrets.tfvars
```

Edit `secrets.tfvars` with your own values (for example `api_key`, `oauth_token`, `other_secret`, and the email address for alerts). This file is git-ignored. **Never commit it.**

### 4. Initialize, format, and validate

```bash
terraform init
terraform fmt
terraform validate
```

### 5. Review the plan

```bash
terraform plan -var-file="secrets.tfvars"
```

Read the plan carefully before continuing. `secrets.tfvars` is not loaded automatically by Terraform, so the `-var-file` flag is required.

### 6. Deploy

```bash
terraform apply -var-file="secrets.tfvars"
```

Type `yes` when prompted.

### 7. Confirm the SNS subscription

SNS sends a confirmation email to the configured address. **Open it and click *Confirm subscription*.** No alerts are delivered until you do.

---

## Testing the Detection Pipeline

Trigger the monitored event by reading the secret Terraform created:

```bash
aws secretsmanager get-secret-value --secret-id <SECRET_NAME_OR_ARN>
```

Find the secret name in the Terraform outputs or the Secrets Manager console.

**Expected result:** an alert email arrives after the alarm evaluates. CloudTrail delivery to CloudWatch Logs typically lags by several minutes, so allow some time.

**Where to verify each stage if no email arrives:**

| Stage | Where to check |
|---|---|
| Event captured | CloudTrail > Event history, or the CloudWatch log group |
| Metric recorded | CloudWatch > Metrics (custom namespace from the metric filter) |
| Alarm state | CloudWatch > Alarms (should move to `ALARM`) |
| Delivery | SNS > Subscriptions (status must be *Confirmed*) |

---

## Cleanup

```bash
terraform destroy -var-file="secrets.tfvars"
```

If the CloudTrail S3 bucket has versioned objects, you may need to empty it before destroy completes.

---

## Repository Structure

```
AWS-Security-Monitoring-System/
├── main.tf                   # Core resources: CloudTrail, CloudWatch, SNS, S3, IAM, Secrets Manager
├── variables.tf              # Input variables (sensitive values marked sensitive)
├── outputs.tf                # Useful resource outputs
├── secrets.tfvars.example    # Template for local secrets (copy to secrets.tfvars)
├── .terraform.lock.hcl       # Provider version lock
├── .gitignore                # Excludes state and secret files
└── README.md
```

---

## Security Considerations

Never commit the following (all are covered by `.gitignore`):

```
terraform.tfstate
terraform.tfstate.*
*.tfvars
*.tfvars.json
```

Terraform state can contain sensitive values. For production use, store state in an encrypted remote backend (for example S3 with DynamoDB locking) with restricted access.

---

## Roadmap

- [ ] Additional detections: IAM policy changes, root account usage, failed console logins
- [ ] Amazon GuardDuty and AWS Security Hub integration
- [ ] Lambda-based automated remediation
- [ ] Slack / Microsoft Teams notifications
- [ ] Multi-account and cross-account CloudTrail
- [ ] Reusable Terraform modules and remote state backend
- [ ] CI/CD with GitHub Actions (`fmt`, `validate`, and security scanning on pull requests)
- [ ] VPC Flow Logs and AWS WAF monitoring

---

## Skills Demonstrated

**Cloud Security:** audit logging, detection engineering, secrets management, least-privilege IAM
**AWS:** CloudTrail, CloudWatch (Logs, Metric Filters, Alarms), S3, SNS, Secrets Manager, IAM
**Infrastructure as Code:** Terraform (variables, sensitive inputs, lifecycle management, reproducible deployments)
**Operations / SRE:** observability, alerting, incident detection

---

<div align="center">

Built to demonstrate practical AWS security engineering, infrastructure as code, and cloud observability.

</div>

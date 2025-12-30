# HR Platform Infrastructure - Claude Code Session Guide

Terraform modules for deploying the HR Platform to AWS.

## Current State (as of 2025-12-30)

### Completed (Partial)
- [x] Basic module structure created
- [x] Networking module started (VPC, subnets, security groups)
- [x] ECS module started (cluster, service, task definition)

### TODO - Not Yet Implemented
- [ ] Complete networking module
- [ ] Complete ECS module
- [ ] RDS module (PostgreSQL)
- [ ] ALB module (Application Load Balancer)
- [ ] ECR module (Container Registry)
- [ ] S3 module (File storage)
- [ ] Secrets Manager module
- [ ] Environment configurations (dev, staging, prod)
- [ ] GitHub Actions workflows
- [ ] SSL/TLS certificates (ACM)
- [ ] CloudWatch logging and alarms
- [ ] IAM roles and policies

## Target Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         AWS VPC                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────┐    ┌─────────────────────────────────────┐│
│  │  Public Subnet  │    │         Private Subnet              ││
│  │                 │    │                                     ││
│  │  ┌───────────┐  │    │  ┌─────────────┐  ┌──────────────┐ ││
│  │  │    ALB    │──┼────┼─►│ ECS Fargate │  │     RDS      │ ││
│  │  │           │  │    │  │  (NestJS)   │──│  PostgreSQL  │ ││
│  │  └───────────┘  │    │  └─────────────┘  └──────────────┘ ││
│  │                 │    │                                     ││
│  │  ┌───────────┐  │    └─────────────────────────────────────┘│
│  │  │    NAT    │  │                                           │
│  │  │  Gateway  │  │    ┌─────────────────────────────────────┐│
│  │  └───────────┘  │    │              S3                     ││
│  └─────────────────┘    │         (File Storage)              ││
│                         └─────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

## Project Structure

```
hr-platform-infrastructure/
├── environments/
│   ├── dev/
│   │   ├── main.tf           # Module compositions
│   │   ├── variables.tf      # Environment variables
│   │   ├── terraform.tfvars  # Variable values (gitignored)
│   │   └── backend.tf        # S3 backend config
│   ├── staging/
│   └── prod/
├── modules/
│   ├── networking/           # VPC, subnets, NAT, SGs
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ecs/                  # ECS cluster, service, task
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── rds/                  # PostgreSQL RDS
│   ├── alb/                  # Application Load Balancer
│   ├── ecr/                  # Container Registry
│   ├── s3/                   # File storage buckets
│   └── secrets/              # Secrets Manager
└── .github/
    └── workflows/
        ├── terraform-plan.yml
        └── terraform-apply.yml
```

## Module Specifications

### Networking Module
- VPC with configurable CIDR (default: 10.0.0.0/16)
- 2 public subnets (for ALB, NAT)
- 2 private subnets (for ECS, RDS)
- NAT Gateway for private subnet internet access
- Security groups:
  - ALB: Allow 443 inbound from anywhere
  - ECS: Allow container port from ALB only
  - RDS: Allow 5432 from ECS only

### ECS Module
- Fargate launch type
- Task definition with secrets from Secrets Manager
- Service with ALB target group
- Auto-scaling based on CPU utilization
- CloudWatch logs

### RDS Module
- PostgreSQL 16
- Private subnet placement
- Encrypted storage
- Automated backups
- Parameter group for optimization

### ALB Module
- HTTPS listener (443)
- HTTP redirect to HTTPS
- Health check configuration
- SSL certificate from ACM

## Environment Variables Needed

```hcl
# terraform.tfvars (example)
project     = "xseed"
environment = "dev"
region      = "us-east-1"

vpc_cidr       = "10.0.0.0/16"
container_port = 3001

# RDS
db_instance_class = "db.t3.micro"
db_allocated_storage = 20

# ECS
ecs_cpu    = 256
ecs_memory = 512
ecs_desired_count = 1

# Domain (for SSL)
domain_name = "api.xseed.com"
certificate_arn = "arn:aws:acm:..."
```

## Commands

```bash
cd environments/dev

# Initialize
terraform init

# Plan changes
terraform plan -out=tfplan

# Apply changes
terraform apply tfplan

# Destroy (careful!)
terraform destroy
```

## Backend Configuration

Use S3 backend for state management:

```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "xseed-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "xseed-terraform-locks"
  }
}
```

## Related Repositories

| Repo | Purpose |
|------|---------|
| xseed-backend | NestJS API (containerized) |
| v0-next-js-app-router-frontend | Next.js frontend (Vercel) |

## Next Steps

1. Complete all Terraform modules
2. Create dev environment configuration
3. Set up S3 backend for state
4. Deploy to AWS
5. Configure GitHub Actions for CI/CD
6. Add monitoring and alerting

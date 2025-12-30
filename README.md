# HR Platform Infrastructure

Terraform modules for deploying the HR Platform to AWS.

## Architecture

- **VPC** with public/private subnets
- **ECS Fargate** for containerized API
- **RDS PostgreSQL** in private subnet
- **ALB** for load balancing
- **S3** for file storage
- **Secrets Manager** for sensitive data

## Modules

- `networking/` - VPC, subnets, security groups
- `ecs/` - ECS cluster, service, task definition
- `rds/` - PostgreSQL RDS instance
- `alb/` - Application Load Balancer

## Usage

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

## TODO

- [ ] Complete remaining modules (ECR, S3, Secrets)
- [ ] Add staging and production environments
- [ ] Set up GitHub Actions workflows

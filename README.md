# Gatus ECS Deployment

**Tech Stack:** Terraform, AWS (ECS, ALB, Route53, CloudWatch, WAF), GitHub Actions, Docker, Gatus

A containerized monitoring platform deployed on AWS ECS Fargate that tracks external APIs and services.

**Live Application:** https://tm.iasolutions.co.uk

## What it does

This project uses Gatus (an open-source health checker) to monitor external services. It runs on AWS ECS Fargate and automatically scales based on demand. The whole infrastructure is built with Terraform modules so it's easy to replicate.

The platform does HTTP health checks every few minutes and shows the results on a clean dashboard. Pretty useful for keeping track of service dependencies.

## Key Components

- **ECS Fargate** - Runs containers without managing servers
- **Application Load Balancer** - Handles SSL and distributes traffic  
- **VPC** - Multi-tier network setup with private subnets
- **Auto Scaling** - Scales from 1-4 containers based on CPU usage
- **WAF** - Basic protection against common attacks
- **CloudWatch** - Monitoring and alerting
- **CI/CD** - GitHub Actions pipeline that builds and deploys automatically

## Security Features

Production-ready security measures:

- **Container vulnerability scanning** - Trivy scans Docker images for known security vulnerabilities
- **Network isolation** - Containers run in private subnets with no direct internet access
- **WAF protection** - AWS WAF blocks common web attacks and implements rate limiting
- **HTTPS enforcement** - All traffic encrypted with automatic SSL certificate management
- **Least privilege IAM** - Each service gets only the minimum permissions required
- **Security groups** - Restrictive firewall rules allowing only necessary traffic

## Architecture

The infrastructure follows a standard 3-tier architecture with public subnets for the load balancer, private subnets for the ECS tasks, and isolated subnets for future database needs. Everything routes through an internet gateway with NAT gateways providing outbound access for containers.

## How to deploy

First deploy the backend (this creates the S3 bucket for Terraform state):

```bash
cd terraform/backend
terraform init
terraform apply
```

Then deploy the main infrastructure:

```bash
cd ../environments/dev
terraform init
terraform plan
terraform apply
```

The GitHub Actions pipeline handles container builds and deployments automatically when you push to main. Make sure to add your AWS credentials as GitHub secrets first.

## CI/CD Pipeline

The pipeline runs three stages:

**Validation Stage** - Checks Terraform code format and validates configuration
**Security Stage** - Trivy scans the container image for vulnerabilities and reports findings
**Build & Deploy Stage** - Builds the Docker image, pushes to ECR, and updates the ECS service

Pipeline triggers on every push to main but requires manual terraform deployment for infrastructure changes. This separation allows for proper review processes in production environments.

## Screenshots

### Architecture Overview
![Architecture](screenshots/architecture-diagram.png)

### Application Dashboard
![Application](screenshots/app-dashboard.png)

### Terraform Module Structure
![Terraform Structure](screenshots/terraform-modules.png)

### ECS Service Configuration
![ECS Service](screenshots/ecs-service.png)

### Load Balancer Setup
![ALB Configuration](screenshots/alb-listeners.png)

### CloudWatch Monitoring
![Monitoring Dashboard](screenshots/cloudwatch-dashboard.png)

### CI/CD Pipeline
![Pipeline Status](screenshots/github-actions.png)
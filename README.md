# Gatus ECS Deployment

**Tech Stack:** Terraform, AWS (ECS, ALB, Route53, CloudWatch, WAF), GitHub Actions, Docker, Gatus

A containerized monitoring platform deployed on AWS ECS Fargate that tracks external APIs and services.

**Live Application:** https://tm.iasolutions.co.uk

## Author

**Alamin Islam**  
💼 LinkedIn: [linkedin.com/in/alamin-islam-58a635300](https://www.linkedin.com/in/alamin-islam-58a635300)  
🌐 Portfolio: [github.com/Aislam00](https://github.com/Aislam00)

## What it does

This project uses Gatus (an open-source health checker) to monitor external services. It runs on AWS ECS Fargate and automatically scales based on demand. The whole infrastructure is built with Terraform modules so it's easy to replicate.

The platform does HTTP health checks every few minutes and shows the results on a clean dashboard. Pretty useful for keeping track of service dependencies.

## Security Features

Production-ready security measures:
- **Container vulnerability scanning** - Trivy scans Docker images for known security vulnerabilities
- **Network isolation** - Containers run in private subnets with no direct internet access
- **WAF protection** - AWS WAF blocks common web attacks and implements rate limiting
- **HTTPS enforcement** - All traffic encrypted with automatic SSL certificate management
- **Least privilege IAM** - Each service gets only the minimum permissions required

## How to deploy

Deploy the Terraform backend:
```bash
cd terraform/backend
terraform init
terraform apply
```

Deploy the main infrastructure:
```bash
cd ../environments/dev
terraform init
terraform plan
terraform apply
```

The GitHub Actions pipeline handles container builds and deployments automatically when you push to main. Make sure to add your AWS credentials as GitHub secrets first.

## Architecture

![Architecture](screenshots/architecture-diagram.png)

**Key Components:**
- **ECS Fargate** - Runs containers without managing servers
- **Application Load Balancer** - Handles SSL and distributes traffic  
- **VPC** - Multi-tier network setup with private subnets
- **Auto Scaling** - Scales from 1-4 containers based on CPU usage
- **WAF** - Basic protection against common attacks
- **CloudWatch** - Monitoring and alerting

## Live Application

![Application Dashboard](screenshots/app-dashboard.png)

The deployed Gatus monitoring platform showing real-time health checks of external services and APIs.

## CI/CD Pipeline

The pipeline runs three stages:

**Validation Stage** - Checks Terraform code format and validates configuration

**Security Stage** - Trivy scans the container image for vulnerabilities and reports findings

**Build & Deploy Stage** - Builds the Docker image, pushes to ECR, and updates the ECS service

Pipeline triggers on every push to main but requires manual terraform deployment for infrastructure changes. This separation allows for proper review processes in production environments.

![Pipeline Status](screenshots/github-actions.png)

## Infrastructure & Operations

### Terraform Structure
![Terraform Structure](screenshots/terraform-modules.png)

### ECS Service Configuration
![ECS Service](screenshots/ecs-service.png)

### Load Balancer Setup
![ALB Configuration](screenshots/alb-listeners.png)

### CloudWatch Monitoring
![Monitoring Dashboard](screenshots/cloudwatch-dashboard.png)

## Project Overview

This is a full end-to-end project demonstrating enterprise-grade AWS containerized infrastructure with Infrastructure as Code, automated CI/CD pipelines, security scanning, and production monitoring. The platform showcases real-world ECS Fargate operations with auto-scaling and comprehensive observability for external service monitoring.
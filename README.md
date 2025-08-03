# Gatus-ECS-Deployment

A comprehensive monitoring platform that tracks the health and availability of web services and APIs. Built using containerised deployment on AWS ECS Fargate with full infrastructure automation through Terraform.

The platform monitors external services by performing HTTP health checks at regular intervals, providing real-time status visibility and alerting when services become unavailable. This type of monitoring is essential for maintaining awareness of service dependencies and identifying outages before they impact users.

Demonstrates enterprise infrastructure patterns including automated provisioning, integrated security scanning, container orchestration, and production-ready observability practices. The entire stack is designed to handle variable monitoring workloads whilst maintaining cost efficiency and security compliance.

**Live Application:** https://tm.iasolutions.co.uk

![Architecture](screenshots/architecture-diagram.png)

## Project Background

Started this project to explore containerised monitoring solutions for tracking service dependencies at scale. Many applications rely on external APIs and services, and having visibility into their availability is crucial for operational awareness.

Gatus is an open-source monitoring tool that performs health checks against HTTP endpoints and provides a clean status page interface. It's lightweight, configurable, and well-suited for container deployment patterns.

The infrastructure implements common enterprise patterns - multi-AZ deployment, automated scaling, comprehensive monitoring, and security controls. Everything is provisioned through Terraform modules to enable consistent deployments across environments.

![Application](screenshots/app-dashboard.png)

## Technical Architecture

**Core Infrastructure**
- ECS Fargate tasks distributed across 2 AZs in private subnets
- Application Load Balancer with SSL termination and HTTP->HTTPS redirects
- Multi-tier VPC with isolated networking for different workload types
- Route53 DNS with automated ACM certificate provisioning and renewal

**Security Implementation**
- WAF with rate limiting rules and DDoS protection layers
- Container vulnerability scanning integrated into CI pipeline
- Infrastructure compliance validation using Checkov policies
- Network security through security groups and private subnet isolation

**Operational Concerns**
- Auto-scaling group (1-4 tasks) responding to CPU utilisation patterns
- CloudWatch monitoring with custom dashboards and alerting thresholds
- Cost controls via AWS Budgets and anomaly detection
- ECR lifecycle management to prevent storage cost creep

## Implementation Challenges

**Terraform State Management**
Spent considerable time debugging terraform state locks during destroy operations. GitHub Actions workflows were competing for state access, requiring manual unlocks and careful workflow orchestration.

**Container Health Checks**
Getting the ALB health checks aligned with container startup times required iteration. The `/health` endpoint needed proper timeout and interval tuning to avoid false positives during scaling events.

**WAF Rule Tuning**
Initially configured WAF rules too aggressively, blocking legitimate traffic. Had to adjust rate limiting thresholds and whitelist patterns based on actual usage patterns.

## Infrastructure Modules

Modular approach allows for environment-specific customisation whilst maintaining consistency across deployments.

![Terraform Structure](screenshots/terraform-modules.png)

**VPC Module** - Handles multi-AZ networking with separate subnet tiers. Includes NAT gateway configuration for secure outbound connectivity from private subnets. Database subnets prepared for future RDS integration.

**ECS Module** - Manages Fargate service lifecycle, task definitions, and IAM roles. Container insights enabled for detailed metrics collection. Service discovery integration for internal communication patterns.

**ALB Module** - Controls load balancer configuration with target group management and health check tuning. SSL certificate integration via ACM with automated renewal workflows.

**DNS Module** - Automates Route53 record management and certificate validation. Handles both primary domain records and validation CNAMEs for ACM certificate provisioning.

**Security Module** - Defines security group rules following least privilege principles. Creates IAM policies for ECS tasks with minimal required permissions for CloudWatch logging and ECR access.

**Monitoring Module** - Sets up CloudWatch dashboards with relevant metrics and creates alarm thresholds for operational visibility. SNS topic configuration for alert routing.

**Auto-scaling Module** - Configures scaling policies based on CloudWatch metrics with appropriate cooldown periods. WAF rules for application-layer protection against common attack vectors.

**Cost Optimization Module** - Implements budget controls and spending alerts. Cost anomaly detection helps identify unexpected usage spikes before they impact billing significantly.

## Container Orchestration

ECS Fargate handles the container runtime without requiring EC2 instance management. Tasks run in private subnets with outbound internet access through NAT gateways.

![ECS Service](screenshots/ecs-service.png)

The service maintains desired task count through health checks and automatic replacement of failed containers. Container logs stream to CloudWatch for centralised aggregation and analysis.

Target group health checks monitor the `/health` endpoint with configured thresholds to handle startup delays and temporary unavailability during deployments.

## Load Balancer Configuration

ALB manages traffic distribution and SSL termination for the application tier.

![ALB Configuration](screenshots/alb-listeners.png)

HTTP traffic on port 80 redirects to HTTPS for security compliance. Port 443 handles encrypted traffic with ACM-managed certificates. Health checks validate backend container availability before routing traffic.

## Monitoring and Observability

CloudWatch provides infrastructure and application metrics with custom dashboards for operational visibility.

![Monitoring Dashboard](screenshots/cloudwatch-dashboard.png)

Key metrics include:
- ECS service CPU and memory utilisation
- ALB response times and error rates  
- Target group health status
- WAF request patterns and blocked attempts

Custom alarms trigger SNS notifications for threshold breaches, enabling proactive response to operational issues.

## CI/CD Pipeline

GitHub Actions workflow validates security and quality before deployment.

![Pipeline Status](screenshots/github-actions.png)

**Security Analysis Stage**
- Trivy container vulnerability scanning identifies potential security risks
- Checkov infrastructure compliance validation against AWS security benchmarks
- Results in 11 identified security findings (demonstrates working security controls)

**Terraform Validation Stage**  
- Format checking ensures consistent code style
- Syntax validation catches configuration errors
- Backend-less initialisation for validation without AWS dependencies

**Application Build Stage**
- Docker image compilation with multi-platform support
- Container startup testing to verify runtime behaviour
- Health check validation against expected endpoints

Pipeline runs on every push but doesn't automatically deploy to AWS. This separation allows for manual review and approval processes in production environments.

## Security Considerations

**Network Isolation**
- Private subnets prevent direct internet access to application containers
- Security groups restrict traffic to required ports and protocols
- WAF protects against common web application attacks

**Access Control**
- ECS task roles follow least privilege with minimal required permissions
- Container images scanned for known vulnerabilities in CI pipeline
- Infrastructure compliance validated against security benchmarks

**Data Protection**
- All external traffic encrypted via TLS with automated certificate management
- Container logs captured for audit and troubleshooting purposes
- Network traffic isolated between application tiers

## Deployment Process

Infrastructure deployment requires local AWS CLI configuration and Terraform installation.

```bash
# Navigate to environment configuration
cd terraform/environments/dev

# Initialise Terraform with provider plugins
terraform init

# Review planned changes
terraform plan

# Apply infrastructure changes
terraform apply
```

Application deployment happens automatically through ECS when container images are updated. The service handles rolling deployments to maintain availability during updates.

**State Management Note:** Backend configuration references S3 bucket and DynamoDB table for remote state storage. These resources need to exist before running terraform commands.

## Cost Analysis

**Compute Costs**
- Fargate pricing scales with actual resource usage
- Auto-scaling prevents over-provisioning during low-demand periods
- Container resource requests tuned for application requirements

**Storage Costs**
- ECR lifecycle policies automatically remove old container images
- CloudWatch log retention policies prevent unbounded log storage costs

**Network Costs**
- NAT gateway charges for outbound data transfer
- ALB pricing based on Load Balancer Capacity Units (LCUs)

Budget alerts configured at £10 monthly spend with 80% threshold notifications to maintain cost visibility.

## Operational Notes

The Gatus application monitors external service endpoints and provides status page functionality. Configuration defines health check intervals, timeout values, and alerting thresholds for monitored services.

Container exposes port 8080 internally, mapped through ALB target groups to external traffic on ports 80/443. Health checks validate application readiness before routing production traffic.

Infrastructure modules support multiple environments through variable customisation. Consistent resource naming and tagging enable cost allocation and operational management across deployments.

## Development Workflow

Local development uses Docker for container testing. The application configuration can be modified through the `config.yaml` file to add new service monitoring endpoints.

Pipeline validates changes but requires manual terraform deployment for infrastructure updates. This workflow supports review processes and change approval requirements in production environments.

## Technology Stack

**Infrastructure:** Terraform, AWS VPC/ECS/ALB/Route53/CloudWatch/WAF  
**Security:** Trivy, Checkov, AWS Security Groups, ACM  
**CI/CD:** GitHub Actions, Docker  
**Monitoring:** Gatus, CloudWatch, SNS  
**Container Platform:** ECS Fargate, ECR
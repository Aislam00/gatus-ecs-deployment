terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "gatus-ecs-terraform-state-475641479654-eu-west-2"
    key            = "dev/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "gatus-ecs-terraform-locks"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
      Owner       = var.owner
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

module "vpc" {
  source = "../../modules/vpc"

  project_name = var.project_name
  environment  = var.environment

  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs

  common_tags = local.common_tags
}

module "alb" {
  source = "../../modules/alb"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  certificate_arn       = module.dns.certificate_arn

  common_tags = local.common_tags
}

module "ecr" {
  source = "../../modules/ecr"

  project_name   = var.project_name
  environment    = var.environment
  aws_account_id = data.aws_caller_identity.current.account_id

  common_tags = local.common_tags
}

module "security" {
  source = "../../modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = module.vpc.vpc_cidr_block

  common_tags = local.common_tags
}

module "ecs" {
  source = "../../modules/ecs"

  project_name          = var.project_name
  environment           = var.environment
  aws_region            = var.aws_region
  private_subnet_ids    = module.vpc.private_subnet_ids
  ecs_security_group_id = module.security.ecs_security_group_id
  ecr_repository_url    = module.ecr.repository_url
  target_group_arn      = module.alb.target_group_arn

  task_cpu      = var.task_cpu
  task_memory   = var.task_memory
  desired_count = var.desired_count

  common_tags = local.common_tags
}

resource "null_resource" "docker_build_push" {
  depends_on = [module.ecr]

  triggers = {
    dockerfile_hash = filesha256("../../../app/Dockerfile")
    config_hash     = filesha256("../../../app/config.yaml")
  }

  provisioner "local-exec" {
    command = <<-EOF
      cd ../../../../app
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${module.ecr.repository_url}
      docker build --platform linux/amd64 -t ${var.project_name}-${var.environment} .
      docker tag ${var.project_name}-${var.environment}:latest ${module.ecr.repository_url}:latest
      docker push ${module.ecr.repository_url}:latest
    EOF
  }
}

module "dns" {
  source = "../../modules/dns"

  domain_name  = var.domain_name
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id

  common_tags = local.common_tags
}

module "monitoring" {
  source = "../../modules/monitoring"

  project_name   = var.project_name
  environment    = var.environment
  aws_region     = var.aws_region
  alb_arn_suffix = module.alb.alb_arn_suffix

  common_tags = local.common_tags
}

module "autoscaling" {
  source = "../../modules/autoscaling"

  project_name = var.project_name
  environment  = var.environment
  cluster_name = module.ecs.cluster_name
  service_name = "${var.project_name}-${var.environment}"
  min_capacity = var.min_capacity
  max_capacity = var.max_capacity

  common_tags = local.common_tags
}

module "cost_optimization" {
  source = "../../modules/cost-optimization"

  project_name = var.project_name
  environment  = var.environment
  alert_email  = var.alert_email

  common_tags = local.common_tags
}
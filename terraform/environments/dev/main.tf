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
  region = "eu-west-2"

  default_tags {
    tags = {
      Project     = "gatus-ecs"
      Environment = "dev"
      ManagedBy   = "terraform"
      Owner       = "AlaminIslam"
    }
  }
}

locals {
  project_name = "gatus-ecs"
  environment  = "dev"

  common_tags = {
    Project     = local.project_name
    Environment = local.environment
    ManagedBy   = "terraform"
    Owner       = "AlaminIslam"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  project_name = local.project_name
  environment  = local.environment

  vpc_cidr              = "10.0.0.0/16"
  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs  = ["10.0.10.0/24", "10.0.20.0/24"]
  database_subnet_cidrs = ["10.0.30.0/24", "10.0.40.0/24"]

  common_tags = local.common_tags
}

module "alb" {
  source = "../../modules/alb"

  project_name          = local.project_name
  environment           = local.environment
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  certificate_arn       = module.dns.certificate_arn

  common_tags = local.common_tags
}

module "ecr" {
  source = "../../modules/ecr"

  project_name   = local.project_name
  environment    = local.environment
  aws_account_id = "475641479654"

  common_tags = local.common_tags
}

module "security" {
  source = "../../modules/security"

  project_name = local.project_name
  environment  = local.environment
  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = module.vpc.vpc_cidr_block

  common_tags = local.common_tags
}

module "ecs" {
  source = "../../modules/ecs"

  project_name          = local.project_name
  environment           = local.environment
  aws_region            = "eu-west-2"
  private_subnet_ids    = module.vpc.private_subnet_ids
  ecs_security_group_id = module.security.ecs_security_group_id
  ecr_repository_url    = module.ecr.repository_url
  target_group_arn      = module.alb.target_group_arn # Add this back!

  task_cpu      = "256"
  task_memory   = "512"
  desired_count = 1

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
      aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin ${module.ecr.repository_url}
      docker build --platform linux/amd64 -t gatus-ecs-dev .
      docker tag gatus-ecs-dev:latest ${module.ecr.repository_url}:latest
      docker push ${module.ecr.repository_url}:latest
    EOF
  }
}
module "dns" {
  source = "../../modules/dns"

  domain_name  = "tm.iasolutions.co.uk"
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id

  common_tags = local.common_tags
}

module "monitoring" {
  source = "../../modules/monitoring"

  project_name   = local.project_name
  environment    = local.environment
  aws_region     = "eu-west-2"
  alb_arn_suffix = module.alb.alb_arn_suffix

  common_tags = local.common_tags
}

module "autoscaling" {
  source = "../../modules/autoscaling"

  project_name = local.project_name
  environment  = local.environment
  cluster_name = module.ecs.cluster_name
  service_name = "${local.project_name}-${local.environment}"
  min_capacity = 1
  max_capacity = 4

  common_tags = local.common_tags
}

module "cost_optimization" {
  source = "../../modules/cost-optimization"

  project_name = local.project_name
  environment  = local.environment
  alert_email  = "your-email@example.com"

  common_tags = local.common_tags
}


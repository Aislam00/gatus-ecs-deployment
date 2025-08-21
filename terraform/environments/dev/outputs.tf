output "vpc_id" {
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
  value       = module.vpc.database_subnet_ids
}

output "ecr_repository_url" {
  value       = module.ecr.repository_url
}

output "ecr_repository_name" {
  value       = module.ecr.repository_name
}

output "ecs_cluster_name" {
  value       = module.ecs.cluster_name
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
}

output "domain_name" {
  value       = var.domain_name
}
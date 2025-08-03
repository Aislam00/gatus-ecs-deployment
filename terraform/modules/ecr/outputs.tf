output "repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.gatus.repository_url
}

output "repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.gatus.arn
}

output "repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.gatus.name
}

output "registry_id" {
  description = "Registry ID of the ECR repository"
  value       = aws_ecr_repository.gatus.registry_id
}
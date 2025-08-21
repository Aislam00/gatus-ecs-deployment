output "cluster_name" {
  value       = aws_ecs_cluster.main.name
}

output "cluster_arn" {
  value       = aws_ecs_cluster.main.arn
}

output "service_name" {
  value       = aws_ecs_service.gatus.name
}

output "log_group_name" {
  value       = aws_cloudwatch_log_group.gatus.name
}

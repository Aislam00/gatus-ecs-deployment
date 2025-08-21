output "alb_arn" {
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  value       = aws_lb.main.zone_id
}

output "target_group_arn" {
  value       = aws_lb_target_group.gatus.arn
}

output "target_group_name" {
  value       = aws_lb_target_group.gatus.name
}

output "alb_arn_suffix" {
  value       = aws_lb.main.arn_suffix
}

output "waf_arn" {
  value       = aws_wafv2_web_acl.main.arn
}

output "autoscaling_target_arn" {
  value       = aws_appautoscaling_target.ecs_target.arn
}

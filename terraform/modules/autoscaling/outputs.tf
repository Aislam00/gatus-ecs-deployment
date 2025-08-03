output "waf_arn" {
  description = "WAF Web ACL ARN"
  value       = aws_wafv2_web_acl.main.arn
}

output "autoscaling_target_arn" {
  description = "Auto Scaling target ARN"
  value       = aws_appautoscaling_target.ecs_target.arn
}

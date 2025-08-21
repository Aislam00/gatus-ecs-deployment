output "budget_name" {
  value       = aws_budgets_budget.gatus_budget.name
}

output "billing_alarm_arn" {
  value       = aws_cloudwatch_metric_alarm.billing_alarm.arn
}

output "budget_name" {
  description = "Budget name"
  value       = aws_budgets_budget.gatus_budget.name
}

output "billing_alarm_arn" {
  description = "Billing alarm ARN"
  value       = aws_cloudwatch_metric_alarm.billing_alarm.arn
}

output "budget_alert_topic_arn" {
  description = "The ARN of the budget_alert_topic."
  value       = aws_sns_topic.budget_alert_topic.arn
}

output "cloudwatch_alarm_topic_arn" {
  description = "The ARN of the cloudwatch_alarm_topic."
  value       = aws_sns_topic.cloudwatch_alarm_topic.arn
}
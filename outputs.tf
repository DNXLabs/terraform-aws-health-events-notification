output "event_bridge_rule_id" {
  value = aws_cloudwatch_event_rule.console.id
}

output "sns_topic_arn" {
  value = var.sns_topic_name != "" ? aws_sns_topic.health_event_topic[0].arn : var.sns_topic_arn
}

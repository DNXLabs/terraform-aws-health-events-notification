output "event_bridge_rule_id" {
  value = aws_cloudwatch_event_rule.console[0].id
}

output "sns_topic_arn" {
  value = aws_sns_topic.health_event_topic[0].arn
}

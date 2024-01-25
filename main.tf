locals {
  custom_event_pattern = {
    "source"      = ["aws.health"],
    "detail-type" = ["AWS Health Event"],
    "detail" = {
      "service" = var.aws_health_services
    }
  }

  default_event_pattern = {
    "source"      = ["aws.health"],
    "detail-type" = ["AWS Health Event"]
  }
}

resource "aws_cloudwatch_event_rule" "console" {
  name        = "AWSHealthEventRule"
  description = "EventBridge rule for AWS Health events"

  event_pattern = var.use_default_event_pattern ? jsonencode(local.default_event_pattern) : jsonencode(local.custom_event_pattern)
}
resource "aws_sns_topic" "health_event_topic" {
  name = "AWSHealthEventTopic"
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.console.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.health_event_topic.arn
}

resource "aws_sns_topic_subscription" "email_subscription" {
  count     = var.email_endpoint != null ? 1 : 0
  topic_arn = aws_sns_topic.health_event_topic.arn
  protocol  = "email"
  endpoint  = var.email_endpoint
}

resource "aws_sns_topic_subscription" "webhook_subscription" {
  count                           = var.webhook_endpoint != "" ? 1 : 0
  topic_arn                       = aws_sns_topic.health_event_topic.arn
  protocol                        = "https"
  endpoint                        = var.webhook_endpoint
  confirmation_timeout_in_minutes = 1
  endpoint_auto_confirms          = true
}


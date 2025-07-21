resource "aws_iam_role" "health_lambda_iam" {
  name = var.event_rule_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = ""
        Principal = { Service = "lambda.amazonaws.com" }
      },
    ]
  })
  inline_policy {
    name = "sns"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["sns:Publish"]
          Effect   = "Allow"
          Resource = var.sns_topic_name != "" ? aws_sns_topic.health_event_topic[0].arn : var.sns_topic_arn
        },
        {
          Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
          Effect   = "Allow"
          Resource = "arn:aws:logs:*:*:*"
        }
      ]
    })
  }
}

resource "aws_lambda_permission" "health_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.health_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.console.arn
}

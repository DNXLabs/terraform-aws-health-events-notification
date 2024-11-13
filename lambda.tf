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

data "archive_file" "health_lambda" {
  type        = "zip"
  source_file = "${path.module}/health-lambda.py"
  output_path = "${path.module}/health-lambda-function-payload.zip"
}

resource "aws_lambda_function" "health_lambda" {
  filename         = "${path.module}/health-lambda-function-payload.zip"
  function_name    = var.event_rule_name
  role             = aws_iam_role.health_lambda_iam.arn
  handler          = "health-lambda.lambda_handler"
  source_code_hash = data.archive_file.health_lambda.output_base64sha256
  runtime          = "python3.12"
  environment {
    variables = {
      SNS_TOPIC_ARN   = var.sns_topic_name != "" ? aws_sns_topic.health_event_topic[0].arn : var.sns_topic_arn
      EVENT_RULE_NAME = var.event_rule_name
      ALARM_SUBJECT_PREFIX = var.alarm_subject_prefix
    }
  }
}

resource "aws_cloudwatch_event_target" "health_lambda" {
  rule      = aws_cloudwatch_event_rule.console.name
  target_id = "health_lambda"
  arn       = aws_lambda_function.health_lambda.arn
}

resource "aws_lambda_permission" "health_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.health_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.console.arn
}

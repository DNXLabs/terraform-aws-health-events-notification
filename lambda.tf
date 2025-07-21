data "archive_file" "health_lambda" {
  type        = "zip"
  source_file = "${path.module}/health-lambda.py"
  output_path = "${path.module}/health-lambda-function-payload.zip"
}

resource "aws_lambda_function" "health_lambda" {
#checkov:skip=CKV_AWS_117:No need to deploy lambda inside VPC
#checkov:skip=CKV_AWS_173:No need to encrypt env vars
#checkov:skip=CKV_AWS_50:Lambda is simple, no need for x-ray
  filename                       = "${path.module}/health-lambda-function-payload.zip"
  function_name                  = var.event_rule_name
  role                           = aws_iam_role.health_lambda_iam.arn
  reserved_concurrent_executions = 50
  handler                        = "health-lambda.lambda_handler"
  source_code_hash               = data.archive_file.health_lambda.output_base64sha256
  runtime                        = var.runtime
  environment {
    variables = {
      SNS_TOPIC_ARN        = var.sns_topic_name != "" ? aws_sns_topic.health_event_topic[0].arn : var.sns_topic_arn
      EVENT_RULE_NAME      = var.event_rule_name
      ALARM_SUBJECT_PREFIX = var.alarm_subject_prefix
    }
  }
}

resource "aws_cloudwatch_event_target" "health_lambda" {
  rule      = aws_cloudwatch_event_rule.console.name
  target_id = "health_lambda"
  arn       = aws_lambda_function.health_lambda.arn
}


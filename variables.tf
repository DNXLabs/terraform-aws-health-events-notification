variable "event_rule_name" {
  description = "Name for the AWS Health Event Rule"
  type        = string
  default     = "AWSHealthEventRule"
}

variable "email_endpoint" {
  description = "Email address for notifications (optional) - only when sns_topic_name is set"
  type        = string
  default     = ""
}

variable "webhook_endpoint" {
  description = "Webhook URL for notifications (optional) - only when sns_topic_name is set"
  type        = string
  default     = ""
}

variable "aws_health_services" {
  description = "List of AWS services to filter AWS Health events"
  type        = list(string)
  default     = []
}

variable "use_default_event_pattern" {
  description = "Flag to determine whether to use the default event pattern or not"
  type        = bool
  default     = true
}

variable "sns_kms_encryption" {
  type        = bool
  default     = true
  description = "Enabled KMS CMK encryption at rest for SNS Topic"
}

variable "sns_topic_name" {
  type        = string
  description = "Topic name (optional - creates SNS topic)"
  default     = ""
}

variable "sns_topic_arn" {
  type        = string
  description = "Topic ARN (optional - uses an existing SNS topic)"
  default     = ""
}

variable "alarm_subject_prefix" {
  type        = string
  description = "Alarm prefix name"
  default     = ""
}

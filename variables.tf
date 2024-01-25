variable "email_endpoint" {
  description = "Email address for notifications (optional)"
  type        = string
  default     = ""
}

variable "webhook_endpoint" {
  description = "Webhook URL for notifications (optional)"
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
module "aws_health_config" {
  source                 = "./modules/aws-health"
  email_endpoint         = "abcd@gmail.com"  # Email address for notifications (manual confirmation)
  webhook_endpoint       = ""  # Webhook URL for notifications (automatic confirmation)
  aws_health_services    = ["RDS","EC2","S3"]  # List of AWS services to filter AWS Health events
  use_default_event_pattern = false
}
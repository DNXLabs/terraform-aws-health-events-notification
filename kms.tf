# Create the KMS key
resource "aws_kms_key" "sns" {
  count                   = var.sns_kms_encryption ? 1 : 0
  deletion_window_in_days = 7
  description             = "SNS CMK Encryption Key"
  enable_key_rotation     = true
}

# Define the KMS policy document
data "aws_iam_policy_document" "kms_policy_sns" {
  count = var.sns_kms_encryption ? 1 : 0

  statement {
    sid    = "Enable Specific IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [aws_kms_key.sns[0].arn]
  }

  statement {
    sid       = "Allow Use of Key for Specific Services"
    actions   = ["kms:Decrypt", "kms:GenerateDataKey*"]
    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com", "lambda.amazonaws.com"]
    }
    resources = [aws_kms_key.sns[0].arn]
  }
}

# Update the policy of the KMS key
resource "aws_kms_key_policy" "sns_policy" {
  count      = var.sns_kms_encryption ? 1 : 0
  key_id     = aws_kms_key.sns[0].key_id
  policy     = data.aws_iam_policy_document.kms_policy_sns[0].json
}

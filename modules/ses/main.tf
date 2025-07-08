resource "aws_ses_email_identity" "recipient" {
  email = var.email_recipient
}

output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}


output "api_endpoint" {
  value = module.api_gateway.api_endpoint
}

output "ses_identity_verification_status" {
  description = "Email verification status in SES"
  value       = module.ses.ses_identity_verification_status
}
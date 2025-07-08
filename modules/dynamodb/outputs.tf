 output "dynamodb_table_name" {
  description = "Name of the DynamoDB table storing contact form data"
  value       = aws_dynamodb_table.contact_form.name
}

output "aws_dynamodb_table_arn" {
 description = "ARN of the DynamoDB table"
 value = aws_dynamodb_table.contact_form.arn
}
   
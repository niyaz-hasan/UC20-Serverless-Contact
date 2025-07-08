data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_app/handler.py"
  output_path = "${path.module}/lambda_app/handler.zip"
}

module "lambda" {
  source              = "./modules/lambda"
  lambda_zip     = data.archive_file.lambda_zip.output_path
  lambda_name         = var.lambda_function_name
  aws_dynamodb_table_arn = module.dynamodb.aws_dynamodb_table_arn
  aws_dynamodb_table_name = module.dynamodb.aws_dynamodb_table_name
  email_recipient         = var.email_recipient
}

module "dynamodb" {
  source             = "./modules/dynamodb"
}

module "ses" {
  source             = "./modules/ses"
  email_recipient    = var.email_recipient

}

module "api_gateway" {
  source          = "./modules/api_gateway"
  lambda_function_name = module.lambda.lambda_function_name
  lambda_arn     = module.lambda.lambda_arn
}

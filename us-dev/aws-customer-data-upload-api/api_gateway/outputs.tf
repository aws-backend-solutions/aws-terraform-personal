output "aws_customer_data_upload_api_id" {
  description = "ID for aws-customer-data-upload-api"
  value       = aws_api_gateway_rest_api.aws_customer_data_upload_api.id
}
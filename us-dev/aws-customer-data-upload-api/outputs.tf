########## aws-customer-data-upload-api/api_gateway ##########

output "aws_customer_data_upload_api_endpoint" {
  description = "HTTP API endpoint for aws-customer-data-upload-api"
  value       = "https://${module.api_gateway.aws_customer_data_upload_api_id}.execute-api.${var.aws_region}.amazonaws.com/${var.stage_name}/${var.path_part}"
}
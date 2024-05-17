########## aws-integration-tenant-mgmt-api/api_gateway ##########

output "aws_integration_tenant_mgmt_api_endpoint" {
  description = "HTTP API endpoint for aws-integration-tenant-mgmt-api"
  value       = "https://${module.api_gateway.aws_integration_tenant_mgmt_api_id}.execute-api.${var.aws_region}.amazonaws.com/${var.aws_environment}/${var.path_part}"
}
########## aws-integration-tenant-mgmt-api/hub/api_gateway ##########

output "primary_aws_integration_tenant_mgmt_api_endpoint" {
  description = "HTTP API endpoint for primary-aws-integration-tenant-mgmt-api"
  value       = "https://${module.api_gateway.primary_aws_integration_tenant_mgmt_api_id}.execute-api.${var.aws_region}.amazonaws.com/${var.stage_name}/${var.path_part}"
}
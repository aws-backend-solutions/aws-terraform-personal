output "primary_aws_integration_tenant_mgmt_api_id" {
  description = "ID for primary_aws-integration-tenant-mgmt-api"
  value       = aws_api_gateway_rest_api.primary_aws_integration_tenant_mgmt_api.id
}
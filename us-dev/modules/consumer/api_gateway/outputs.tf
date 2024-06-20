output "primary_aws_integration_tenant_mgmt_api_id" {
  description = "ID for primary_aws-integration-tenant-mgmt-api"
  value       = aws_api_gateway_rest_api.primary_aws_integration_tenant_mgmt_api.id
}

output "primary_aws_integration_tenant_mgmt_api_root_resource_id" {
  description = "Root resource ID for primary_aws-integration-tenant-mgmt-api"
  value       = aws_api_gateway_rest_api.primary_aws_integration_tenant_mgmt_api.root_resource_id
}

output "primary_aws_integration_tenant_mgmt_api_body" {
  description = "Body of primary_aws-integration-tenant-mgmt-api"
  value       = aws_api_gateway_rest_api.primary_aws_integration_tenant_mgmt_api.body
}
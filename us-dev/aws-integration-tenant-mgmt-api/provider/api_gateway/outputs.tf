output "aws_integration_tenant_mgmt_api_id" {
  description = "ID for aws-integration-tenant-mgmt-api"
  value       = aws_api_gateway_rest_api.aws_integration_tenant_mgmt_api.id
}

output "aws_integration_tenant_mgmt_api_invocation_role_arn" {
  description = "ARN for aws-integration-tenant-mgmt-api-gateway-invocation-role"
  value       = aws_iam_role.aws_integration_tenant_mgmt_api_invocation_role.arn
}
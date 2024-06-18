output "aws_integration_tenant_mgmt_api_invocation_role_arn" {
  description = "ARN for aws-integration-tenant-mgmt-api-gateway-invocation-role"
  value       = module.api_gateway.aws_integration_tenant_mgmt_api_invocation_role_arn
}
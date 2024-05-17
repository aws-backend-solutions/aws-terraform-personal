output "aws_integration_tenant_mgmt_api_id" {
  description = "ID for aws-integration-tenant-eu-api"
  value       = aws_apigatewayv2_api.aws_integration_tenant_mgmt_api.id
}
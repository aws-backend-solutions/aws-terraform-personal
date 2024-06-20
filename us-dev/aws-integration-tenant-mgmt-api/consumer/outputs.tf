output "aws_integration_tenant_mgmt_function_us_staging_invoke_arn" {
  description = "The Invoke ARN of the underlying Lambda function."
  value       = module.lambda.aws_integration_tenant_mgmt_function_us_staging_invoke_arn
}

output "aws_integration_tenant_mgmt_function_eu_staging_invoke_arn" {
  description = "The Invoke ARN of the underlying Lambda function."
  value       = module.lambda.aws_integration_tenant_mgmt_function_eu_staging_invoke_arn
}
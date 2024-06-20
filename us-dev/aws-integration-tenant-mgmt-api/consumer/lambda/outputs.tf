output "aws_integration_tenant_mgmt_function_us_staging_invoke_arn" {
  description = "The Invoke ARN of the underlying Lambda function."
  value       = aws_lambda_function.aws_integration_tenant_mgmt_function_us_staging.invoke_arn
}
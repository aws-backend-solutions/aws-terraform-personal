output "aws_integration_tenant_mgmt_function_invoke_arn" {
  description = "The Invoke ARN of the underlying Lambda function."
  value       = aws_lambda_function.aws_integration_tenant_mgmt_function.invoke_arn
}
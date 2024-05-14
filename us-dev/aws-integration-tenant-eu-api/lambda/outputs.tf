output "aws_integration_tenant_eu_function_arn" {
  description = "The ARN of the underlying Lambda function."
  value       = aws_lambda_function.aws_integration_tenant_eu_function.arn
}
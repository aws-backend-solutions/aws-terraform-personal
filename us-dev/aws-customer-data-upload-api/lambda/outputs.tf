output "aws_customer_data_upload_function_invoke_arn1" {
  description = "The Invoke ARN of the underlying upload and generate new url Lambda function."
  value       = aws_lambda_function.aws_customer_data_upload_function1.invoke_arn
}
output "aws_customer_data_upload_function_invoke_arn2" {
  description = "The Invoke ARN of the underlying regenerate new url Lambda function."
  value       = aws_lambda_function.aws_customer_data_upload_function1.invoke_arn
}
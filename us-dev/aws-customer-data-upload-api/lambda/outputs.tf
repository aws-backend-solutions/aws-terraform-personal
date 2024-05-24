output "aws_customer_data_upload_function_invoke_arn1" {
  description = "The Invoke ARN of the underlying upload and generate new url Lambda function."
  value       = aws_lambda_function.aws_customer_data_upload_function1.invoke_arn
}

output "aws_customer_data_upload_function_invoke_arn2" {
  description = "The Invoke ARN of the underlying regenerate new url Lambda function."
  value       = aws_lambda_function.aws_customer_data_upload_function2.invoke_arn
}

output "aws_customer_data_upload_function_function_name1" {
  description = "The function name of the underlying upload and generate new url Lambda function."
  value = aws_lambda_function.aws_customer_data_upload_function1.function_name
}

output "aws_customer_data_upload_function_function_name2" {
  description = "The function name of the underlying regenerate new url Lambda function."
  value = aws_lambda_function.aws_customer_data_upload_function2.function_name
}
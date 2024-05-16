output "aws_mongodb_ga_function_invoke_arn" {
  description = "The Invoke ARN of the underlying Lambda function."
  value       = aws_lambda_function.aws_mongodb_ga_function.invoke_arn
}
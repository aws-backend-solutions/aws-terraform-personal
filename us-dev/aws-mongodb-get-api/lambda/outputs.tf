output "aws_mongodb_ga_function_arn" {
  description = "The ARN of the underlying Lambda function."
  value       = aws_lambda_function.aws_mongodb_ga_function.arn
}
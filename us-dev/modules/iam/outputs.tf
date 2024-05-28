output "aws_backend_api_gateway_role_name" {
  description = "The name of the aws_backend_api_gateway_role."
  value = aws_iam_role.aws_backend_api_gateway_role.name
}

output "aws_backend_api_gateway_role_arn" {
  description = "The ARN of the aws_backend_api_gateway_role."
  value = aws_iam_role.aws_backend_api_gateway_role.arn 
}
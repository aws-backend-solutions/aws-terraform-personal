output "aws_backend_api_gateway_role_name" {
  description = "The name of the aws_backend_api_gateway_role."
  value = aws_iam_service_linked_role.aws_backend_api_gateway_role.name
}
output "aws_backend_vpc_endpoint_arn" {
  description = "The ARN of aws-backend-api-vpce."
  value       = aws_vpc_endpoint.aws_backend_vpc_endpoint.arn
}

output "aws_backend_vpc_endpoint_id" {
  description = "The ID of aws-backend-api-vpce."
  value       = aws_vpc_endpoint.aws_backend_vpc_endpoint.id
}
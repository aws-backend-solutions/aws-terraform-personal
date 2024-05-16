output "aws_backend_vpc_id" {
  description = "The ID of the aws-backend-vpc."
  value       = aws_vpc.aws_backend_vpc.id
}

output "aws_backend_private_subnet1_id" {
  description = "The ID of the aws-backend-private-subnet-1."
  value       = aws_subnet.aws_backend_private_subnet1.id
}

output "aws_backend_private_subnet2_id" {
  description = "The ID of the aws-backend-private-subnet-2."
  value       = aws_subnet.aws_backend_private_subnet2.id
}

output "aws_backend_public_subnet1_id" {
  description = "The ID of the aws-backend-public-subnet-1."
  value       = aws_subnet.aws_backend_public_subnet1.id
}

output "aws_backend_public_subnet2_id" {
  description = "The ID of the aws-backend-public-subnet-2."
  value       = aws_subnet.aws_backend_public_subnet2.id
}

output "aws_backend_security_group1_id" {
  description = "The ID of the AwsBackendSecurityGroup1."
  value       = aws_security_group.aws_backend_security_group1.id
}

output "aws_backend_security_group2_id" {
  description = "The ID of the AwsBackendSecurityGroup2."
  value       = aws_security_group.aws_backend_security_group2.id
}

output "aws_backend_vpc_endpoint_id" {
  description = "The ID of the AwsBackendVpcEndpoint."
  value       = aws_vpc_endpoint.aws_backend_vpc_endpoint.id
}

output "aws_backend_vpc_endpoint_arn" {
  description = "The ARN of the AwsBackendVpcEndpoint."
  value       = aws_vpc_endpoint.aws_backend_vpc_endpoint.arn
}
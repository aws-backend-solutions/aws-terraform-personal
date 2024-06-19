output "primary_aws_backend_vpc_id" {
  description = "The ID of the primary-aws-backend-vpc."
  value       = aws_vpc.primary_aws_backend_vpc.id
}

output "primary_aws_backend_private_subnet1_id" {
  description = "The ID of the primary-aws-backend-private-subnet-1."
  value       = aws_subnet.primary_aws_backend_private_subnet1.id
}

output "primary_aws_backend_private_subnet2_id" {
  description = "The ID of the primary-aws-backend-private-subnet-2."
  value       = aws_subnet.primary_aws_backend_private_subnet2.id
}

output "primary_aws_backend_public_subnet1_id" {
  description = "The ID of the primary-aws-backend-public-subnet-1."
  value       = aws_subnet.primary_aws_backend_public_subnet1.id
}

output "primary_aws_backend_public_subnet2_id" {
  description = "The ID of the primary-aws-backend-public-subnet-2."
  value       = aws_subnet.primary_aws_backend_public_subnet2.id
}

output "primary_aws_backend_security_group1_id" {
  description = "The ID of the AwsBackendSecurityGroup1."
  value       = aws_security_group.primary_aws_backend_security_group1.id
}

output "primary_aws_backend_security_group2_id" {
  description = "The ID of the AwsBackendSecurityGroup2."
  value       = aws_security_group.primary_aws_backend_security_group2.id
}

output "primary_aws_backend_security_group3_id" {
  description = "The ID of the AwsBackendSecurityGroup3."
  value       = aws_security_group.primary_aws_backend_security_group3.id
}

output "primary_aws_backend_private_route_table_id" {
  description = "The ID of private route table."
  value       = aws_route_table.primary_aws_backend_private_route_table.id
}

output "primary_aws_backend_vpc_endpoint_arn" {
  description = "The ARN of primary-aws-backend-api-vpce."
  value       = aws_vpc_endpoint.primary_aws_backend_vpc_endpoint.arn
}

output "primary_aws_backend_vpc_endpoint_id" {
  description = "The ID of primary-aws-backend-api-vpce."
  value       = aws_vpc_endpoint.primary_aws_backend_vpc_endpoint.id
}

output "primary_aws_backend_vpc_endpoint_enis" {
  description = "List of private IP addresses of the VPC endpoint interfaces"
  value       = aws_vpc_endpoint.primary_aws_backend_vpc_endpoint.network_interface_ids
}
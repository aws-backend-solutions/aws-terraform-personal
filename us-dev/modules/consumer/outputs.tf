########## modules/hub/vpc ##########

output "primary_aws_backend_vpc_id" {
  description = "The ID of the primary-aws-backend-vpc."
  value       = module.vpc.primary_aws_backend_vpc_id
}

output "primary_aws_backend_private_subnet1_id" {
  description = "The ID of the primary-aws-backend-private-subnet-1."
  value       = module.vpc.primary_aws_backend_private_subnet1_id
}

output "primary_aws_backend_private_subnet2_id" {
  description = "The ID of the primary-aws-backend-private-subnet-2."
  value       = module.vpc.primary_aws_backend_private_subnet2_id
}

output "primary_aws_backend_public_subnet1_id" {
  description = "The ID of the primary-aws-backend-public-subnet-1."
  value       = module.vpc.primary_aws_backend_public_subnet1_id
}

output "primary_aws_backend_public_subnet2_id" {
  description = "The ID of the primary-aws-backend-public-subnet-2."
  value       = module.vpc.primary_aws_backend_public_subnet2_id
}

output "primary_aws_backend_security_group1_id" {
  description = "The ID of the AwsBackendSecurityGroup1."
  value       = module.vpc.primary_aws_backend_security_group1_id
}

output "primary_aws_backend_security_group2_id" {
  description = "The ID of the AwsBackendSecurityGroup2."
  value       = module.vpc.primary_aws_backend_security_group2_id
}

output "primary_aws_backend_security_group3_id" {
  description = "The ID of the AwsBackendSecurityGroup3."
  value       = module.vpc.primary_aws_backend_security_group3_id
}

output "primary_aws_backend_security_group4_id" {
  description = "The ID of the AwsBackendSecurityGroup4."
  value       = module.vpc.primary_aws_backend_security_group4_id
}

output "primary_aws_backend_private_route_table_id" {
  description = "The ID of private route table."
  value       = module.vpc.primary_aws_backend_private_route_table_id
}

output "primary_aws_backend_vpc_endpoint_id" {
  description = "The ID of primary-aws-backend-api-vpce."
  value       = module.vpc.primary_aws_backend_vpc_endpoint_id
}

output "primary_aws_backend_vpc_endpoint_enis" {
  description = "List of private IP addresses of the VPC endpoint interfaces"
  value       = module.vpc.primary_aws_backend_vpc_endpoint_enis
}

output "primary_aws_backend_nlb_dns_name" {
  description = "DNS name of primary_aws_backend_nlb."
  value       = module.nlb.primary_aws_backend_nlb_dns_name
}

output "primary_aws_backend_nlb_arn" {
  description = "ARN of primary_aws_backend_nlb."
  value       = module.nlb.primary_aws_backend_nlb_arn
}
########## modules/provider/vpc ##########

output "aws_backend_vpc_id" {
  description = "The ID of the aws-backend-vpc."
  value       = module.vpc.aws_backend_vpc_id
}

output "aws_backend_private_subnet1_id" {
  description = "The ID of the aws-backend-private-subnet-1."
  value       = module.vpc.aws_backend_private_subnet1_id
}

output "aws_backend_private_subnet2_id" {
  description = "The ID of the aws-backend-private-subnet-2."
  value       = module.vpc.aws_backend_private_subnet2_id
}

output "aws_backend_public_subnet1_id" {
  description = "The ID of the aws-backend-public-subnet-1."
  value       = module.vpc.aws_backend_public_subnet1_id
}

output "aws_backend_public_subnet2_id" {
  description = "The ID of the aws-backend-public-subnet-2."
  value       = module.vpc.aws_backend_public_subnet2_id
}

output "aws_backend_security_group1_id" {
  description = "The ID of the AwsBackendSecurityGroup1."
  value       = module.vpc.aws_backend_security_group1_id
}

output "aws_backend_security_group2_id" {
  description = "The ID of the AwsBackendSecurityGroup2."
  value       = module.vpc.aws_backend_security_group2_id
}

output "aws_backend_security_group3_id" {
  description = "The ID of the AwsBackendSecurityGroup3."
  value       = module.vpc.aws_backend_security_group3_id
}

output "aws_backend_private_route_table_id" {
  description = "The ID of private route table."
  value       = module.vpc.aws_backend_private_route_table_id
}

output "aws_backend_vpc_endpoint_id" {
  description = "The ID of aws-backend-api-vpce."
  value       = module.vpc.aws_backend_vpc_endpoint_id
}

output "aws_backend_vpc_endpoint_enis" {
  description = "List of private IP addresses of the VPC endpoint interfaces"
  value       = module.vpc.aws_backend_vpc_endpoint_enis
}

########## modules/provider/sns ##########

output "budget_alert_topic_arn" {
  description = "The ARN of the budget_alert_topic."
  value       = module.sns.budget_alert_topic_arn
}

output "cloudwatch_alarm_topic_arn" {
  description = "The ARN of the cloudwatch_alarm_topic."
  value       = module.sns.cloudwatch_alarm_topic_arn
}

########## modules/provider/iam ##########

output "aws_backend_api_gateway_role_name" {
  description = "The name of the aws_backend_api_gateway_role."
  value       = module.iam.aws_backend_api_gateway_role_name
}

output "aws_backend_api_gateway_role_arn" {
  description = "The ARN of the aws_backend_api_gateway_role."
  value       = module.iam.aws_backend_api_gateway_role_arn
}

########## modules/provider/nlb ##########

output "primary_aws_backend_nlb_dns_name" {
  description = "DNS name of primary_aws_backend_nlb."
  value       = module.nlb.primary_aws_backend_nlb_dns_name
}

output "primary_aws_backend_nlb_arn" {
  description = "ARN of primary_aws_backend_nlb."
  value       = module.nlb.primary_aws_backend_nlb_arn
}
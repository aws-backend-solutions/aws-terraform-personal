########## modules/vpc ##########

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

output "aws_backend_vpc_endpoint_id" {
  description = "The ID of the AwsBackendVpcEndpoint."
  value       = module.vpc.aws_backend_vpc_endpoint_id
}

output "aws_backend_vpc_endpoint_arn" {
  description = "The ARN of the AwsBackendVpcEndpoint."
  value       = module.vpc.aws_backend_vpc_endpoint_arn
}
########## modules/alb ##########

output "aws_backend_load_balancer_arn" {
  description = "The ARN of the Load Balancer."
  value       = module.alb.aws_backend_load_balancer_arn
}

output "aws_backend_load_balancer_dns_name" {
  description = "The URI of the Load Balancer."
  value       = module.alb.aws_backend_load_balancer_dns_name
}

output "aws_backend_load_balancer_name" {
  description = "The name of the Load Balancer."
  value       = module.alb.aws_backend_load_balancer_name
}

output "aws_backend_load_balancer_listener_80_id" {
  description = "The ID of the Load Balancer Listener."
  value       = module.alb.aws_backend_load_balancer_listener_80_id
}

output "aws_backend_load_balancer_listener_80_arn" {
  description = "The ARN of the Load Balancer Listener."
  value       = module.alb.aws_backend_load_balancer_listener_80_arn
}

output "aws_backend_load_balancer_listener_443_id" {
  description = "The ID of the Load Balancer Listener."
  value       = module.alb.aws_backend_load_balancer_listener_443_id
}

output "aws_backend_load_balancer_listener_443_arn" {
  description = "The ARN of the Load Balancer Listener."
  value       = module.alb.aws_backend_load_balancer_listener_443_arn
}

########## modules/sns ##########

output "budget_alert_topic_arn" {
  description = "The ARN of the budget_alert_topic."
  value       = module.sns.budget_alert_topic_arn
}

output "cloudwatch_alarm_topic_arn" {
  description = "The ARN of the cloudwatch_alarm_topic."
  value       = module.sns.cloudwatch_alarm_topic_arn
}
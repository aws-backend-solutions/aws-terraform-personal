variable "prefix_name" {
  type = string
}

variable "cost_center_tag" {
  type        = string
  description = "Used for tagging the resources created."
  default     = "AWSDevAccount"
}

variable "environment_tag" {
  type        = string
  description = "Provide which environment this will be deployed. Used for tagging the resources created."
}

variable "aws_backend_security_group4_id" {
  type        = string
  description = "Designated security group of primary-aws-backend-nlb in primary-aws-backend-vpc."
}

variable "aws_backend_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs where load balancer will be deployed"
}

variable "aws_backend_vpc_id" {
  type        = string
  description = "The ID of the primary-aws-backend-vpc."
}

variable "aws_backend_vpc_endpoint_ips" {
  type        = list(string)
  description = "List of private IP addresses of the VPC endpoint interfaces"
}

variable "stage_name" {
  type        = string
  description = "Stage where this solution will be deployed."
}
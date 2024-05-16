variable "cost_center_tag" {
  type        = string
  description = "Used for tagging the resources created."
  default     = "AWSDevAccount"
}

variable "environment_tag" {
  type        = string
  description = "Provide which environment this will be deployed. Used for tagging the resources created."
}

variable "aws_backend_private_subnet1_id" {
  type        = string
  description = "Designated CIDR block of aws-backend-private-subnet-1 to be created."
}

variable "aws_backend_private_subnet2_id" {
  type        = string
  description = "Designated CIDR block of aws-backend-private-subnet-2 to be created."
}

variable "aws_backend_public_subnet1_id" {
  type        = string
  description = "Designated CIDR block of aws-backend-public-subnet-1 to be created."
}

variable "aws_backend_public_subnet2_id" {
  type        = string
  description = "Designated CIDR block of aws-backend-public-subnet-2 to be created."
}

variable "aws_backend_security_group1_id" {
  type        = string
  description = "Designated security group of aws-backend-alb in aws-backend-vpc."
}

variable "aws_backend_vpc_id" {
  type = string
  description = "The ID of the aws-backend-vpc."
}
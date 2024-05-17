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

variable "aws_region" {
  type        = string
  description = "Designated AWS_REGION where this solution will be deployed."
}

variable "vpc_cidr_block" {
  type        = string
  description = "Designated CIDR block of VPC to be created."
}

variable "private_subnet1_cidr_block" {
  type        = string
  description = "Designated CIDR block of aws-backend-private-subnet-1 to be created."
}

variable "private_subnet2_cidr_block" {
  type        = string
  description = "Designated CIDR block of aws-backend-private-subnet-2 to be created."
}

variable "public_subnet1_cidr_block" {
  type        = string
  description = "Designated CIDR block of aws-backend-public-subnet-1 to be created."
}

variable "public_subnet2_cidr_block" {
  type        = string
  description = "Designated CIDR block of aws-backend-public-subnet-2 to be created."
}

variable "private_subnet1_az" {
  type        = string
  description = "Designated availability zone of aws-backend-private-subnet-1 to be created."
}

variable "private_subnet2_az" {
  type        = string
  description = "Designated availability zone of aws-backend-private-subnet-2 to be created."
}

variable "public_subnet1_az" {
  type        = string
  description = "Designated availability zone of aws-backend-public-subnet-1 to be created."
}

variable "public_subnet2_az" {
  type        = string
  description = "Designated availability zone of aws-backend-public-subnet-2 to be created."
}
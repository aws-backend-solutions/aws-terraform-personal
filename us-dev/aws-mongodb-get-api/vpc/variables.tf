variable "prefix_name" {
  type = string
}

variable "aws_region" {
  type        = string
  description = "Designated AWS_REGION where this solution will be deployed."
}

variable "aws_backend_private_route_table_id" {
  type        = string
  description = "The ID of private route table."
}

variable "aws_backend_vpc_id" {
  type        = string
  description = "The ID of the aws-backend-vpc."
}

variable "vpc_id_to_peer" {
  type        = string
  description = "ID of the VPC to peer with."
}

variable "cidr_block_of_vpc_to_peer" {
  type        = string
  description = "CIDR block of the peered VPC to add for routing tables."
}

variable "aws_backend_private_subnet1_id" {
  type        = string
  description = "Designated CIDR block of aws-backend-private-subnet-1 to be created."
}

variable "aws_backend_private_subnet2_id" {
  type        = string
  description = "Designated CIDR block of aws-backend-private-subnet-2 to be created."
}

variable "aws_backend_security_group3_id" {
  type        = string
  description = "Designated security group of api gateway in aws-backend-vpc."
}
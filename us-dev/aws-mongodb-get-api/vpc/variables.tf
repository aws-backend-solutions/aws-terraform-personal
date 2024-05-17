variable "prefix_name" {
  type = string
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

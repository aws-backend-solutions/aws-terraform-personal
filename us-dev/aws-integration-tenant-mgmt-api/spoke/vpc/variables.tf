variable "prefix_name" {
  type = string
}

variable "aws_region" {
  type        = string
  description = "Designated AWS_REGION where this solution will be deployed."
}

variable "aws_backend_public_subnet1_id" {
  type        = string
  description = "The ID of private route table."
}

variable "aws_backend_private_route_table_id" {
  type        = string
  description = "The ID of the aws-backend-public-subnet-1."
}
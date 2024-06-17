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

# these are for the mongodb (vpc within the same account)

variable "vpc_id_to_peer" {
  type        = string
  description = "ID of the VPC to peer with."
}

variable "cidr_block_of_vpc_to_peer" {
  type        = string
  description = "CIDR block of the peered VPC to add for routing tables."
}

# these are for the vpc from another account

variable "peer_aws_account_id" {
  description = "AWS Account ID of the peer VPC"
  type        = string
}

variable "peer_vpc_id" {
  description = "VPC ID of the peer VPC"
  type        = string
}

variable "peer_vpc_cidr_block" {
  description = "CIDR block of the peer VPC"
  type        = string
}
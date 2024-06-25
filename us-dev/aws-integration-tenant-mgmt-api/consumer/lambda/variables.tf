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

variable "project_tag" {
  type        = string
  description = "Provide the repository name. Used for tagging the resources created."
}

variable "lambda_function_name" {
  type        = string
  description = "Lambda's function name."
  default     = "function"
}

variable "stage_name" {
  type        = string
  description = "Stage where this solution will be deployed."
}

variable "primary_aws_backend_private_subnet1_id" {
  type        = string
  description = "The ID of the primary-aws-backend-private-subnet-1."
}

variable "primary_aws_backend_private_subnet2_id" {
  type        = string
  description = "The ID of the primary-aws-backend-private-subnet-2."
}

variable "primary_aws_backend_security_group2_id" {
  type        = string
  description = "Designated security group of lambdas in primary-aws-backend-vpc."
}

variable "us_dev_domain" {
  type        = string
  description = "Oregon dev domain."
}

variable "us_staging_domain" {
  type        = string
  description = "Oregon staging domain."
}

variable "us_prod_domain" {
  type        = string
  description = "Oregon prod domain."
}

variable "eu_staging_domain" {
  type        = string
  description = "Frankfurt staging domain."
}

variable "eu_prod_domain" {
  type        = string
  description = "Frankfurt prod domain."
}

variable "us_staging_vpce" {
  type        = string
  description = "Public DNS of the VPC endpoint of the solution deployed in us-staging."
}

variable "eu_staging_vpce" {
  type        = string
  description = "Public DNS of the VPC endpoint of the solution deployed in eu-staging."
}
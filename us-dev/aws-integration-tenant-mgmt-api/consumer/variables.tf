########## common variables ##########

variable "prefix_name" {
  type = string
}

variable "aws_region" {
  type        = string
  description = "Designated AWS_REGION where this solution will be deployed."
}

variable "environment_tag" {
  type        = string
  description = "Provide which environment this will be deployed. Used for tagging the resources created."
}

variable "project_tag" {
  type        = string
  description = "Provide the repository name. Used for tagging the resources created."
}

########## aws-integration-tenant-mgmt-api/consumer/lambda ##########

variable "us_staging_vpce" {
  type        = string
  description = "Public DNS of the VPC endpoint of the solution deployed in us-staging."
}

variable "eu_staging_vpce" {
  type        = string
  description = "Public DNS of the VPC endpoint of the solution deployed in eu-staging."
}

########## aws-integration-tenant-mgmt-api/consumer/api_gateway ##########

variable "stage_name" {
  type        = string
  description = "Stage where this solution will be deployed."
}
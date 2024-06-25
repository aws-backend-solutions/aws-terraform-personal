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

# domains

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

# vpc endpoints

variable "us_dev_vpce" {
  type        = string
  description = "Public DNS of the VPC endpoint of the solution deployed in us-dev."
}

variable "us_staging_vpce" {
  type        = string
  description = "Public DNS of the VPC endpoint of the solution deployed in eu-staging."
}

variable "us_prod_vpce" {
  type        = string
  description = "Public DNS of the VPC endpoint of the solution deployed in us-prod."
}

variable "eu_staging_vpce" {
  type        = string
  description = "Public DNS of the VPC endpoint of the solution deployed in eu-staging."
}

variable "eu_prod_vpce" {
  type        = string
  description = "Public DNS of the VPC endpoint of the solution deployed in eu-prod."
}

# api ids

variable "us_dev_api_id" {
  type        = string
  description = "Public DNS of the VPC endpoint of the solution deployed in us-dev."
}

variable "us_staging_api_id" {
  type        = string
  description = "Public DNS of the VPC endpoint of the solution deployed in eu-staging."
}

variable "us_prod_api_id" {
  type        = string
  description = "Public DNS of the VPC endpoint of the solution deployed in us-prod."
}

variable "eu_staging_api_id" {
  type        = string
  description = "Public DNS of the VPC endpoint of the solution deployed in eu-staging."
}

variable "eu_prod_api_id" {
  type        = string
  description = "Public DNS of the VPC endpoint of the solution deployed in eu-prod."
}

########## aws-integration-tenant-mgmt-api/consumer/api_gateway ##########

variable "stage_name" {
  type        = string
  description = "Stage where this solution will be deployed."
}
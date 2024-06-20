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

########## aws-integration-tenant-mgmt-api/consumer/api_gateway ##########

variable "stage_name" {
  type        = string
  description = "Stage where this solution will be deployed."
}

##### /us-staging

variable "us_staging_path_part" {
  type = string
}

variable "us_staging_aws_integration_tenant_mgmt_api_id" {
  type = string
}

##### /eu-staging

variable "eu_staging_path_part" {
  type = string
}

variable "eu_staging_aws_integration_tenant_mgmt_api_id" {
  type = string
}
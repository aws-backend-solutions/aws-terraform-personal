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

########## aws-integration-tenant-mgmt-api/hub/api_gateway ##########

variable "stage_name" {
  type        = string
  description = "Stage where this solution will be deployed."
}

variable "path_part" {
  type        = string
  description = "Path part of the API endpoint."
}

variable "aws_integration_tenant_mgmt_api_id" {
  type        = string
  description = "ID for aws-integration-tenant-mgmt-api"
}

variable "api_gateway_invocation_role_arn" {
  type        = string
  description = "ARN for aws-integration-tenant-mgmt-api-gateway-invocation-role"
}
variable "prefix_name" {
  type = string
}

variable "aws_region" {
  type        = string
  description = "Designated AWS_REGION where this solution will be deployed."
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

variable "stage_name" {
  type        = string
  description = "Stage where this solution will be deployed."
}

variable "path_part" {
  type        = string
  description = "Path part of the API endpoint."
}

variable "primary_aws_backend_vpc_endpoint_id" {
  type        = string
  description = "The ID of the primary AwsBackendVpcEndpoint."
}

variable "primary_aws_backend_nlb_dns_name" {
  type        = string
  description = "DNS name of primary_aws_integration_tenant_mgmt_nlb_dns_name."
}

variable "primary_aws_backend_nlb_arn" {
  type        = string
  description = "ARN of primary_aws_integration_tenant_mgmt_nlb."
}

variable "aws_integration_tenant_mgmt_api_id" {
  type        = string
  description = "ID for aws-integration-tenant-mgmt-api"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID where this solution will be deployed."
}
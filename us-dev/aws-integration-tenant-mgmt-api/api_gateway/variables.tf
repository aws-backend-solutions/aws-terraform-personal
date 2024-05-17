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

variable "aws_environment" {
  type        = string
  description = "Designated AWS_ENV where this solution will be deployed."
}

variable "path_part" {
  type        = string
  description = "Path part of the API endpoint."
}

variable "aws_backend_vpc_endpoint_id" {
  type        = string
  description = "The ID of the AwsBackendVpcEndpoint."
}

variable "aws_integration_tenant_mgmt_function_invoke_arn" {
  type        = string
  description = "The Invoke ARN of the underlying Lambda function."
}
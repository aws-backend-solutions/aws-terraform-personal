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

variable "aws_backend_vpc_endpoint_id" {
  type        = string
  description = "The ID of the AwsBackendVpcEndpoint."
}

variable "aws_customer_data_upload_function_invoke_arn1" {
  type        = string
  description = "The Invoke ARN of the underlying upload and generate new url Lambda function."
}

variable "aws_customer_data_upload_function_invoke_arn2" {
  type        = string
  description = "The Invoke ARN of the underlying regenerate new url Lambda function."
}

variable "aws_customer_data_upload_bucket_name" {
  type = string
  description = "The name of the designated s3 bucket for customers' data."
}

variable "aws_backend_api_gateway_role_name" {
  type = string
  description = "The name of the aws_backend_api_gateway_role."
}
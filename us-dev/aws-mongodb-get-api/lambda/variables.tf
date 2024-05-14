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
  description = "Provide the project name. Used for tagging the resources created."
}

variable "lambda_function_name" {
  type        = string
  description = "Lambda's function name."
  default     = "aws-mongodb-ga-function"
}

variable "mongodb_url" {
  type        = string
  description = "Connection string of the MongoDB to connect with."
}

variable "mongodb_name" {
  type        = string
  description = "Database name for the lambda to query with."
}

variable "aws_backend_private_subnet1_id" {
  type        = string
  description = "Designated CIDR block of aws-backend-private-subnet-1 to be created."
}

variable "aws_backend_private_subnet2_id" {
  type        = string
  description = "Designated CIDR block of aws-backend-private-subnet-2 to be created."
}

variable "aws_backend_security_group2_id" {
  type        = string
  description = "Designated security group of lambdas in aws-backend-vpc."
}

variable "aws_backend_load_balancer_listener_arn" {
  type        = string
  description = "The ARN of the Load Balancer Listener."
}

variable "aws_environment" {
  type        = string
  description = "Designated AWS_ENV where this solution will be deployed."
}

variable "path_part" {
  type        = string
  description = "Path part of the API endpoint."
  default     = "documents"
}
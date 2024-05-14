########## common variables ##########

variable "aws_region" {
  type        = string
  description = "Designated AWS_REGION where this solution will be deployed."
}

variable "aws_access_key" {
  type        = string
  description = "Access key for the AWS profile."
}

variable "aws_secret_key" {
  type        = string
  description = "Secret key for the AWS profile."
}

variable "environment_tag" {
  type        = string
  description = "Provide which environment this will be deployed. Used for tagging the resources created."
}

variable "project_tag" {
  type        = string
  description = "Provide the repository name. Used for tagging the resources created."
}

variable "github_token" { # this token needs to be generated in the github's developer settings with a read:project permission.
  type        = string
  description = "Token to authenticate the use of github links as the source path for the modules."
}

########## modules/vpc ##########

variable "private_ip_to_peer" {
  type        = string
  description = "Private IPv4 of the VPC to communicate with."
}

########## aws-mongodb-get-api/lambda ##########

variable "mongodb_name" {
  type        = string
  description = "Database name for the lambda to query with."
}

########## aws-mongodb-get-api/api_gateway ##########

variable "aws_environment" {
  type        = string
  description = "Designated AWS_ENV where this solution will be deployed."
}

variable "path_part" {
  type        = string
  description = "Path part of the API endpoint."
  default     = "documents"
}

########## aws-mongodb-get-api/budgets ##########

variable "lambda_budget_limit_amount" {
  type        = string
  description = "The amount of cost or usage being measured for for the aws-mongodb-ga-function."
}

variable "lambda_budget_time_unit" {
  type        = string
  description = "The length of time until a budget resets the actual and forecasted spend for the aws-mongodb-ga-function."
}

variable "api_gateway_budget_limit_amount" {
  type        = string
  description = "The threshold set for the aws-mongodb-ga-api."
}

variable "api_gateway_budget_time_unit" {
  type        = string
  description = "The length of time until a budget resets the actual and forecasted spend for the aws-mongodb-ga-api."
}
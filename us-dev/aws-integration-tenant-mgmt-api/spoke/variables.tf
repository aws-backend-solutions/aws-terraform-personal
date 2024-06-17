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

########## aws-integration-tenant-mgmt-api/spoke/lambda ##########

variable "lambda_function_name" {
  type        = string
  description = "Lambda's function name."
  default     = "aws-integration-tenant-mgmt-api/spoke-function"
}

# db variables

variable "mongodb_domain" {
  type        = string
  description = "Domain address of where the solution will be deployed."
}

variable "us_dev_domain" {
  type        = string
  description = "Domain address of the us-dev."
}

variable "us_stage_domain" {
  type        = string
  description = "Domain address of the us-stage."
}

variable "us_prod_domain" {
  type        = string
  description = "Domain address of the us-prod."
}

variable "mongodb_url" {
  type        = string
  description = "Connection string of the us-dev MongoDB to connect with."
}

variable "mongodb_name" {
  type        = string
  description = "Database name in us-dev for the lambda to query with."
}

variable "env_secret" {
  type        = string
  description = "Secret used to decrypt the tenant config."
}

variable "eu_stage_domain" {
  type        = string
  description = "Domain address of the eu-stage."
}

variable "eu_prod_domain" {
  type        = string
  description = "Domain address of the eu-prod."
}

variable "us_dev_usr" {
  type        = string
  description = "Admin tenant's username used to create tenant in the target_env."
}

variable "us_dev_pwd" {
  type        = string
  description = "Admin tenant's password used to create tenant in the target_env."
}

variable "us_staging_usr" {
  type        = string
  description = "Admin tenant's username used to create tenant in the target_env."
}

variable "us_staging_pwd" {
  type        = string
  description = "Admin tenant's password used to create tenant in the target_env."
}

variable "us_prod_usr" {
  type        = string
  description = "Admin tenant's username used to create tenant in the target_env."
}

variable "us_prod_pwd" {
  type        = string
  description = "Admin tenant's password used to create tenant in the target_env."
}

variable "eu_staging_usr" {
  type        = string
  description = "Admin tenant's username used to create tenant in the target_env."
}

variable "eu_staging_pwd" {
  type        = string
  description = "Admin tenant's password used to create tenant in the target_env."
}

variable "eu_prod_usr" {
  type        = string
  description = "Admin tenant's username used to create tenant in the target_env."
}

variable "eu_prod_pwd" {
  type        = string
  description = "Admin tenant's password used to create tenant in the target_env."
}

# query variables

variable "collection_name" {
  type        = string
  description = "Collection name as part of the query."
}

variable "api_endpoint" {
  type        = string
  description = "API endpoint to trigger the tenant creation."
}

########## aws-integration-tenant-mgmt-api/spoke/api_gateway ##########

variable "stage_name" {
  type        = string
  description = "Stage where this solution will be deployed."
}

variable "path_part" {
  type        = string
  description = "Path part of the API endpoint."
}

########## aws-integration-tenant-mgmt-api/spoke/budgets ##########

variable "lambda_budget_limit_amount" {
  type        = string
  description = "The amount of cost or usage being measured for for the aws-integration-tenant-mgmt-api function."
}

variable "lambda_budget_time_unit" {
  type        = string
  description = "The length of time until a budget resets the actual and forecasted spend for the aws-integration-tenant-mgmt-api function."
}

variable "api_gateway_budget_limit_amount" {
  type        = string
  description = "The threshold set for the aws-integration-tenant-mgmt-api."
}

variable "api_gateway_budget_time_unit" {
  type        = string
  description = "The length of time until a budget resets the actual and forecasted spend for the aws-integration-tenant-mgmt-api."
}
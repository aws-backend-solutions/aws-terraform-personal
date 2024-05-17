########## common variables ##########

variable "prefix_name" {
  type = string
}

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

########## aws-mongodb-get-api/lambda ##########

variable "lambda_function_name" {
  type        = string
  description = "Lambda's function name."
  default     = "aws-integration-tenant-mgmt-function"
}

# oregon variables

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

variable "us_dev_url" {
  type        = string
  description = "Connection string of the us-dev MongoDB to connect with."
}

variable "us_stage_url" {
  type        = string
  description = "Connection string of the us-stage MongoDB to connect with."
}

variable "us_prod_url" {
  type        = string
  description = "Connection string of the us-prod MongoDB to connect with."
}

variable "us_dev_db" {
  type        = string
  description = "Database name in us-dev for the lambda to query with."
}

variable "us_stage_db" {
  type        = string
  description = "Database name in us-stage for the lambda to query with."
}

variable "us_prod_db" {
  type        = string
  description = "Database name in us-prod for the lambda to query with."
}

variable "us_dev_usr" {
  type        = string
  description = "Admin tenant's username used in us-dev."
}

variable "us_stage_usr" {
  type        = string
  description = "Admin tenant's username used in us-stage."
}

variable "us_prod_usr" {
  type        = string
  description = "Admin tenant's username used in us-prod."
}

variable "us_dev_pwd" {
  type        = string
  description = "Admin tenant's password used in us-dev."
}

variable "us_stage_pwd" {
  type        = string
  description = "Admin tenant's password used in us-stage."
}

variable "us_prod_pwd" {
  type        = string
  description = "Admin tenant's password used in us-prod."
}

variable "us_dev_secret" {
  type        = string
  description = "Secret used in us-dev."
}

variable "us_stage_secret" {
  type        = string
  description = "Secret used in us-stage."
}

variable "us_prod_secret" {
  type        = string
  description = "Secret used in us-prod."
}

# frankfurt variables

variable "eu_stage_url" {
  type        = string
  description = "Connection string of the eu-stage MongoDB to connect with."
}

variable "eu_prod_url" {
  type        = string
  description = "Connection string of the eu-prod MongoDB to connect with."
}

variable "eu_stage_db" {
  type        = string
  description = "Database name in eu-stage for the lambda to query with."
}

variable "eu_prod_db" {
  type        = string
  description = "Database name in eu-prod for the lambda to query with."
}

variable "eu_stage_domain" {
  type        = string
  description = "Domain address of the eu-stage."
}

variable "eu_prod_domain" {
  type        = string
  description = "Domain address of the eu-prod."
}

variable "eu_stage_usr" {
  type        = string
  description = "Admin tenant's username used in eu-stage."
}

variable "eu_prod_usr" {
  type        = string
  description = "Admin tenant's username used in eu-prod."
}

variable "eu_stage_pwd" {
  type        = string
  description = "Admin tenant's password used in eu-stage."
}

variable "eu_prod_pwd" {
  type        = string
  description = "Admin tenant's password used in eu-prod."
}

variable "eu_dev_secret" {
  type        = string
  description = "Secret eued in eu-dev."
}

variable "eu_stage_secret" {
  type        = string
  description = "Secret eued in eu-stage."
}

variable "eu_prod_secret" {
  type        = string
  description = "Secret eued in eu-prod."
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

########## aws-mongodb-get-api/api_gateway ##########

variable "stage_name" {
  type        = string
  description = "Stage where this solution will be deployed."
}

variable "path_part" {
  type        = string
  description = "Path part of the API endpoint."
}

########## aws-mongodb-get-api/budgets ##########

variable "lambda_budget_limit_amount" {
  type        = string
  description = "The amount of cost or usage being measured for for the aws-integration-tenant-mgmt-function."
}

variable "lambda_budget_time_unit" {
  type        = string
  description = "The length of time until a budget resets the actual and forecasted spend for the aws-integration-tenant-mgmt-function."
}

variable "api_gateway_budget_limit_amount" {
  type        = string
  description = "The threshold set for the aws-integration-tenant-mgmt-api."
}

variable "api_gateway_budget_time_unit" {
  type        = string
  description = "The length of time until a budget resets the actual and forecasted spend for the aws-integration-tenant-mgmt-api."
}
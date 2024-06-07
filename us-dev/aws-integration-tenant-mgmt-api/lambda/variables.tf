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

variable "lambda_function_name" {
  type        = string
  description = "Lambda's function name."
  default     = "aws-integration-tenant-mgmt-function"
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

variable "aws_integration_tenant_mgmt_kms_key_id" {
  type        = string
  description = "The ID of the KMS key created for this project."
}
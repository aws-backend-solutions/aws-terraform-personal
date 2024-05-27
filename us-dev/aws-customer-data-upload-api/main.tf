terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "aws-backend-tf-state"
    key            = "aws-customer-data-upload-api/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "aws-backend-tf-lockid"
  }
}

provider "aws" {
  region = var.aws_region
}

provider "github" {
  token = var.github_token
}

data "terraform_remote_state" "modules" {
  backend = "s3"

  config = {
    bucket = "aws-backend-tf-state"
    key    = "modules/terraform.tfstate"
    region = "us-west-2"
  }
}

module "s3" {
  source          = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-customer-data-upload-api/s3"
  prefix_name     = var.prefix_name
  environment_tag = var.environment_tag
  project_tag     = var.project_tag
}

module "lambda" {
  source                              = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-customer-data-upload-api/lambda"
  prefix_name                         = var.prefix_name
  environment_tag                     = var.environment_tag
  project_tag                         = var.project_tag
  new_function_name                   = var.new_function_name
  renew_function_name                 = var.renew_function_name
  aws_customer_data_upload_bucket_arn = module.s3.aws_customer_data_upload_bucket_arn
  aws_backend_private_subnet1_id      = data.terraform_remote_state.modules.outputs.aws_backend_private_subnet1_id
  aws_backend_private_subnet2_id      = data.terraform_remote_state.modules.outputs.aws_backend_private_subnet2_id
  aws_backend_security_group2_id      = data.terraform_remote_state.modules.outputs.aws_backend_security_group2_id
}

module "api_gateway" {
  source                                        = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-customer-data-upload-api/api_gateway"
  prefix_name                                   = var.prefix_name
  environment_tag                               = var.environment_tag
  project_tag                                   = var.project_tag
  stage_name                                    = var.stage_name
  path_part                                     = var.path_part
  aws_customer_data_upload_function_invoke_arn1 = module.lambda.aws_customer_data_upload_function_invoke_arn1
  aws_customer_data_upload_function_invoke_arn2 = module.lambda.aws_customer_data_upload_function_invoke_arn2
  aws_backend_vpc_endpoint_id                   = data.terraform_remote_state.modules.outputs.aws_backend_vpc_endpoint_id
}

module "budgets" {
  source                          = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-customer-data-upload-api/budgets"
  prefix_name                     = var.prefix_name
  environment_tag                 = var.environment_tag
  project_tag                     = var.project_tag
  budget_alert_topic_arn          = data.terraform_remote_state.modules.outputs.budget_alert_topic_arn
  lambda_budget_limit_amount      = var.lambda_budget_limit_amount
  lambda_budget_time_unit         = var.lambda_budget_time_unit
  api_gateway_budget_limit_amount = var.api_gateway_budget_limit_amount
  api_gateway_budget_time_unit    = var.api_gateway_budget_time_unit
}

module "cloudwatch" {
  source                     = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-customer-data-upload-api/cloudwatch"
  prefix_name                = var.prefix_name
  environment_tag            = var.environment_tag
  project_tag                = var.project_tag
  new_function_name          = var.new_function_name
  renew_function_name        = var.renew_function_name
  cloudwatch_alarm_topic_arn = data.terraform_remote_state.modules.outputs.cloudwatch_alarm_topic_arn
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "aws-backend-tfstate"
    key            = "aws-mongodb-get-api/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "aws-backend-tf-lockid"
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "github" {
  token = var.github_token
}

data "terraform_remote_state" "modules" {
  backend = "s3"

  config = {
    bucket = "aws-backend-tfstate"
    key    = "modules/terraform.tfstate"
    region = "us-west-2"
  }
}

module "lambda" {
  source                         = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-mongodb-get-api/lambda"
  prefix_name                    = var.prefix_name
  environment_tag                = var.environment_tag
  project_tag                    = var.project_tag
  aws_environment                = var.aws_environment
  path_part                      = var.path_part
  us_dev_mongodb_url             = "mongodb://${var.private_ip_to_peer}:27017/"
  us_stage_mongodb_url           = "mongodb://${var.private_ip_to_peer}:27017/"
  us_prod_mongodb_url            = "mongodb://${var.private_ip_to_peer}:27017/"
  us_dev_mongodb_name            = var.us_dev_mongodb_name
  us_stage_mongodb_name          = var.us_stage_mongodb_name
  us_prod_mongodb_name           = var.us_prod_mongodb_name
  eu_stage_mongodb_url           = "mongodb://${var.private_ip_to_peer}:27017/"
  eu_prod_mongodb_url            = "mongodb://${var.private_ip_to_peer}:27017/"
  eu_stage_mongodb_name          = var.eu_stage_mongodb_name
  eu_prod_mongodb_name           = var.eu_prod_mongodb_name
  aws_backend_private_subnet1_id = data.terraform_remote_state.modules.outputs.aws_backend_private_subnet1_id
  aws_backend_private_subnet2_id = data.terraform_remote_state.modules.outputs.aws_backend_private_subnet2_id
  aws_backend_security_group2_id = data.terraform_remote_state.modules.outputs.aws_backend_security_group2_id
}

module "api_gateway" {
  source                             = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-mongodb-get-api/api_gateway"
  prefix_name                        = var.prefix_name
  environment_tag                    = var.environment_tag
  project_tag                        = var.project_tag
  aws_environment                    = var.aws_environment
  path_part                          = var.path_part
  aws_mongodb_ga_function_invoke_arn = module.lambda.aws_mongodb_ga_function_invoke_arn
  aws_backend_vpc_endpoint_id        = data.terraform_remote_state.modules.outputs.aws_backend_vpc_endpoint_id
}

module "budgets" {
  source                          = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-mongodb-get-api/budgets"
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
  source                     = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-mongodb-get-api/cloudwatch"
  prefix_name                = var.prefix_name
  environment_tag            = var.environment_tag
  project_tag                = var.project_tag
  cloudwatch_alarm_topic_arn = data.terraform_remote_state.modules.outputs.cloudwatch_alarm_topic_arn
}
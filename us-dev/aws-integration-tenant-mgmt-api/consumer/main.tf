terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "aws-backend-tfstate"
    key            = "aws-integration-tenant-mgmt-api/consumer/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "aws-backend-tf-lockid"
  }
}

provider "aws" {
  region = var.aws_region
}

data "terraform_remote_state" "modules" {
  backend = "s3"

  config = {
    bucket = "aws-backend-tfstate"
    key    = "modules/consumer/terraform.tfstate"
    region = "us-west-2"
  }
}

module "lambda" {
  source                                 = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-integration-tenant-mgmt-api/consumer/lambda"
  prefix_name                            = var.prefix_name
  aws_region                             = var.aws_region
  environment_tag                        = var.environment_tag
  project_tag                            = var.project_tag
  stage_name                             = var.stage_name
  path_part                              = var.path_part
  primary_aws_backend_private_subnet1_id = data.terraform_remote_state.modules.outputs.primary_aws_backend_private_subnet1_id
  primary_aws_backend_private_subnet2_id = data.terraform_remote_state.modules.outputs.primary_aws_backend_private_subnet2_id
  primary_aws_backend_security_group2_id = data.terraform_remote_state.modules.outputs.primary_aws_backend_security_group2_id
  aws_integration_tenant_mgmt_api_id     = var.aws_integration_tenant_mgmt_api_id
}

data "aws_caller_identity" "current" {}

module "api_gateway" {
  source                                                     = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-integration-tenant-mgmt-api/consumer/api_gateway"
  prefix_name                                                = var.prefix_name
  aws_region                                                 = var.aws_region
  environment_tag                                            = var.environment_tag
  project_tag                                                = var.project_tag
  stage_name                                                 = var.stage_name
  path_part                                                  = var.path_part
  primary_aws_backend_vpc_endpoint_id                        = data.terraform_remote_state.modules.outputs.primary_aws_backend_vpc_endpoint_id
  aws_integration_tenant_mgmt_api_id                         = var.aws_integration_tenant_mgmt_api_id
  aws_account_id                                             = data.aws_caller_identity.current.account_id
  primary_aws_integration_tenant_mgmt_api_id                 = data.terraform_remote_state.modules.outputs.primary_aws_integration_tenant_mgmt_api_id
  primary_aws_integration_tenant_mgmt_api_root_resource_id   = data.terraform_remote_state.modules.outputs.primary_aws_integration_tenant_mgmt_api_root_resource_id
  primary_aws_integration_tenant_mgmt_api_body               = data.terraform_remote_state.modules.outputs.primary_aws_integration_tenant_mgmt_api_body
  aws_integration_tenant_mgmt_function_us_staging_invoke_arn = module.lambda.aws_integration_tenant_mgmt_function_us_staging_invoke_arn
}
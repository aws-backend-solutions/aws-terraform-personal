terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "aws-backend-tfstate"
    key            = "aws-integration-tenant-mgmt-api/hub/terraform.tfstate"
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
    key    = "modules/hub/terraform.tfstate"
    region = "us-west-2"
  }
}

module "nlb" {
  source                                 = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-integration-tenant-mgmt-api/hub/nlb"
  prefix_name                            = var.prefix_name
  environment_tag                        = var.environment_tag
  primary_aws_backend_security_group4_id = data.terraform_remote_state.modules.outputs.primary_aws_backend_security_group4_id
  primary_aws_backend_subnet_ids = [
    data.terraform_remote_state.modules.outputs.primary_aws_backend_private_subnet1_id,
    data.terraform_remote_state.modules.outputs.primary_aws_backend_private_subnet2_id,
    data.terraform_remote_state.modules.outputs.primary_aws_backend_public_subnet1_id,
    data.terraform_remote_state.modules.outputs.primary_aws_backend_public_subnet2_id
  ]
  primary_aws_backend_vpc_id = data.terraform_remote_state.modules.outputs.primary_aws_backend_vpc_id
  primary_aws_backend_vpc_endpoint_id = data.terraform_remote_state.modules.outputs.primary_aws_backend_vpc_endpoint_id
}

module "api_gateway" {
  source                                      = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-integration-tenant-mgmt-api/hub/api_gateway"
  prefix_name                                 = var.prefix_name
  environment_tag                             = var.environment_tag
  project_tag                                 = var.project_tag
  stage_name                                  = var.stage_name
  path_part                                   = var.path_part
  primary_aws_backend_vpc_endpoint_id         = data.terraform_remote_state.modules.outputs.primary_aws_backend_vpc_endpoint_id
  primary_aws_integration_tenant_mgmt_nlb_dns = module.nlb.primary_aws_integration_tenant_mgmt_nlb_dns
  primary_aws_integration_tenant_mgmt_nlb_arn = module.nlb.primary_aws_integration_tenant_mgmt_nlb_arn
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "aws-backend-tf-state"
    key            = "modules/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "aws-backend-tf-lockid"
  }
}

provider "aws" {
  region = var.aws_region
}

module "api_gateway" {
  source                              = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/aws-integration-tenant-mgmt-api/hub/api_gateway"
  prefix_name                         = var.prefix_name
  environment_tag                     = var.environment_tag
  project_tag                         = var.project_tag
  stage_name                          = var.stage_name
  path_part                           = var.path_part
  primary_aws_backend_vpc_endpoint_id = data.terraform_remote_state.modules.outputs.primary_aws_backend_vpc_endpoint_id
  aws_backend_vpc_endpoint_id         = var.aws_backend_vpc_endpoint_id
}
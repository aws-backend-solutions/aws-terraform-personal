terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "aws-backend-tf-state"
    key            = "modules/provider/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "aws-backend-tf-lockid"
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source                     = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/modules/provider/vpc"
  prefix_name                = var.prefix_name
  aws_region                 = var.aws_region
  vpc_cidr_block             = var.vpc_cidr_block
  private_subnet1_cidr_block = var.private_subnet1_cidr_block
  private_subnet2_cidr_block = var.private_subnet2_cidr_block
  public_subnet1_cidr_block  = var.public_subnet1_cidr_block
  public_subnet2_cidr_block  = var.public_subnet2_cidr_block
  private_subnet1_az         = var.private_subnet1_az
  private_subnet2_az         = var.private_subnet2_az
  public_subnet1_az          = var.public_subnet1_az
  public_subnet2_az          = var.public_subnet2_az
  environment_tag            = var.environment_tag
  vpc_id_to_peer             = var.vpc_id_to_peer
  cidr_block_of_vpc_to_peer  = var.cidr_block_of_vpc_to_peer
}

data "aws_network_interface" "primary_aws_backend_vpc_endpoint_ips" {
  for_each = toset(module.vpc.primary_aws_backend_vpc_endpoint_enis)
  id       = each.value
}

locals {
  primary_aws_backend_vpc_endpoint_ips = [
    for eni in data.aws_network_interface.primary_aws_backend_vpc_endpoint_ips : eni.private_ips[0]
  ]
}

module "nlb" {
  source                         = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/modules/provider/nlb"
  prefix_name                    = var.prefix_name
  environment_tag                = var.environment_tag
  aws_backend_security_group4_id = module.vpc.aws_backend_security_group4_id
  aws_backend_subnet_ids = [
    module.vpc.aws_backend_private_subnet1_id,
    module.vpc.aws_backend_private_subnet2_id
  ]
  aws_backend_vpc_id           = module.vpc.ws_backend_vpc_id
  aws_backend_vpc_endpoint_ips = local.aws_backend_vpc_endpoint_ips
  stage_name                   = var.stage_name
}

module "sns" {
  source                   = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/modules/provider/sns"
  prefix_name              = var.prefix_name
  environment_tag          = var.environment_tag
  recipient_for_budgets    = var.recipient_for_budgets
  recipient_for_cloudwatch = var.recipient_for_cloudwatch
}

module "iam" {
  source      = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/modules/provider/iam"
  prefix_name = var.prefix_name
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "aws-backend-tfstate"
    key            = "modules/consumer/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "aws-backend-tf-lockid"
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source                     = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/modules/consumer/vpc"
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
  # peer_aws_account_id        = var.peer_aws_account_id
  # peer_vpc_id                = var.peer_vpc_id
  # peer_vpc_cidr_block        = var.peer_vpc_cidr_block
}

module "api_gateway" {
  source                              = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/modules/consumer/api_gateway"
  prefix_name                         = var.prefix_name
  aws_region                          = var.aws_region
  environment_tag                     = var.environment_tag
  primary_aws_backend_vpc_endpoint_id = module.vpc.primary_aws_backend_vpc_endpoint_id
}
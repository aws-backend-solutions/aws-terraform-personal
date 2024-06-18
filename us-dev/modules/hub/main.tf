terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "aws-backend-tfstate"
    key            = "modules/hub/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "aws-backend-tf-lockid"
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source                     = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/modules/hub/vpc"
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
}

module "nlb" {
  source                     = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/modules/hub/nlb"
  prefix_name                = var.prefix_name
  environment_tag            = var.environment_tag
  primary_aws_backend_security_group4_id = module.vpc.primary_aws_backend_security_group4_id
  primary_aws_backend_subnet_ids = [
    module.vpc.primary_aws_backend_private_subnet1_id,
    module.vpc.primary_aws_backend_private_subnet2_id,
    module.vpc.primary_aws_backend_public_subnet1_id,
    module.vpc.primary_aws_backend_public_subnet2_id
  ]
}
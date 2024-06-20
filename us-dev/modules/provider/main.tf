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
    region         = "eu-central-1"
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
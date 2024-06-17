terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "aws-backend-tf-state"
    key            = "modules/spoke/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "aws-backend-tf-lockid"
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source                     = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/modules/spoke/vpc"
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
  peer_aws_account_id        = var.peer_aws_account_id
  peer_vpc_id                = var.peer_vpc_id
  peer_vpc_cidr_block        = var.peer_vpc_cidr_block
}

module "sns" {
  source                   = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/modules/spoke/sns"
  prefix_name              = var.prefix_name
  environment_tag          = var.environment_tag
  recipient_for_budgets    = var.recipient_for_budgets
  recipient_for_cloudwatch = var.recipient_for_cloudwatch
}

module "iam" {
  source      = "github.com/aws-backend-solutions/aws-terraform-personal/us-dev/modules/spoke/iam"
  prefix_name = var.prefix_name
}
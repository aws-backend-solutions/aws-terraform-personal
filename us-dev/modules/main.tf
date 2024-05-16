terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "aws-backend-tfstate"
    key            = "modules/terraform.tfstate"
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

module "vpc" {
  source                     = "github.com/${var.org_name}/${var.repo_name}/us-dev/modules/vpc"
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
  vpc_id_to_peer             = var.vpc_id_to_peer
  private_ip_to_peer         = var.private_ip_to_peer
  cidr_block_of_vpc_to_peer  = var.cidr_block_of_vpc_to_peer
  environment_tag            = var.environment_tag
}

module "alb" {
  source                         = "github.com/${var.org_name}/${var.repo_name}/us-dev/modules/alb"
  environment_tag                = var.environment_tag
  aws_backend_private_subnet1_id = module.vpc.aws_backend_private_subnet1_id
  aws_backend_private_subnet2_id = module.vpc.aws_backend_private_subnet2_id
  aws_backend_public_subnet1_id  = module.vpc.aws_backend_public_subnet1_id
  aws_backend_public_subnet2_id  = module.vpc.aws_backend_public_subnet2_id
  aws_backend_security_group1_id = module.vpc.aws_backend_security_group1_id
}

module "sns" {
  source                   = "github.com/${var.org_name}/${var.repo_name}us-dev/modules/sns"
  environment_tag          = var.environment_tag
  recipient_for_budgets    = var.recipient_for_budgets
  recipient_for_cloudwatch = var.recipient_for_cloudwatch
}
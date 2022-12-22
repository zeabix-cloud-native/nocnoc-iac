terraform {

backend "s3" {
    bucket         = "nocnoc-devops-prod"
    key            = "terraform-prod/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "nocnoc-prod-network-tf-state"
  }
  
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

module "network" {
  source = "../modules/vpc"
  vpc_cidr_blocks = var.vpc_cidr_blocks
  project_name = var.project_name
  tags = merge({ Project = var.project_name}, var.tags)
  availability_zones = var.availability_zones
  enable_kms = var.enable_kms
  primary_subnet_prefix = var.primary_subnet_prefix
}
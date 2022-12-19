terraform {
  backend "s3" {
    bucket         = var.bucket
    key            = var.key_state
    region         = var.region
    dynamodb_table = var.dynamodb_table
  }
}
locals {
  subnetID = concat(module.network.private_subnet_ids,module.network.public_subnet_ids)
}
provider "aws" {
  region = var.region
}
data "aws_availability_zones" "available" {}
module "network" {
  source = "./modules/vpc"
  vpc_cidr_blocks = var.vpc_cidr_blocks
  project_name = var.project_name
  tags = merge({ Project = var.project_name}, var.tags)
  availability_zones = var.availability_zones
  enable_kms = var.enable_kms
}
module "eks" {
  source = "./modules/eks"
  cluster_name    = "${var.project_name}"
  cluster_version = var.cluster_version
  vpc_id          = module.network.vpc_id
  subnet_ids      = local.subnetID
  managed_node_groups = {
    mg_ondemand = {
      node_group_name = "managed-spot-ondemand"
      instance_types  = var.instance_types
      min_size        = 3
      max_size        = 9
      desired_size    = 3
      subnet_ids      = local.subnetID
    }
    mg_gpu = {
      node_group_name = "managed-gpu-ondemand"
      instance_types  = var.instance_types
      min_size        = 3
      max_size        = 9
      desired_size    = 3
      subnet_ids      = local.subnetID
    }
  }
  
}
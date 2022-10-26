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
  cluster_name = "${var.project_name}-cluster"
  argocd_password = var.argocd_password
  vpc_id =  module.network.vpc_id
  subnet_ids = concat(module.network.private_subnet_ids,module.network.public_subnet_ids)
}
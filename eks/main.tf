terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = var.key_state
    region = var.region 
  }
}


module "eks" {
  source = "../modules/eks"
  cluster_name    = "${var.project_name}"
  cluster_version = var.cluster_version
  vpc_id          = data.terraform_remote_state.network.outputs.vpc_id
    
  subnet_ids      = data.terraform_remote_state.network.outputs.subnet_ids

  managed_node_groups = local.managed_node_groups
  enable_sigstore = var.enable_sigstore
  create_namespaces = var.create_namespaces
  
}
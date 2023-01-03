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

resource "aws_elasticache_subnet_group" "redis" {
  name       = var.subnet_group_name
  subnet_ids = local.subnet_ids
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id = var.cluster_id
  engine                = "redis"
  # Note that ElastiCache for Outposts only supports M5 and R5 node families currently
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = var.parameter_group_name
  port                 = var.port
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
}
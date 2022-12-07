region                   = "ap-southeast-1"

#availability_zones_count = 2

project_name             = "nocnoc-production"

vpc_cidr_blocks          = {
    "public_cidr_block" = "150.100.0.0/16"
    "database_cidr_block" = "150.101.0.0/16"
  } 

tags                     = {
    Platform = "eks"
    Owner= ""
    Env = "production"
}

enable_kms               = false

availability_zones       = {
    "az1" = "ap-southeast-1a"
    "az2" = "ap-southeast-1b"
    "az3" = "ap-southeast-1c"
  }

cluster_version          = "1.23"

cluster_name             = "nocnoc_cluster"

instance_types           = ["t3.medium"]
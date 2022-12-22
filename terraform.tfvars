region         = "ap-southeast-1"
### Backend ZONE
bucket         = "nocnoc-devops"
key            = "terraform-prod/terraform.tfstate"
dynamodb_table = "nocnoc-tf-state"

project_name             = "nocnoc-production"
### VPC ZONE
vpc_cidr_blocks          = {
    "public_cidr_block" = "172.16.0.0/16"
    "database_cidr_block" = "150.101.0.0/16"
  } 

### Cluster ZONE 
cluster_version          = "1.24"
cluster_name             = "nocnoc_cluster"
instance_types           = ["t3.medium"]
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





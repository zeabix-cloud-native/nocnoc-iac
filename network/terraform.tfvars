region         = "ap-southeast-1"
### Backend ZONE
bucket         = "nocnoc-devops"
key_state            = "terraform-performance/network/terraform.tfstate"
dynamodb_table = "performance-network-tf-state"


project_name             = "nocnoc-performance"
### VPC ZONE
vpc_cidr_blocks          = {
    "primary_cidr_block" = "172.18.0.0/16"
    "secondary_cidr_block" = "172.38.0.0/16"
} 

tags                     = {
    Platform = "eks"
    Owner= ""
    Env = "performance"
}
enable_kms               = false
vpc_name = "vpc-nocnoc-performance"
availability_zones       = {
    "az1" = "ap-southeast-1a"
    "az2" = "ap-southeast-1b"
    "az3" = "ap-southeast-1c"
}
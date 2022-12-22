region         = "ap-southeast-1"
### Backend ZONE
bucket         = "nocnoc-devops"
key_state            = "terraform-prod/network/terraform.tfstate"
dynamodb_table = "prod-network-tf-state"


project_name             = "nocnoc-production"
### VPC ZONE
vpc_cidr_blocks          = {
    "primary_cidr_block" = "172.16.0.0/16"
    "secondary_cidr_block" = "172.36.0.0/16"
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
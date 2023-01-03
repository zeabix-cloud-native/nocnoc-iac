region         = "ap-southeast-1"

project_name             = "nocnoc-sandbox"
### VPC ZONE
vpc_cidr_blocks          = {
    "primary_cidr_block" = "172.17.0.0/16"
    "secondary_cidr_block" = "172.37.0.0/16"
} 

tags                     = {
    Platform = "eks"
    Owner= ""
    Env = "sandbox"
}
enable_kms               = true
vpc_name = "vpc-nocnoc-sandbox"
primary_subnet_prefix = "net"

availability_zones       = {
    "az1" = "ap-southeast-1a"
    "az2" = "ap-southeast-1b"
    "az3" = "ap-southeast-1c"
}

transit_gateway_id = "tgw-06923dc3adacdec95"
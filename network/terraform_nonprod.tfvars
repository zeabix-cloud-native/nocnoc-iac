region         = "ap-southeast-1"

project_name             = "nocnoc-nonproduction"
### VPC ZONE
vpc_cidr_blocks          = {
    "primary_cidr_block" = "172.17.0.0/16"
    "secondary_cidr_block" = "172.37.0.0/16"
} 

tags                     = {
    Platform = "eks"
    Owner= ""
    Env = "nonproduction"
}
enable_kms               = true
vpc_name = "vpc-nocnoc-nonprd"
primary_subnet_prefix = "net"

availability_zones       = {
    "az1" = "ap-southeast-1a"
    "az2" = "ap-southeast-1b"
    "az3" = "ap-southeast-1c"
}
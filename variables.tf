variable "region" {
  description = "Region of AWS provider"
  type = string
  default = "ap-southeast-1"
}
variable "project_name" {
  description = "Name of Project"
  type = string
  default = "prod"
}

variable "vpc_cidr_blocks" {
  description = "CIDR blocks for VPC"
  type = map(string)
  default = {
    "public_cidr_block" = "150.100.0.0/16"
    "database_cidr_block" = "150.101.0.0/16"
  }  
}

variable "tags" {
    description = "Array of the tags for all AWS resources created"
    default = {
        Platform = "eks"
        Owner= ""
        Env = "production"
    }
}
variable "enable_kms" {
  description = "Enable KMS for EKS encryption"
  type = bool
  default = false
}

variable "availability_zones" {
  description = "List of availability zone which want to setup EKS cluster"
  type = map(string)
  default = {
    "az1" = "ap-southeast-1a"
    "az2" = "ap-southeast-1b"
    "az3" = "ap-southeast-1c"
  }
}

variable "argocd_password" {
  description = "ArgoCd Password"
  type = string
  default = "asdfqwer"
}
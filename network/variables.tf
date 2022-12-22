variable "region" {
  description = "Region of AWS provider"
  type = string
}
variable "project_name" {
  description = "Name of Project"
  type = string
}

variable "vpc_cidr_blocks" {
  description = "CIDR blocks for VPC"
  type = map(string) 
}

variable "tags" {
    description = "Array of the tags for all AWS resources created"
}

variable "enable_kms" {
  description = "Enable KMS for EKS encryption"
  type = bool
}

variable "vpc_name" {
  description = "Name of VPC"
  type = string  
}

variable "availability_zones" {
  description = "List of availability zone which want to setup EKS cluster"
  type = map(string)
}

variable "primary_subnet_prefix" {
    description = "Subnet prefix for primary cidr block"
    type = string
}
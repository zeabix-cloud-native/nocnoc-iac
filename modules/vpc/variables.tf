variable "vpc_cidr_blocks" {
  description = "The VPC cidr for public zone and private zone"
  type = map(string)
}

variable "tags" {
  description = "List of Tags"
  type = map(string)
  default = {}
}

/*
* Availability zone to create the VPC network for EKS cluster
*/
variable "availability_zones" {
  description = "List of availability zone which want to setup EKS cluster"
  type = map(string)
}

variable "project_name" {
  description = "Name of the project, also being used as tag prefix"
  type = string
}

variable "enable_kms" {
  description = "Enable KMS for EKS encryption"
  type = bool
}
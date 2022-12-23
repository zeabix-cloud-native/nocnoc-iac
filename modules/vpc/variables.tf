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

variable "primary_subnet_prefix" {
  description = "Subnet prifix for primary cidr block"
  type = string
  
}

variable "vpc_name" {
  description = "Name of VPC"
  type = string  
}

variable "private_subnet_config" {
  description = "Private subnet configuration"
  type = list(object({
    name = string
    idx = number
    availability_zone = string
  })) 

  default = [
    {
      name = "net-prd-private-DB-1a"
      idx = 4
      availability_zone = "ap-southeast-1a"
    },
    {
      name = "net-prd-private-DB-1b"
      idx = 14
      availability_zone = "ap-southeast-1b"
    },
    {
      name = "net-prd-private-DB-1c"
      idx = 24
      availability_zone = "ap-southeast-1c"
    }

  ] 
}

variable "public_subnet_config" {
  description = "Public subnet configuration"
  type = list(object({
    name = string
    idx = number
    availability_zone = string
  })) 

  default = [
    {
      name = "private-Infra-1a"
      idx = 1
      availability_zone = "ap-southeast-1a"
    },
    {
      name = "private-Infra-1b"
      idx = 11
      availability_zone = "ap-southeast-1b"
    },
    {
      name = "private-Infra-1c"
      idx = 21
      availability_zone = "ap-southeast-1c"
    }

  ] 
}


variable "cluster_subnet_config" {
  description = "Cluster subnet configuration"
  type = list(object({
    name = string
    idx = number
    availability_zone = string
  })) 

  default = [
    {
      name = "private-App-1a"
      idx = 0
      availability_zone = "ap-southeast-1a"
    },
    {
      name = "private-App-1b"
      idx = 1
      availability_zone = "ap-southeast-1b"
    },
    {
      name = "private-App-1c"
      idx = 3
      availability_zone = "ap-southeast-1c"
    }
  ] 
}
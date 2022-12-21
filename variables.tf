variable "region" {
  description = "Region of AWS provider"
  type = string
}
variable "project_name" {
  description = "Name of Project"
  type = string
}

variable "eks_version" {
  description = "Version of EKS"
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

variable "availability_zones" {
  description = "List of availability zone which want to setup EKS cluster"
  type = map(string)
}

variable "cluster_version" {
  description = "Kubernetes cluster version"
  type        = string
}

variable "cluster_name" {
  description = "Name of cluster - used by Terratest for e2e test automation"
  type        = string
}

variable "instance_types" {
  description = "Type of instance"
  type        = list(string)
}

### Node Group ###
variable "managed_node_groups" {
  description = "Managed node group specification"
  type = any 
  

  default = {
    mg_ondemand = {
      node_group_name = "managed-spot-ondemand"
      instance_types  = var.instance_types #user input ["t3.small", "c5.xlarge"]
      min_size        = 3
      max_size        = 9
      desired_size    = 3

      ami_type = "AL2_x86_64"

      capacity_type  = "ON_DEMAND"  # ON_DEMAND or SPOT
      labels = {}
      taints = []
      tags = {}


      #subnet_ids      = local.subnetID
    }
    mg_gpu = {
      node_group_name = "managed-gpu-ondemand"
      instance_types  = var.instance_types
      min_size        = 3
      max_size        = 9
      desired_size    = 3

      ami_type = "AL2_x86_64"

      capacity_type  = "ON_DEMAND"  # ON_DEMAND or SPOT
      labels = {}
      taints = []
      tags = {}
      #subnet_ids      = local.subnetID
    }
  }
  
}

### Backend ####
variable "bucket" {
  description = "S3 Bucket for keep backend state"
  type = string
}

variable "key_state" {
  description = "Key use for state file store"
  type = string
}
variable "dynamodb_table" {
  description = "Dynamo table for store state"
  type = string
}
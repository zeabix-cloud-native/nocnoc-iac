variable "region" {
  description = "Region of AWS provider"
  type = string
}
variable "project_name" {
  description = "Name of Project"
  type = string
}


variable "tags" {
    description = "Array of the tags for all AWS resources created"
}

variable "enable_kms" {
  description = "Enable KMS for EKS encryption"
  type = bool
}

variable "cluster_version" {
  description = "Kubernetes cluster version"
  type        = string
}

variable "cluster_name" {
  description = "Name of cluster - used by Terratest for e2e test automation"
  type        = string
}

### Node Group ###
variable "managed_node_groups" {
  description = "Managed node group specification"
  type = any   
}

### Network remote state configuration ####
variable "bucket" {
  description = "S3 Bucket for keep backend state"
  type = string
}

variable "key_state" {
  description = "Key use for state file store"
  type = string
}

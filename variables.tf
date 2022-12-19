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
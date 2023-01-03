variable "region" {
  description = "Region of AWS provider"
  type = string
}

variable "tags" {
    description = "Array of the tags for all AWS resources created"
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


### ElastiCache variables
variable "cluster_id" {
    description = "ElastiCache cluster id"
    type = string
}

variable "node_type" {
    description = "Node type, e.g. cache.t2.small"
    type = string
}

variable "subnet_group_name" {
    description = "Subnet group name"
    type = string
}

variable "port" {
    description = "Port number"
    type = number
}

variable "subnet_ids" {
    description = "Subnet IDs for subnet group"
    type = list(string)
}

variable "engine_version" {
    description = "Engine version"
    type = string
}

variable "parameter_group_name" {
    description = "Parameter group, usually will match with engine_version"
    type = string
}

variable "num_cache_nodes" {
    description = "Number of nodes for elasticache"
    type = number
}
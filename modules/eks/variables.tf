variable "cluster_name" {
  description = "Name of cluster - used by Terratest for e2e test automation"
  type        = string
  default     = ""
}
variable "vpc_id" {
  description = "VPC ID for EKS"
  type = string
}
variable "subnet_ids" {
  description = "Subnet IDs for EKS"
}

variable "cluster_version" {
  description = "Kubernetes cluster version"
  type        = string
}

variable "managed_node_groups" {
  description = "Spec of manage node group"
  type = any
  
}

variable "enable_sigstore" {
  description = "Enable helm sigstore policy controller"
  type = bool  
}

variable "create_namespaces" {
  description = "List of namespaces that want to create"
  type = list(object({
    name = string,
    annotations = map(string)
  }))

  default = []
  
}
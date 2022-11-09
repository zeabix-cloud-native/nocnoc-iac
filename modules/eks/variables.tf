variable "cluster_name" {
  description = "Name of cluster - used by Terratest for e2e test automation"
  type        = string
  default     = ""
}
variable "argocd_password" {
  description = "Argocd Admin password"
  type = string
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

variable "instance_types" {
  description = "Type of instance"
  type        = list(string)
}
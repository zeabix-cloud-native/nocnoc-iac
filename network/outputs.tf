output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = "${var.project_name}-cluster"
}

output "vpc_id" {
  description = "Kubernetes VPC ID"
  value       = module.network.vpc_id
}

output "subnet_ids" {
  description = "List of subnet ids for deploy EKS"
  value = module.network.cluster_subnet_ids
}
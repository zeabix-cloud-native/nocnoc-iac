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
output "vpc_id" {
  value = aws_vpc.network.id
  description = "VPC ID"
}

output "private_subnet_ids" {

  value = [
    for s in aws_subnet.subnets_private : s.id
  ]
  description = "Private Subnet IDs"
}

output "public_subnet_ids" {

  value = [
    for s in aws_subnet.subnets_public : s.id
  ]
  description = "Public Subnet IDs"
}

output "nodegroup_sg_ids" {
  value = [aws_security_group.node_group.id]
  description = "IDs of security group for nodegroup"
  
}

output "provider_key_arn" {
  value = var.enable_kms ? aws_kms_key.eks_secrets[0].arn : ""
  description = "ARN for KMS Key used for encrypt EKS secrets"
}
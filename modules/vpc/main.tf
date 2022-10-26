locals {
  tags_prefix = lower(var.project_name)
  public_subnet_tags = { 
    "kubernetes.io/cluster/${lower(var.project_name)}-cluster" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${lower(var.project_name)}-cluster" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }

}

resource "aws_vpc" "network" {
  cidr_block = var.vpc_cidr_blocks["public_cidr_block"]
  enable_dns_hostnames = true
  tags = merge({ Name = "${local.tags_prefix}-eks-vpc"}, var.tags)
}

/*
* Secondary CIDR Block for private network
*/
resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  depends_on = [
    aws_vpc.network
  ]

  vpc_id = aws_vpc.network.id
  cidr_block = var.vpc_cidr_blocks["database_cidr_block"]
}

/*
Public subnets use the ip blocks from public_cidr_block
*/
resource "aws_subnet" "subnets_public" {
  depends_on = [
    aws_vpc.network
  ]

  for_each = var.availability_zones

  vpc_id = aws_vpc.network.id
  availability_zone = each.value 
  cidr_block = cidrsubnet(var.vpc_cidr_blocks["public_cidr_block"], 2, index(keys(var.availability_zones), each.key))
  map_public_ip_on_launch = true
  tags = merge({ Name = "${local.tags_prefix}-eks-sn-${substr(each.value,-2,0)}"}, local.public_subnet_tags, var.tags)
}

/*
Private subnets use the ip blocks from private_cidr_block
*/
resource "aws_subnet" "subnets_private" {
  depends_on = [
    aws_vpc.network,
    aws_vpc_ipv4_cidr_block_association.secondary_cidr
  ]

  for_each = var.availability_zones

  vpc_id = aws_vpc.network.id
  availability_zone = each.value 
  cidr_block = cidrsubnet(var.vpc_cidr_blocks["database_cidr_block"], 6, index(keys(var.availability_zones), each.key))
  tags = merge({ Name = "${local.tags_prefix}-db-sn-${substr(each.value,-2,0)}"}, local.private_subnet_tags, var.tags)

}

# Internet Gateway
resource "aws_internet_gateway" "cluster-ig" {
  depends_on = [
    aws_vpc.network,
    aws_subnet.subnets_public
  ]

  vpc_id = aws_vpc.network.id

  tags = merge({ Name = "${local.tags_prefix}-ig-cluster"}, var.tags)
}


resource "aws_route_table" "rt-pub" {
  depends_on = [
    aws_vpc.network,
    aws_internet_gateway.cluster-ig
  ]

  vpc_id = aws_vpc.network.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cluster-ig.id
  }

  tags = merge({ Name = "${local.tags_prefix}-rt-public-zone"}, var.tags)
}

resource "aws_route_table_association" "ig_pub_subnets" {
  depends_on = [
    aws_subnet.subnets_public,
    aws_route_table.rt-pub
  ]

  for_each = var.availability_zones
  subnet_id = aws_subnet.subnets_public[each.key].id 
  route_table_id = aws_route_table.rt-pub.id  
}

#
# NAT Gateway
#

# EIP for NatGateway
resource "aws_eip" "nat-gateway-eips" {
  depends_on = [
    aws_vpc.network,
    aws_route_table_association.ig_pub_subnets
  ]

  for_each = {for k, v in var.availability_zones: k => v if contains(["az1", "az2"], k)}
  vpc = true
  tags = merge({ Name = "${local.tags_prefix}-eip-nat-${each.key}"}, var.tags)
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateways" {
  depends_on = [
    aws_vpc.network,
    aws_eip.nat-gateway-eips,
    aws_subnet.subnets_public
  ]

  for_each = {for k, v in var.availability_zones: k => v if contains(["az1", "az2"], k)}
  subnet_id = aws_subnet.subnets_public[each.key].id
  allocation_id = aws_eip.nat-gateway-eips[each.key].id
  tags = merge({ Name = "${local.tags_prefix}-nat-${each.key}"}, var.tags)
}

#NAT Route tables
resource "aws_route_table" "rt-nat-gateways" {
  depends_on = [
    aws_vpc.network,
    aws_nat_gateway.nat_gateways
  ]
  for_each = var.availability_zones

  vpc_id = aws_vpc.network.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateways[contains(["az1", "az2"], each.key) ? each.key : "az2"].id
  }

  tags = merge({ Name = "${local.tags_prefix}-rt-nat-gw-${each.key}"}, var.tags)
  
}

# NAT-Subnets associations
resource "aws_route_table_association" "nat-rt-association" {
  depends_on = [
    aws_route_table.rt-nat-gateways,
    aws_subnet.subnets_private
  ]

  for_each = var.availability_zones
  subnet_id = aws_subnet.subnets_private[each.key].id 
  route_table_id = aws_route_table.rt-nat-gateways[contains(["az1", "az2"], each.key) ? each.key : "az2"].id
}

#
# Security Group for Node Group
#
resource "aws_security_group" "node_group" {
  name_prefix = "node_group"
  vpc_id      = aws_vpc.network.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [for s in aws_subnet.subnets_private : s.cidr_block ]
  }
}

##
# KMS for encrypt secret
##
resource "aws_kms_key" "eks_secrets" {
  count = var.enable_kms ? 1 : 0
  description = "KMS EKS Cluster"
  tags = merge({ Name = "${local.tags_prefix}-kms-eks-secrets"}, var.tags)
}
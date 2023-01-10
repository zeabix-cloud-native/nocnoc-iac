
resource "aws_vpc" "network" {
  cidr_block = var.vpc_cidr_blocks["primary_cidr_block"]
  enable_dns_hostnames = true
  tags = merge({ Name = var.vpc_name } , var.tags)
}

/*
* Secondary CIDR Block for private network
*/
resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  depends_on = [
    aws_vpc.network
  ]

  vpc_id = aws_vpc.network.id
  cidr_block = var.vpc_cidr_blocks["secondary_cidr_block"]
}

/*
Private subnets use the ip blocks from primary_cidr_block
*/
resource "aws_subnet" "subnets_private" {
  depends_on = [
    aws_vpc.network
  ]

  for_each = { for config in var.private_subnet_config: config.name => config}

  vpc_id = aws_vpc.network.id
  availability_zone = each.value["availability_zone"] 
  cidr_block = cidrsubnet(var.vpc_cidr_blocks["primary_cidr_block"], 8, each.value["idx"])
  map_public_ip_on_launch = true
  tags = merge({ Name = format("%s-%s", var.primary_subnet_prefix, each.value["name"])}, local.public_subnet_tags, var.tags)
}


/*
Public subnets use the ip blocks from primary_cidr_block
*/
resource "aws_subnet" "subnets_public" {
  depends_on = [
    aws_vpc.network
  ]

  for_each = { for config in var.public_subnet_config: config.name => config}

  vpc_id = aws_vpc.network.id
  availability_zone = each.value["availability_zone"] 
  cidr_block = cidrsubnet(var.vpc_cidr_blocks["primary_cidr_block"], 8, each.value["idx"])
  map_public_ip_on_launch = true
  tags = merge({ Name = format("%s-%s", var.primary_subnet_prefix, each.value["name"])}, local.public_subnet_tags, var.tags)
}

/*
Private subnets use the ip blocks from private_cidr_block
*/
resource "aws_subnet" "subnets_cluster" {
  depends_on = [
    aws_vpc.network,
    aws_vpc_ipv4_cidr_block_association.secondary_cidr
  ]

  //for_each = var.availability_zones
  for_each = { for config in var.cluster_subnet_config: config.name => config }

  vpc_id = aws_vpc.network.id
  availability_zone = each.value["availability_zone"]
  cidr_block = cidrsubnet(var.vpc_cidr_blocks["secondary_cidr_block"], 2, each.value["idx"])
  tags = merge({ Name = format("%s-%s", var.primary_subnet_prefix, each.value["name"])}, local.cluster_subnet_tags, var.tags)

}

# Internet Gateway
# resource "aws_internet_gateway" "cluster_ig" {
#   depends_on = [
#     aws_vpc.network,
#     aws_subnet.subnets_public
#   ]

#   vpc_id = aws_vpc.network.id

#   tags = merge({ Name = "${local.tags_prefix}-ig-cluster"}, var.tags)
# }


resource "aws_route_table" "rt-pub" {
  depends_on = [
    aws_vpc.network
#    aws_internet_gateway.cluster_ig
  ]

  vpc_id = aws_vpc.network.id

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = var.transit_gateway_id
 #  gateway_id = aws_internet_gateway.cluster_ig.id
  } 

  tags = merge({ Name = "${local.tags_prefix}-rt-public-zone"}, var.tags)
}

resource "aws_route_table" "rt-cluster" {
  depends_on = [
    aws_vpc.network
#    aws_internet_gateway.cluster_ig
  ]

  vpc_id = aws_vpc.network.id

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = var.transit_gateway_id
 #  gateway_id = aws_internet_gateway.cluster_ig.id
  } 

  tags = merge({ Name = "${local.tags_prefix}-rt-cluster-zone"}, var.tags)
}


resource "aws_route_table_association" "ig_pub_subnets" {
  depends_on = [
    aws_subnet.subnets_public,
    aws_route_table.rt-pub
  ]

  for_each = { for config in var.public_subnet_config: config.availability_zone => config }
  subnet_id = aws_subnet.subnets_public[each.value.name].id 
  route_table_id = aws_route_table.rt-pub.id  
}

## 
## Associate cluster subnet to transit gateway
##
resource "aws_route_table_association" "ig_cluster_subnets" {
  depends_on = [
    aws_subnet.subnets_public,
    aws_route_table.rt-pub
  ]

  for_each = { for config in var.cluster_subnet_config: config.availability_zone => config }
  subnet_id = aws_subnet.subnets_cluster[each.value.name].id 
  route_table_id = aws_route_table.rt-cluster.id  
}


#
# NAT Gateway
#

# EIP for NatGateway
# resource "aws_eip" "nat-gateway-eips" {
#   depends_on = [
#     aws_vpc.network,
#     aws_route_table_association.ig_pub_subnets
#   ]

#   for_each = {for config in var.public_subnet_config: config.availability_zone => config}
#   vpc = true
#   tags = merge({ Name = "${local.tags_prefix}-eip-nat-${each.key}"}, var.tags)
# }

# NAT Gateway
# resource "aws_nat_gateway" "nat_gateways" {
#   depends_on = [
#     aws_vpc.network,
#     aws_eip.nat-gateway-eips,
#     aws_subnet.subnets_public
#   ]

#   for_each = {for config in var.public_subnet_config: config.availability_zone => config }
#   subnet_id = aws_subnet.subnets_public[each.value.name].id
#   allocation_id = aws_eip.nat-gateway-eips[each.key].id
#   tags = merge({ Name = "${local.tags_prefix}-nat-${each.key}"}, var.tags)
# }

#NAT Route tables
# resource "aws_route_table" "rt-nat-gateways" {
#   depends_on = [
#     aws_vpc.network,
#     aws_nat_gateway.nat_gateways
#   ]
#   for_each = { for config in var.cluster_subnet_config: config.availability_zone => config }

#   vpc_id = aws_vpc.network.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_gateways[each.key].id
#   }

#   tags = merge({ Name = "${local.tags_prefix}-rt-nat-gw-${each.key}"}, var.tags)
  
# }

# NAT-Subnets associations
# resource "aws_route_table_association" "nat-rt-association" {
#   depends_on = [
#     aws_route_table.rt-nat-gateways,
#     aws_subnet.subnets_cluster
#   ]

#   for_each = { for sub in var.cluster_subnet_config: sub.availability_zone => sub }
#   subnet_id = aws_subnet.subnets_cluster[each.value.name].id 
#   route_table_id = aws_route_table.rt-nat-gateways[each.key].id
# }

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

    cidr_blocks = [for s in aws_subnet.subnets_cluster : s.cidr_block ]
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

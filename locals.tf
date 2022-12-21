locals {
  subnetID = concat(module.network.private_subnet_ids,module.network.public_subnet_ids)

  managed_node_groups = { for k, v in var.managed_node_groups: k => {
        node_group_name = v.node_group_name
        instance_types  = v.instance_types #var.instance_types
        min_size        = v.min_size
        max_size        = v.max_size
        desired_size    = v.desired_size
        ami_type        = v.ami_type
        capacity_type   = v.capacity_type
        labels          = v.labels
        taints          = v.taints
        tags            = v.tags
        
        subnet_ids      = local.subnetID
  }}
}

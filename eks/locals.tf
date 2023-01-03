locals {
  //subnetID = concat(data.terraform_remote_state.network.private_subnet_ids,data.terraform_remote_state.network.public_subnet_ids)
  subnetID = data.terraform_remote_state.network.outputs.subnet_ids

  managed_node_groups = { for k, v in var.managed_node_groups: k => {
        node_group_name = v.node_group_name
        instance_types  = v.instance_types
        min_size        = v.min_size
        max_size        = v.max_size
        desired_size    = v.desired_size
        ami_type        = v.ami_type
        capacity_type   = v.capacity_type
        k8s_labels          = v.k8s_labels
        k8s_taints          = v.k8s_taints
        additional_tags            = v.additional_tags
        
        subnet_ids      = local.subnetID
  }}
}

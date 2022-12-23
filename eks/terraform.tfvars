region         = "ap-southeast-1"

### Remote state data configuration for network
bucket         = "nocnoc-devops-prod"
key_state      = "terraform-prod/network/terraform.tfstate"


project_name             = "nocnoc-production"

enable_sigstore = true
### Cluster ZONE 
cluster_version          = "1.24"
cluster_name             = "nocnoc_cluster"
tags                     = {
    Platform = "eks"
    Owner= ""
    Env = "production"
}
enable_kms               = true

### NodeGroup
managed_node_groups = {
    mg_ondemand = {
      node_group_name = "managed-ondemand"
      instance_types  = ["t4g.2xlarge"]
      min_size        = 3
      max_size        = 9
      desired_size    = 3

      ami_type = "AL2_x86_64"

      capacity_type  = "ON_DEMAND"  # ON_DEMAND or SPOT
      labels = {}
      taints = []
      tags = {}
    }
    ## For Additional node group in the future
    ## Example
    # mg_gpu = {
    #   node_group_name = "managed-gpu-ondemand"
    #   instance_types  = ["t3.medium"]
    #   min_size        = 3
    #   max_size        = 9
    #   desired_size    = 3

    #   ami_type = "AL2_x86_64"

    #   capacity_type  = "ON_DEMAND"  # ON_DEMAND or SPOT
    #   labels = {}
    #   taints = []
    #   tags = {}
    # }
  }





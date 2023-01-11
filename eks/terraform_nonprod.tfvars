region         = "ap-southeast-1"

### Remote state data configuration for network
bucket         = "nocnoc-devops-nonprod"
key_state      = "terraform-nonprod/network/terraform.tfstate"


project_name             = "nocnoc-nonproduction"

enable_sigstore = false
### Cluster ZONE 
cluster_version          = "1.24"
cluster_name             = "nocnoc_nonprod_cluster"
tags                     = {
    Platform = "eks"
    Owner= ""
    Env = "nonproduction"
}
enable_kms               = true

### NodeGroup
managed_node_groups = {
    mg_ondemand = {
      node_group_name = "managed-general-ondemand"
      instance_types  = ["t3a.xlarge"] 
      min_size        = 1
      max_size        = 2
      desired_size    = 1

      ami_type = "AL2_x86_64" # AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, BOTTLEROCKET_x86_64, BOTTLEROCKET_ARM_64

      capacity_type  = "ON_DEMAND"  # ON_DEMAND or SPOT
      k8s_labels = {
        Capability  = "general"
        InstanceType  = "ondemand"
      }
      k8s_taints = []
      additional_tags = {}
    }
    mg_spot = {
      node_group_name = "managed-general-spot"
      instance_types  = ["t3a.xlarge"]
      min_size        = 1
      max_size        = 2
      desired_size    = 1

      ami_type = "AL2_x86_64"  # AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, BOTTLEROCKET_x86_64, BOTTLEROCKET_ARM_64

      capacity_type  = "SPOT"  # ON_DEMAND or SPOT
      k8s_labels = {
        Capability  = "general"
        InstanceType = "spot"
      }
      k8s_taints = []
      additional_tags = {}
    }
}

# User defined namespaces for nonproduction cluster
# e.g. app-dev, app-qa, app-uat
#
create_namespaces = [ {
  annotations = {
    "nocnoc.com/environment" = "development"
  }

/*
  // Uncomment this if plan to adopt istio for this namespace
  labels = {
      istio-injection = "enabled"
  }
*/

  name = "app-dev"
},
{
  annotations = {
    "nocnoc.com/environment" = "qa"
  }

  /*
  // Uncomment this if plan to adopt istio for this namespace
  labels = {
      istio-injection = "enabled"
  }
*/

  name = "app-qa"
},
{
  annotations = {
    "nocnoc.com/environment" = "pre-production"
  }

  /*
  // Uncomment this if plan to adopt istio for this namespace
  labels = {
      istio-injection = "enabled"
  }
*/

  name = "app-uat"
}]






provider "kubernetes" {
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks_blueprints.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks_blueprints.eks_cluster_id
}

module "eks_blueprints" {
#  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.12.0"
  source = "github.com/aws-ia/terraform-aws-eks-blueprints"


  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id             = var.vpc_id
  private_subnet_ids = var.subnet_ids

  managed_node_groups = {
    mg_ondemand = {
      node_group_name = "managed-spot-ondemand"
#      instance_types  = ["m5.large"]
      instance_types  = var.instance_types
      min_size        = 3
      max_size        = 9
      desired_size    = 3
      subnet_ids      = var.subnet_ids
    }
    mg_gpu = {
      node_group_name = "managed-gpu-ondemand"
#      instance_types  = ["m5.large"]
      instance_types  = var.instance_types
      min_size        = 3
      max_size        = 9
      desired_size    = 3
      subnet_ids      = var.subnet_ids
    }
  }
}

module "eks_blueprints_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.12.0"

  eks_cluster_id       = module.eks_blueprints.eks_cluster_id
  eks_cluster_endpoint = module.eks_blueprints.eks_cluster_endpoint
  eks_oidc_provider    = module.eks_blueprints.oidc_provider
  eks_cluster_version  = module.eks_blueprints.eks_cluster_version

  # EKS Managed Add-ons
  enable_amazon_eks_vpc_cni            = true
  enable_amazon_eks_coredns            = true
  enable_amazon_eks_kube_proxy         = true
  enable_amazon_eks_aws_ebs_csi_driver = true

  # Add-ons
  enable_aws_load_balancer_controller = true
  enable_metrics_server               = true
  enable_aws_cloudwatch_metrics       = true
  enable_kubecost                     = true
  enable_kube_prometheus_stack        = true

  enable_cluster_autoscaler = true
  cluster_autoscaler_helm_config = {
    set = [
      {
        name  = "podLabels.prometheus\\.io/scrape",
        value = "true",
        type  = "string",
      }
    ]
  }

  enable_cert_manager = true
  cert_manager_helm_config = {
    set_values = [
      {
        name  = "extraArgs[0]"
        value = "--enable-certificate-owner-ref=false"
      },
    ]
  }
  enable_cert_manager_csi_driver = true
  enable_argocd = true
  # This example shows how to set default ArgoCD Admin Password using SecretsManager with Helm Chart set_sensitive values.
  argocd_helm_config = {
    set_sensitive = [
      {
        name  = "configs.secret.argocdServerAdminPassword"
        value = bcrypt(var.argocd_password)
      }
    ]
  }

  argocd_manage_add_ons = true # Indicates that ArgoCD is responsible for managing/deploying add-ons

}

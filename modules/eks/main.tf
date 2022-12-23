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
locals {
  istio_charts_url = "https://istio-release.storage.googleapis.com/charts"
}

module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.15.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id             = var.vpc_id
  private_subnet_ids = var.subnet_ids
  managed_node_groups = var.managed_node_groups
}

module "eks_blueprints_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.15.0"

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
    timeout          = "1200"
    set_sensitive = [
      {
        name  = "configs.secret.argocdServerAdminPassword"
        value = bcrypt(data.aws_secretsmanager_secret_version.admin_password_version.secret_string)
      }
    ]
  }

  argocd_manage_add_ons = true # Indicates that ArgoCD is responsible for managing/deploying add-ons

  argocd_applications     = {
    blogs-service = {
      path                = "chart"
      lint                = true
      repo_url            = "https://github.com/amornc/nocnoc-iac.git"
      values              = {}
      add_on_application  = true # Indicates the root add-on application.
    }
  }
}


resource "random_password" "argocd" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "suffix" {
  length           = 4
  special          = true
  override_special = "0123456789"
}

resource "aws_secretsmanager_secret" "arogcd" {
  name                    = format("%s-%s", "argocd", random_password.suffix.result)
  recovery_window_in_days = 0 # Set to zero for this example to force delete during Terraform destroy
}

resource "aws_secretsmanager_secret_version" "arogcd" {
  secret_id     = aws_secretsmanager_secret.arogcd.id
  secret_string = random_password.argocd.result
}

data "aws_secretsmanager_secret_version" "admin_password_version" {
  secret_id = aws_secretsmanager_secret.arogcd.id

  depends_on = [aws_secretsmanager_secret_version.arogcd]
}

resource "helm_release" "opensearch" {
  depends_on = [
    module.eks_blueprints,
    kubernetes_namespace.monitoring
  ]
  name  = "opensearch"

  repository = "https://opensearch-project.github.io/helm-charts"
  chart      = "opensearch"
  namespace  = "monitoring"
  create_namespace = true

}

resource "helm_release" "fluentbit" {
  depends_on = [
    module.eks_blueprints,
    kubernetes_namespace.monitoring
  ]
  name = "fluentbit"
  repository = "https://fluent.github.io/helm-charts"
  chart = "fluent-bit"
  namespace = "monitoring"
  create_namespace = "true"
}

resource "helm_release" "istio-base" {
  repository       = local.istio_charts_url
  chart            = "base"
  name             = "istio-base"
  namespace        = "istio-system"
  version          = "1.12.1"
  create_namespace = true
}
resource "helm_release" "istiod" {
  repository       = local.istio_charts_url
  chart            = "istiod"
  name             = "istiod"
  version          = "1.12.1"
  namespace        = "istio-system"
  depends_on       = [helm_release.istio-base]

  set {
    name  = "meshConfig.enableTracing"
    value = "true"
  }

  set {
    name  = "meshConfig.accessLogFile"
    type  = "string"
    value = "/dev/stdout"
  }

  set {
    name  = "meshConfig.defaultConfig.tracing.sampling"
    type  = "string"
    value = 50
  }
}
resource "kubernetes_namespace" "istio-ingress" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }

    name = "istio-ingress"
  }
}
/*
resource "helm_release" "istio-ingress" {
  repository = local.istio_charts_url
  chart      = "gateway"
  name       = "istio-ingressgateway"
  version    = "1.12.1"
  depends_on = [
    helm_release.istiod,
    module.eks_blueprints_kubernetes_addons.enable_aws_load_balancer_controller
    ]
}
*/

resource "kubernetes_namespace" "tracing" {
  metadata {
    name = "tracing"
  }
}
resource "kubernetes_namespace" "cosign-system" {
  metadata {
    name = "cosign-system"
  }
}
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}
/*
resource "helm_release" "elastic" {
  repository = "https://helm.elastic.co"
  chart = "elasticsearch"
  name = "elasticsearch"
  namespace = "monitoring"
  values = [
    "${file("../helm/elasticsearch/values.yaml")}"
  ]
  depends_on = [
    kubernetes_namespace.monitoring
  ]
}


resource "helm_release" "zipkin" {
  chart = "helm/zipkins"
  name = "zipkin"
  namespace = "monitoring"
  values = [
    "${file("../helm/zipkins/values.yaml")}"
  ]
   depends_on = [
    helm_release.elastic,
    kubernetes_namespace.monitoring 
  ]
}
*/

resource "helm_release" "prometheus-pushgateway" {
  repository = "https://prometheus-community.github.io/helm-charts"
  chart = "prometheus-pushgateway"
  name = "prometheus-pushgateway"
  namespace = "monitoring"
  depends_on = [
    kubernetes_namespace.monitoring
  ]
}

resource "helm_release" "sigstore" {
  count = var.enable_sigstore ? 1 : 0
  repository = "https://sigstore.github.io/helm-charts"
  chart = "policy-controller"
  name = "policy-controller"
  namespace = "cosign-system"
  depends_on = [
    kubernetes_namespace.cosign-system
  ]
}

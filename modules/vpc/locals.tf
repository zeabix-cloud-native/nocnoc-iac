locals {
  tags_prefix = lower(var.project_name)
  public_subnet_tags = { 
    "kubernetes.io/cluster/${lower(var.project_name)}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  cluster_subnet_tags = { 
    "kubernetes.io/cluster/${lower(var.project_name)}" = "shared"
    "kubernetes.io/role/internal-elb"                      = 1
  }

# DB subnet
  private_subnet_tags = {
    # "kubernetes.io/cluster/${lower(var.project_name)}" = "shared"
    # "kubernetes.io/role/internal-elb"             = 1
  }

  alb_subnet_tags = { 
    "kubernetes.io/cluster/${lower(var.project_name)}" = "shared"
    "kubernetes.io/role/internal-elb"                      = 1
  }

}
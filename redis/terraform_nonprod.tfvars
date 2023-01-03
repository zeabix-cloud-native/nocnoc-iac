region         = "ap-southeast-1"

### Remote state data configuration for network
bucket         = "nocnoc-devops-nonprod"
key_state      = "terraform-nonprod/network/terraform.tfstate"

cluster_id = "redis-session-poc"
node_type = "cache.t2.small"
subnet_group_name = "elasticache-redis-dev-sg"
port = 6379
engine_version = "5.0.0"
parameter_group_name = "default.redis5.0"
num_cache_nodes = 1
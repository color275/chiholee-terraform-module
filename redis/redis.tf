resource "aws_elasticache_replication_group" "redis" {
  preferred_cache_cluster_azs = var.preferred_cache_cluster_azs
  # preferred_cache_cluster_azs = ["ap-northeast-2a",]
  replication_group_id        = var.service_name
  description                 = var.service_name
  num_cache_clusters       = var.redis_num_cache_clusters
  parameter_group_name        = var.redis_parameter_group_name
  port                        = var.redis_port
  engine         = var.redis_engine
  engine_version = var.redis_engine_version
  node_type                   = var.redis_node_type
  subnet_group_name = aws_elasticache_subnet_group.redis.name

  auth_token = var.redis_auth_token
  transit_encryption_enabled = true
  at_rest_encryption_enabled = true
  
  security_group_ids = [aws_security_group.this.id,]

  log_delivery_configuration {
    destination      = "elasticache-engine-log"
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "engine-log"
  }
  log_delivery_configuration {
    destination      = "elasticache-slow-log"
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "slow-log"
  }

  tags = merge(
                var.tags, 
                {   
                  Name = lower("${var.service_name}-redis")
                }
  ) 

  lifecycle {
    ignore_changes = [
                        number_cache_clusters,
                        replication_group_id,                      
                     ]
  }
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.service_name}-subnet-group"
  subnet_ids = var.subnet_ids

  lifecycle {
    ignore_changes = [
                        name
                     ]
  }
}


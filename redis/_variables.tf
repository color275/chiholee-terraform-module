variable vpc_id {
  type = string
}

variable preferred_cache_cluster_azs {
  type = list
}

variable subnet_ids {
  type = list
}

variable service_name {
  type = string
}

variable redis_num_cache_clusters {
  type = string
}

variable redis_parameter_group_name {
  type = string
}

variable redis_port {
  type = number
}

variable redis_engine {
  type = string
}

variable redis_engine_version {
  type = string
}

variable redis_node_type {
  type = string
}

variable redis_auth_token {
  type = string
}

variable "ingress_rules" {
  type = list(tuple([string, string, string, list(string), string, string]))
  default = []
}

variable tags {
  type = map(string)
  default = {}
}


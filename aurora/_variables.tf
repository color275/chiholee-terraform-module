variable env {
  type = string
}

variable project_name {
  type = string
}

variable service_name {
  type = string
}

variable rds_engine {
  type = string
}

variable rds_engine_version {
  type = string
}

variable rds_master_username {
  type = string
}

variable rds_master_password {
  type = string
}

variable enabled_cloudwatch_logs_exports {
  type = list
  default = []
}

variable "instance_cnt" {
  default = 1
}

variable "instance_class" {
  type = string
}

variable long_query_time {
  type = number
  default = 3
}

variable vpc_id {
  type = string
}

variable subnet_ids {
  type = list
}

variable skip_final_snapshot {
  type = bool
  default = false
}

variable "ingress_rules" {
  type = list(tuple([string, string, string, list(string), string, string]))
  default = []
}


variable auto_on_off {
  type        = bool
  default = false
}

variable tags {
  type = map(string)
  default = {}
}

variable db_subnet_security_group_id {
  type = string
}


variable backup_retention_period {
  type = number
  default = 5
}

variable preferred_backup_window {
  type = string
  default = "18:00-19:00"
}
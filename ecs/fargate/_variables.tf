variable "env"  {
  type = string
}

variable "project_name"  {
  type = string
}

variable "service_name"  {
  type = string
}

variable security_groups {
  type = list
  default = []
}

variable "vpc_id" {
  type = string
}

variable "ecs_cluster_id" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "container_subnet_ids" {
  type = list
}

variable "lb_subnet_ids" {
  type = list
}

variable "load_balancer_type" {
  type = string
  default = "application"
}

variable private_ip1 {
  type = string
  default = null
}

variable private_ip2 {
  type = string
  default = null
}

variable private_ip_yn {
  type = bool
  default = false
}

variable "container_name" {
  type    = string
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "lb_test_listener_port" {
  type    = number
}

variable "blue_target_group_port" {
  type    = number
}

variable "green_target_group_port" {
  type    = number
}

variable "target_group_health_check_path" {
  type    = string
  default = "/"
}

variable "target_group_health_check_macher" {
  type    = string
  default = "200"
}

variable "host_port" {
  type    = number
}

variable "container_port" {
  type    = number
}

variable "taskdef_path" {
  type = string
}

variable "ecr_repository_url" {
  type = string
}


variable "ingress_rules" {
  type = list(tuple([string, string, string, string, string]))
}

variable "nlb_ingress_rules" {
  type = list
  default = null
}

variable "account_id" {
  type = string
}

variable execution_managed_policy_arns {
  type = list
  default = []
}

variable task_managed_policy_arns {
  type = list
  default = []
}

variable "kms_key_id" {
  type = string
}

variable "parameter_list" {
  type        = list(tuple([string,string,string]))
  default = []
}

variable "action_on_timeout" {
  type = string
}

variable "wait_time_in_minutes" {
  type = number
}

variable lb_internal {
  type = bool
}

variable "lb_ingress_rules" {
  type = list(tuple([string, string, string, list(string), string, string]))
}

variable "lb_listener_port" {
  type    = number
  default = 80
}

variable certificate_arn {
  type = string  
  default = null
}

variable https_yn {
  type = bool
  default = false
}

variable retention_in_days {
  type = number
  default = 30
}

variable source_bucket_name {
  type = string
}

variable kms_arn {
  type = string
}

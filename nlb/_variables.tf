variable "vpc_id" {
    type = string
}

variable "app_name" {
    type = string
}

variable "ec2_name" {
    type = string
}

variable "subnet_ids" {
    type = list
}

variable "listener_port" {
    type = number
}

variable "target_group_port" {
    type = number
}

variable "private_ip_yn" {
    type = bool
    default = false
}

variable "private_ip1" {
    type = string
    default = ""
}

variable "private_ip2" {
    type = string
    default = ""
}

variable "internal" {
  type = bool  
  default = false
}

